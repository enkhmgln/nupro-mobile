import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:g_json/g_json.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/routes/home_route.dart';
import 'package:nuPro/library/utils/constants.dart';
import 'package:nuPro/library/utils/extension.dart';
import 'package:nuPro/library/utils/log.dart';
import 'package:nuPro/library/components/widgets/incoming_call_modal.dart';
import 'package:nuPro/library/routes/dynamic_route.dart';
import 'package:nuPro/screens/home/model/nurse_treatment_model.dart';
import 'package:nuPro/screens/pay/qpay/models/qpay_model.dart';
import 'package:nuPro/screens/pay/qpay/models/qpay_screen_model.dart';

class MainController extends IOController with WidgetsBindingObserver {
  int? get currentCallId => _currentCallId;
  String? get currentCallStatus => _currentCallStatus;
  final pushData = JSON.nil.obs;

  Timer? _pollingTimer;
  bool _isPolling = false;
  int? _currentCallId;
  String? _currentCallStatus;
  bool _isNavigating = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    getFcmToken();
    if (HelperManager.isLogged) {
      getUserInfo();
      startPollingForActiveCalls();
      handlePendingCallData();
      handlePendingIncomingCall();
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollingTimer?.cancel();
    // Clean up any active CallKit sessions
    FlutterCallkitIncoming.endAllCalls();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        Log.success(
            'App resumed - checking for pending calls', 'MainController');
        if (HelperManager.isLogged) {
          handlePendingCallData();
          handlePendingIncomingCall();
        }
        break;
      case AppLifecycleState.paused:
        Log.success('App paused', 'MainController');
        break;
      case AppLifecycleState.inactive:
        Log.success('App inactive', 'MainController');
        break;
      case AppLifecycleState.detached:
        Log.success('App detached - cleaning up CallKit', 'MainController');
        FlutterCallkitIncoming.endAllCalls();
        break;
      case AppLifecycleState.hidden:
        Log.success('App hidden', 'MainController');
        break;
    }
  }

  Future getUserInfo() async {
    final response = await UserApi().userInfo();
    if (response.isSuccess) {
      final profile = ProfileModel.fromJson(response.data);
      await UserStoreManager.shared.write(kProfileUser, profile.toMap());
      if (profile.userType == 'nurse') {
        await IOPages.toNurse();
      } else {
        await IOPages.toHome();
      }
    } else {
      showError(text: response.message);
    }
  }

  getFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    Log.warning(fcmToken ?? 'NOTOKEN', 'FCM Token');
    DeviceStoreManager.shared.write(kFcmToken, fcmToken ?? 'NOTOKEN');
  }

  Future<void> handlePendingCallData() async {
    try {
      final pendingCallData = DeviceStoreManager.shared
          .data<Map<String, dynamic>>('pending_call_data');
      if (pendingCallData != null) {
        Log.success(
          'Found pending call data, navigating to call map',
          'MainController',
        );

        final callDetailInfoModel = CallDetailInfoModel.fromJson(
          JSON(pendingCallData),
        );

        // Clear the pending data
        await DeviceStoreManager.shared.deleteKey('pending_call_data');

        // Navigate to call map
        final userType = HelperManager.profileInfo.userType;
        if (userType == 'nurse') {
          await HomeRoute.toNurseCallGoogleMap(
            callDetailInfoModel: callDetailInfoModel,
          );
        } else {
          await HomeRoute.toCustomerCallGoogleMap(
            callDetailInfoModel: callDetailInfoModel,
          );
        }
      }
    } catch (e) {
      Log.error('Error handling pending call data: $e', 'MainController');
    }
  }

  Future<void> handlePendingIncomingCall() async {
    try {
      final pendingIncomingCall = DeviceStoreManager.shared
          .data<Map<String, dynamic>>('pending_incoming_call');

      if (pendingIncomingCall != null) {
        Log.success(
          'Found pending incoming call, showing modal',
          'MainController',
        );

        final callId = pendingIncomingCall['call_id']?.toString() ?? '';
        final callerName =
            pendingIncomingCall['caller_name']?.toString() ?? 'Хэрэглэгч';
        final callerPhone =
            pendingIncomingCall['caller_phone']?.toString() ?? '';
        final double? latitude =
            (pendingIncomingCall['latitude'] as num?)?.toDouble();
        final double? longitude =
            (pendingIncomingCall['longitude'] as num?)?.toDouble();
        final Map<String, dynamic>? healthMap =
            pendingIncomingCall['health_info'] == null
                ? null
                : Map<String, dynamic>.from(
                    pendingIncomingCall['health_info'],
                  );
        final healthInfo =
            healthMap != null ? CallerHealthInfo.fromJson(healthMap) : null;
        final callStatus = pendingIncomingCall['call_status']?.toString();
        final callType = pendingIncomingCall['call_type']?.toString();
        final tsStr = pendingIncomingCall['timestamp']?.toString();
        final timestamp = tsStr != null ? DateTime.tryParse(tsStr) : null;

        // Clear the pending data
        await DeviceStoreManager.shared.deleteKey('pending_incoming_call');

        // Show incoming call modal only for nurses
        final userType = HelperManager.profileInfo.userType;
        if (userType == 'nurse') {
          // Add a small delay to ensure UI is ready
          await Future.delayed(const Duration(milliseconds: 1000));

          await DynamicRoute.sendCallToNurse(
            callId: callId,
            callerName: callerName,
            callerPhone: callerPhone,
            latitude: latitude,
            longitude: longitude,
            healthInfo: healthInfo,
            callStatus: callStatus,
            callType: callType,
            timestamp: timestamp,
          );
          // Result/handlers handled by DynamicRoute
        }
      }
    } catch (e) {
      Log.error('Error handling pending incoming call: $e', 'MainController');
    }
  }

  // Incoming call accept/decline are handled centrally by DynamicRoute now.

  void startPollingForActiveCalls() {
    if (_isPolling) return;

    _isPolling = true;

    checkForActiveCall();

    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      checkForActiveCall();
    });
  }

  void stopPollingForActiveCalls() {
    if (!_isPolling) return;

    _isPolling = false;
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> checkForActiveCall() async {
    try {
      final userType = HelperManager.profileInfo.userType;
      Log.success(
          'Checking active call for userType: $userType', 'MainController');

      if (userType == 'nurse') {
        // For nurses, check booking history for pending and accepted calls
        await _checkForNurseCalls();
      } else if (userType == 'customer' || userType == 'user') {
        // For customers, use the original active call check
        await _checkForActiveCustomerCalls();
      } else {
        Log.warning('Unknown userType: $userType, skipping active call check',
            'MainController');
      }
    } catch (e) {
      Log.error('Error checking active call: $e', 'MainController');
      // Don't call any API if there's an error getting user type
    }
  }

  Future<void> _checkForNurseCalls() async {
    try {
      // Get all recent calls (not just pending)
      final response = await CustomerApi().getTreatment(
        limit: 10, // Increased limit to catch more calls
      );

      if (response.isSuccess) {
        final allCalls = response.data.listValue
            .map((e) => NurseTreatmentModel.fromJson(e))
            .toList();

        // Separate calls by status
        final pendingCalls =
            allCalls.where((call) => call.status == 'pending').toList();
        final acceptedCalls =
            allCalls.where((call) => call.status == 'accepted').toList();

        Log.success(
          'Found ${pendingCalls.length} pending calls, ${acceptedCalls.length} accepted calls',
          'MainController',
        );

        // Priority 1: Check for accepted calls (nurse should be on map screen)
        if (acceptedCalls.isNotEmpty) {
          final latestAcceptedCall = acceptedCalls.first;

          Log.success(
            'Accepted call found: ${latestAcceptedCall.id}, navigating to map',
            'MainController',
          );

          // Check if this is a new accepted call
          if (_currentCallId != latestAcceptedCall.id ||
              _currentCallStatus != latestAcceptedCall.status) {
            _currentCallId = latestAcceptedCall.id;
            _currentCallStatus = latestAcceptedCall.status;

            if (!_isNavigating) {
              await _navigateToAcceptedCall(latestAcceptedCall);
            }
          }
        }
        // Priority 2: Check for pending calls (show modal)
        else if (pendingCalls.isNotEmpty) {
          final latestPendingCall = pendingCalls.first;

          Log.success(
            'Pending call found: ${latestPendingCall.id}',
            'MainController',
          );

          // Check if this is a new pending call
          if (_currentCallId != latestPendingCall.id ||
              _currentCallStatus != latestPendingCall.status) {
            _currentCallId = latestPendingCall.id;
            _currentCallStatus = latestPendingCall.status;

            if (!_isNavigating) {
              await _showPendingCallModal(latestPendingCall);
            }
          }
        } else {
          // No active calls (pending or accepted)
          if (_currentCallId != null) {
            Log.success('No more active calls', 'MainController');
            _currentCallId = null;
            _currentCallStatus = null;
          }
        }
      } else {
        Log.error(
          'Failed to check nurse calls: ${response.message}',
          'MainController',
        );
      }
    } catch (e) {
      Log.error('Error checking nurse calls: $e', 'MainController');
    }
  }

  Future<void> _checkForActiveCustomerCalls() async {
    try {
      final response = await CallApi().getActiveCall();

      if (response.isSuccess) {
        final activeCall = ActiveCallModel.fromJson(response.data);

        if (activeCall.hasActiveCall && activeCall.callId != null) {
          Log.success(
            'Active call found: ${activeCall.callId}',
            'MainController',
          );

          // Check if this is a new call or status change
          if (_currentCallId != activeCall.callId ||
              _currentCallStatus != activeCall.status) {
            _currentCallId = activeCall.callId;
            _currentCallStatus = activeCall.status;

            if (!_isNavigating) {
              await getCallDetailsAndNavigate(activeCall.callId!);
            }
          }
        } else {
          // No active call
          if (_currentCallId != null) {
            Log.success('Call ended or cancelled', 'MainController');
            _currentCallId = null;
            _currentCallStatus = null;
            // Navigate back to home or show call ended message
            handleCallEnded();
          }
        }
      } else {
        Log.error(
          'Failed to check active call: ${response.message}',
          'MainController',
        );
      }
    } catch (e) {
      Log.error('Error checking active call: $e', 'MainController');
    }
  }

  Future<void> _navigateToAcceptedCall(NurseTreatmentModel acceptedCall) async {
    try {
      Log.success(
          'Navigating to accepted call: ${acceptedCall.id}', 'MainController');

      _isNavigating = true;

      // Show processing dialog
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.map,
                      color: Colors.blue,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Идэвхтэй дуудлага олдлоо',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Та газрын зураг руу шилжиж байна.\nТүр хүлээнэ үү...',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Get detailed call information for navigation
      final detailResponse = await NurseApi().bookingsCallsDetailInfo(
        id: acceptedCall.id,
      );

      Get.back(); // Close processing dialog

      if (detailResponse.isSuccess) {
        final callDetailInfoModel = CallDetailInfoModel.fromJson(
          detailResponse.data,
        );

        Log.success(
            'Call details retrieved, navigating to map', 'MainController');

        await HomeRoute.toNurseCallGoogleMap(
          callDetailInfoModel: callDetailInfoModel,
        );
      } else {
        Log.error('Failed to get call details: ${detailResponse.message}',
            'MainController');
        showError(text: 'Дуудлагын дэлгэрэнгүй мэдээлэл татахад алдаа гарлаа');
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back(); // Close dialog if still open
      }
      Log.error('Error navigating to accepted call: $e', 'MainController');
      showError(text: 'Дуудлагын газрын зураг руу шилжихэд алдаа гарлаа');
    } finally {
      _isNavigating = false;
    }
  }

  Future<void> _showPendingCallModal(NurseTreatmentModel pendingCall) async {
    try {
      Log.success('Showing pending call modal for call: ${pendingCall.id}',
          'MainController');

      // Add a small delay to ensure UI is ready
      await Future.delayed(const Duration(milliseconds: 1000));

      // Get call details from API to extract health info
      final detailResponse =
          await NurseApi().bookingsCallsDetailInfo(id: pendingCall.id);
      CallerHealthInfo? healthInfo;
      if (detailResponse.isSuccess) {
        final callDetail = CallDetailInfoModel.fromJson(detailResponse.data);
        healthInfo = CallerHealthInfo(
          isHealthy: callDetail.customerHealthStatus,
          hasRegularMedication: callDetail.customerHasMedication,
          regularMedicationDetails: callDetail.customerMedicationDetails,
          hasAllergies: callDetail.customerHasAllergies,
          allergyDetails: callDetail.customerAllergyDetails,
          hasDiabetes: callDetail.customerHasDiabetes,
          hasHypertension: callDetail.customerHasHypertension,
          hasEpilepsy: callDetail.customerHasEpilepsy,
          hasHeartDisease: callDetail.customerHasHeartDisease,
          medicalConditionsSummary: callDetail.customerMedicalConditionsSummary,
          additionalNotes: callDetail.customerAdditionalHealthNotes,
        );
      }
      await DynamicRoute.sendCallToNurse(
        callId: pendingCall.id.toString(),
        callerName: 'Customer (${pendingCall.customerPhone})',
        callerPhone: pendingCall.customerPhone,
        healthInfo: healthInfo,
        callStatus: pendingCall.status,
        callType: pendingCall.serviceType,
        timestamp: DateTime.tryParse(pendingCall.createdAt),
      );
    } catch (e) {
      Log.error('Error showing pending call modal: $e', 'MainController');
    } finally {
      _isNavigating = false;
    }
  }

  Future<void> getCallDetailsAndNavigate(int callId) async {
    try {
      final response = await CallApi().getCallDetails(callId: callId);

      if (!response.isSuccess) {
        Log.error(
          'Failed to get call details: ${response.message}',
          'MainController',
        );
        return;
      }

      final callDetail = CallDetailInfoModel.fromJson(response.data);
      print('Call Detail: $callDetail');

      Log.success(
        'Call details retrieved: ${callDetail.status}',
        'MainController',
      );

      final userType = HelperManager.profileInfo.userType;

      // **Сувилагчийн хувьд төлбөр шалгахгүйгээр шууд map руу оруулах**
      if (userType == 'nurse') {
        await HomeRoute.toNurseCallGoogleMap(callDetailInfoModel: callDetail);
        return;
      }

      // Navigate if payment is done
      if (callDetail.paymentStatus == 'paid') {
        final userType = HelperManager.profileInfo.userType;
        if (userType == 'customer') {
          await HomeRoute.toCustomerCallGoogleMap(
            callDetailInfoModel: callDetail,
          );
        } else {
          await HomeRoute.toNurseCallGoogleMap(callDetailInfoModel: callDetail);
        }
        return;
      } else {
        await handleCallAccepted(callDetail);
      }

      // Convert status string to enum safely
      CallStatus? statusEnum;
      try {
        statusEnum = CallStatus.fromString(callDetail.status);
      } catch (e) {
        Log.warning(
          'Unknown call status: ${callDetail.status}',
          'MainController',
        );
      }

      if (statusEnum != null) {
        switch (statusEnum) {
          case CallStatus.accepted:
            await handleCallAccepted(callDetail);
            break;
          case CallStatus.completed:
            await handleCallCompleted(callDetail);
            break;
          case CallStatus.rejected:
          case CallStatus.cancelled:
            handleCallRejected(callDetail);
            break;
          case CallStatus.pending:
            Log.warning('Call is still pending', 'MainController');
            break;
        }
      }
    } catch (e, stackTrace) {
      Log.error(
        'Error getting call details: $e\n$stackTrace',
        'MainController',
      );
    }
  }

  // Handle call ended
  void handleCallEnded() {
    // You can show a message or navigate back to home
    // For now, just log it
    Log.success('Call has ended', 'MainController');
  }

  // Handle call accepted - show payment screen
  Future<void> handleCallAccepted(CallDetailInfoModel callDetail) async {
    Log.success('Call accepted: ${callDetail.id}', 'MainController');

    _isNavigating = true;
    isLoading.value = true; // Show loading state

    try {
      // Create payment invoice using payment_id
      final response = await PaymentApi().paymentCreateInvoice(
        id: callDetail.paymentId,
      );

      if (response.isSuccess) {
        Log.success('Payment invoice created successfully', 'MainController');

        final data = response.data;
        final fee = data['amount'].ddoubleValue;
        final paymentId = data['payment_id'].integerValue;
        final invoice = data['invoice_id'].stringValue;
        final urls =
            data['urls'].listValue.map((e) => QpayModel.fromJson(e)).toList();

        // Create QPay screen model
        final info = [
          QpayInfoModel(title: 'Төлөх мөнгөн дүн', value: fee.toCurrency()),
        ];

        final qpay = QpayScreenModel(
          title: 'Төлбөрийн мэдээлэл',
          invoice: invoice,
          info: info,
          urls: urls,
          paymentID: paymentId,
        );

        // Show QPay screen
        final result = await HomeRoute.toQpay(model: qpay);

        if (result == true) {
          // Payment successful, navigate to appropriate call map based on user type
          Log.success(
            'Payment completed, navigating to call map',
            'MainController',
          );

          final userType = HelperManager.profileInfo.userType;
          if (userType == 'customer') {
            await HomeRoute.toCustomerCallGoogleMap(
              callDetailInfoModel: callDetail,
            );
          } else {
            await HomeRoute.toNurseCallGoogleMap(
              callDetailInfoModel: callDetail,
            );
          }
        } else if (result == false) {
          // if (response.message == "Төлбөр аль хэдийн төлөгдсөн байна") {
          //   await HomeRoute.toCustomerCallGoogleMap(
          //       callDetailInfoModel: callDetail);
          // }
          // Payment cancelled, handle cancellation
          Log.success('Payment cancelled by user', 'MainController');
          await _cancelCall(callDetail.id);
        }
      } else {
        Log.error(
          'Failed to create payment invoice: ${response.message}',
          'MainController',
        );
        final userType = HelperManager.profileInfo.userType;

        if (userType == 'customer') {
          await HomeRoute.toCustomerCallGoogleMap(
            callDetailInfoModel: callDetail,
          );
        } else {
          await HomeRoute.toNurseCallGoogleMap(
            callDetailInfoModel: callDetail,
          );
        }
        // showError(
        //   text: 'Төлбөрийн мэдээлэл үүсгэхэд алдаа гарлаа: ${response.message}',
        // );
      }
    } catch (e) {
      Log.error('Error handling accepted call: $e', 'MainController');
      showError(text: 'Дуудлагыг боловсруулах явцад алдаа гарлаа');
    } finally {
      _isNavigating = false;
      isLoading.value = false; // Hide loading state
    }
  }

  // Handle call completed - check status and navigate to rating if needed
  Future<void> handleCallCompleted(CallDetailInfoModel callDetail) async {
    Log.success('Call completed: ${callDetail.id}', 'MainController');

    try {
      // Get detailed call info to check status_display
      final detailResponse = await NurseApi().bookingsCallsDetailInfo(
        id: callDetail.id,
      );

      if (detailResponse.isSuccess) {
        final statusDisplay = detailResponse.data['status_display'].stringValue;

        Log.success('Status display: $statusDisplay', 'MainController');

        // If status_display is "Дууссан", navigate to rating screen
        if (statusDisplay == 'Дууссан') {
          final userType = HelperManager.profileInfo.userType;

          // Only customers should rate the service
          // if (userType == 'customer' || userType == 'user') {
          Log.success('Navigating to rating screen for call: ${callDetail.id}',
              'MainController');
          HomeRoute.toRating(callId: callDetail.id);
          // }
        }
      } else {
        Log.error('Failed to get call detail info: ${detailResponse.message}',
            'MainController');
      }
    } catch (e) {
      Log.error('Error handling completed call: $e', 'MainController');
    }
  }

  void handleCallRejected(CallDetailInfoModel callDetail) {
    Log.success('Call rejected/cancelled: ${callDetail.id}', 'MainController');
    // You can show rejection message
  }

  Future<void> _cancelCall(int callId) async {
    try {
      Log.success('Cancelling call: $callId', 'MainController');

      final response = await CallApi().updateCallStatus(
        callId: callId,
        status: CallStatus.cancelled.value,
      );

      if (response.isSuccess) {
        Log.success('Call cancelled successfully', 'MainController');
        showSuccess(
          text: 'Дуудлага амжилттай цуцлагдлаа',
          titleText: 'Цуцлагдлаа',
        );

        // Reset current call tracking
        _currentCallId = null;
        _currentCallStatus = null;
      } else {
        Log.error(
          'Failed to cancel call: ${response.message}',
          'MainController',
        );
        showError(
          text: 'Дуудлагыг цуцлах явцад алдаа гарлаа: ${response.message}',
        );
      }
    } catch (e) {
      Log.error('Error cancelling call: $e', 'MainController');
      showError(text: 'Дуудлагыг цуцлах явцад алдаа гарлаа');
    }
  }
}
