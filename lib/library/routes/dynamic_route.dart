import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:g_json/g_json.dart';

import 'package:nuPro/library/components/widgets/incoming_call_modal.dart';
import 'package:nuPro/library/client/api/nurse_api.dart';
import 'package:nuPro/library/client/api/customer_api.dart';
import 'package:nuPro/library/client/api/payment_api.dart';
import 'package:nuPro/library/client/models/call_detail_info.dart';
import 'package:nuPro/library/routes/home_route.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/components/main/io_toast.dart';
import 'package:nuPro/library/utils/extension.dart';
import 'package:nuPro/library/shared/helper_manager.dart';
import 'package:nuPro/library/shared/store_manager.dart';
import 'package:nuPro/screens/pay/qpay/models/qpay_model.dart';
import 'package:nuPro/screens/pay/qpay/models/qpay_screen_model.dart';
import 'package:nuPro/main_controller.dart';

class DynamicRoute {
  // Prevent duplicate incoming call modals stacking
  static bool _incomingVisible = false;
  static String? _incomingCallId;

  /// Entry point when a local notification is tapped.
  @pragma('vm:entry-point')
  static void onNotification(NotificationResponse detail) {
    try {
      if (detail.payload == null || detail.payload!.isEmpty) {
        debugPrint("❌ Notification payload хоосон байна");
        return;
      }

      final data = JSON.parse(detail.payload!);
      final pageType = data['page_type'].stringValue;

      debugPrint("📩 Notification tapped: $data");

      switch (pageType) {
        case 'incoming_call':
          final loc = data['caller_location'];
          final health = data['caller_health_info'];
          final tsString = data['timestamp'].string;
          sendCallToNurse(
            callId: data['page_id'].stringValue,
            callerName: data['caller_name'].string ?? 'Хэрэглэгч',
            callerPhone: data['caller_phone'].string ?? '',
            latitude: double.tryParse(loc['latitude'].stringValue),
            longitude: double.tryParse(loc['longitude'].stringValue),
            callStatus: data['call_status'].string,
            callType: data['call_type'].string,
            timestamp: tsString != null && tsString.isNotEmpty
                ? DateTime.tryParse(tsString)
                : null,
            healthInfo: (health.value != null)
                ? CallerHealthInfo.fromJson(
                    Map<String, dynamic>.from(health.value))
                : null,
          );
          break;

        case 'booking':
        case 'booking_action':
          _handleBookingNotification(data);
          break;

        default:
          onRoute(
            pageType: pageType,
            pageId: data['page_id'].value,
            sectionTitle: data['caller_name'].string,
            url: data['url'].string,
            callStatus: data['call_status'].string,
            callType: data['call_type'].string,
            paymentId: int.tryParse(data['payment_id'].stringValue) ?? 0,
            paymentApiUri: data['payment_api_url'].string,
            amount: int.tryParse(data['amount'].stringValue) ?? 0,
            currency: data['currency'].string,
            callPhone: data['caller_phone'].stringValue,
          );
      }
    } catch (e) {
      debugPrint("❌ onNotification error: $e");
    }
  }

  /// Processes routing based on page type.
  static void onRoute({
    required String pageType,
    dynamic pageId,
    String? sectionTitle,
    String? url,
    String? callStatus,
    String? callType,
    int? paymentId,
    String? paymentApiUri,
    int? amount,
    String? currency,
    String? callPhone,
  }) {
    switch (pageType) {
      case 'incoming_call':
        if (pageId != null) {
          final id = int.tryParse(pageId.toString()) ?? 0;
          sendCallToNurse(
            callId: id,
            callerName: sectionTitle ?? 'Хэрэглэгч',
            callerPhone: callPhone ?? "",
          );
        }
        break;

      case 'call_status_change':
        if (pageId != null) {
          final id = int.tryParse(pageId.toString()) ?? 0;
          _handleCallStatusChange(
            pageId: id,
            callStatus: callStatus ?? 'unknown',
            callType: callType ?? '',
            paymentId: paymentId ?? 0,
            paymentApiUri: paymentApiUri ?? '',
            amount: amount ?? 0,
            currency: currency ?? '',
          );
        }
        break;

      default:
        debugPrint('⚠️ Unknown pageType: $pageType');
    }
  }

  /// Handles incoming call logic (display modal or store pending call).
  static Future<void> sendCallToNurse({
    required dynamic callId,
    required String callerName,
    required String callerPhone,
    double? latitude,
    double? longitude,
    CallerHealthInfo? healthInfo,
    String? callStatus,
    String? callType,
    DateTime? timestamp,
  }) async {
    try {
      debugPrint("📞 sendCallToNurse → callId: $callId");

      // Debounce/guard: if the same call is already being displayed, skip
      final idStr = callId.toString();
      if (_incomingVisible && _incomingCallId == idStr) {
        debugPrint('⚠️ Incoming modal already visible for callId=$idStr');
        return;
      }

      // Wait until app is fully ready (controller + context + logged in)
      const maxAttempts = 20;
      bool isAppReady = false;

      for (int i = 0; i < maxAttempts; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        isAppReady = Get.isRegistered<MainController>() &&
            Get.context != null &&
            HelperManager.isLogged;

        if (isAppReady) break;
      }

      if (!isAppReady) {
        await _storePendingCall(
          callId,
          callerName,
          callerPhone,
          latitude: latitude,
          longitude: longitude,
          healthInfo: healthInfo == null
              ? null
              : {
                  'is_healthy': healthInfo.isHealthy,
                  'has_regular_medication': healthInfo.hasRegularMedication,
                  'regular_medication_details':
                      healthInfo.regularMedicationDetails,
                  'has_allergies': healthInfo.hasAllergies,
                  'allergy_details': healthInfo.allergyDetails,
                  'has_diabetes': healthInfo.hasDiabetes,
                  'has_hypertension': healthInfo.hasHypertension,
                  'has_epilepsy': healthInfo.hasEpilepsy,
                  'has_heart_disease': healthInfo.hasHeartDisease,
                  'medical_conditions_summary':
                      healthInfo.medicalConditionsSummary,
                  'additional_notes': healthInfo.additionalNotes,
                },
          callStatus: callStatus,
          callType: callType,
          timestamp: timestamp?.toIso8601String(),
        );
        return;
      }

      // Show Incoming Call Modal
      _incomingVisible = true;
      _incomingCallId = idStr;
      await Get.bottomSheet(
        IncomingCallModal(
          callId: callId.toString(),
          callerName: callerName,
          callerPhone: callerPhone,
          profilePicture: null,
          location: null,
          latitude: latitude,
          longitude: longitude,
          healthInfo: healthInfo,
          callStatus: callStatus,
          callType: callType,
          timestamp: timestamp,
          onAccept: () => _acceptCall(callId),
          onDecline: (String reason) => _declineCall(callId, reason),
        ),
        isScrollControlled: true,
        ignoreSafeArea: true,
      );
    } catch (e) {
      debugPrint('❌ sendCallToNurse error: $e');
      await _storePendingCall(callId, callerName, callerPhone,
          latitude: latitude,
          longitude: longitude,
          healthInfo: null,
          callStatus: callStatus,
          callType: callType,
          timestamp: timestamp?.toIso8601String());
    } finally {
      _incomingVisible = false;
      _incomingCallId = null;
    }
  }

  /// Handles when a nurse accepts the call.
  static Future<void> _acceptCall(dynamic callId) async {
    // Show loading/processing dialog
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
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Дуудлага хүлээн авлаа',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Та удахгүй газрын зураг руу шилжих болно.\nТүр хүлээнэ үү...',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      final update = await NurseApi().bookingsCallsUpdate(
        status: 'accepted',
        id: int.tryParse(callId.toString()) ?? 0,
      );

      if (!update.isSuccess) {
        Get.back(); // Close processing dialog
        IOToast(
          text:
              "Анхааруулга: ${update.message.isNotEmpty ? update.message : "Дуудлагын статус шинэчлэгдсэнгүй"}",
          backgroundColor: IOColors.backgroundIconColor,
          gravity: ToastGravity.TOP,
        ).show();
        return;
      }

      final detail = await NurseApi().bookingsCallsDetailInfo(
        id: int.tryParse(callId.toString()) ?? 0,
      );

      Get.back(); // Close processing dialog

      if (detail.isSuccess) {
        final info = CallDetailInfoModel.fromJson(detail.data);

        // Show success message briefly before navigation
        IOToast(
          text: "Та газрын зураг руу шилжиж байна...",
          backgroundColor: Colors.green,
          gravity: ToastGravity.TOP,
        ).show();

        await Future.delayed(const Duration(milliseconds: 500));
        await HomeRoute.toNurseCallGoogleMap(callDetailInfoModel: info);
      } else {
        IOToast(
          text: "Дуудлагын мэдээлэл татахад алдаа гарлаа",
          backgroundColor: IOColors.backgroundIconColor,
          gravity: ToastGravity.TOP,
        ).show();
      }
    } catch (e) {
      Get.back(); // Close processing dialog if still open
      IOToast(
        text: "Алдаа гарлаа: $e",
        backgroundColor: IOColors.backgroundIconColor,
        gravity: ToastGravity.TOP,
      ).show();
    }
  }

  /// Handles when a nurse declines the call.
  static Future<void> _declineCall(dynamic callId, String reason) async {
    final response = await NurseApi().bookingsCallsUpdate(
      status: 'rejected',
      id: int.tryParse(callId.toString()) ?? 0,
      nurseNotes: reason,
    );
    IOToast(
      text: response.isSuccess
          ? "Дуудлага татгалзсан"
          : "Дуудлагын статус шинэчлэгдсэнгүй",
      backgroundColor: IOColors.backgroundIconColor,
      gravity: ToastGravity.TOP,
    ).show();
  }

  /// Stores pending call info when app is not ready.
  static Future<void> _storePendingCall(dynamic id, String name, String phone,
      {double? latitude,
      double? longitude,
      Map<String, dynamic>? healthInfo,
      String? callStatus,
      String? callType,
      String? timestamp}) async {
    // Avoid overwriting if same pending exists
    final existing = DeviceStoreManager.shared.mapData('pending_incoming_call');
    if (existing != null && existing['call_id']?.toString() == id.toString()) {
      return;
    }
    await DeviceStoreManager.shared.write('pending_incoming_call', {
      'call_id': id.toString(),
      'caller_name': name,
      'caller_phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'health_info': healthInfo,
      'call_status': callStatus,
      'call_type': callType,
      'timestamp': timestamp ?? DateTime.now().toIso8601String(),
    });
    debugPrint("💾 Stored pending incoming call for callId: $id");
  }

  /// Handles call status updates such as completed, accepted, etc.
  static Future<void> _handleCallStatusChange({
    required dynamic pageId,
    required String callStatus,
    required String callType,
    required dynamic paymentId,
    required String paymentApiUri,
    required int amount,
    required String currency,
  }) async {
    debugPrint('📱 Call status change → $callStatus (ID: $pageId)');

    if (callStatus == 'completed') {
      await _showCallCompletionNotification(pageId);
      return;
    }

    if (paymentId != null && paymentId > 0) {
      await _handlePayment(pageId, paymentId);
    }
  }

  /// Handles payment screen navigation and logic.
  static Future<void> _handlePayment(dynamic pageId, int paymentId) async {
    final mainController = Get.find<MainController>();
    mainController.isLoading.value = true;

    try {
      final response = await PaymentApi().paymentCreateInvoice(id: paymentId);

      if (!response.isSuccess) {
        mainController.showError(
            text:
                'Төлбөрийн мэдээлэл үүсгэхэд алдаа гарлаа: ${response.message}');
        return;
      }

      final data = response.data;
      final fee = data['amount'].ddoubleValue;
      final invoice = data['invoice_id'].stringValue;
      final urls =
          data['urls'].listValue.map((e) => QpayModel.fromJson(e)).toList();

      final qpay = QpayScreenModel(
        title: 'Төлбөрийн мэдээлэл',
        invoice: invoice,
        info: [QpayInfoModel(title: 'Төлөх дүн', value: fee.toCurrency())],
        urls: urls,
        paymentID: data['payment_id'].integerValue,
      );

      final result = await HomeRoute.toQpay(model: qpay);

      if (HelperManager.profileInfo.userType == 'customer' && result == true) {
        // Get latest accepted/paid call for customer
        final treatmentResponse = await CustomerApi().getTreatment(limit: 1);
        if (treatmentResponse.isSuccess &&
            treatmentResponse.data.listValue.isNotEmpty) {
          final latestCall = treatmentResponse.data.listValue.first;
          final callId = latestCall['id'].integerValue;
          final detail = await NurseApi().bookingsCallsDetailInfo(id: callId);
          if (detail.isSuccess) {
            final info = CallDetailInfoModel.fromJson(detail.data);
            await HomeRoute.toCustomerCallGoogleMap(callDetailInfoModel: info);
          } else {
            IOToast(
              text: "Дуудлагын дэлгэрэнгүй мэдээлэл шинэчлэгдсэнгүй",
              backgroundColor: IOColors.backgroundIconColor,
              gravity: ToastGravity.TOP,
            ).show();
          }
        } else {
          IOToast(
            text: "Таны дуудлага олдсонгүй",
            backgroundColor: IOColors.backgroundIconColor,
            gravity: ToastGravity.TOP,
          ).show();
        }
      }
    } catch (e) {
      mainController.showError(
          text: 'Төлбөрийн мэдээлэл үүсгэхэд алдаа гарлаа ($e)');
    } finally {
      mainController.isLoading.value = false;
    }
  }

  /// Shows call completion dialog with nurse info and rating option.
  static Future<void> _showCallCompletionNotification(dynamic pageId) async {
    try {
      final response = await NurseApi()
          .bookingsCallsDetailInfo(id: int.tryParse(pageId.toString()) ?? 0);

      if (!response.isSuccess) {
        IOToast(
          text: "Дуудлага дууссан: Таны дуудлага амжилттай дууссан байна",
          backgroundColor: IOColors.successPrimary,
          gravity: ToastGravity.TOP,
        ).show();
        return;
      }

      final call = response.data;
      final nurseName = call['nurse_name'].stringValue;
      final completionCode = call['completion_code'].stringValue;

      final result = await _showCallCompletionDialog(
        callId: pageId.toString(),
        nurseName: nurseName,
        completionCode: completionCode,
      );

      if (result == true) {
        HomeRoute.toRating(callId: int.tryParse(pageId.toString()) ?? 0);
      } else {
        Get.until((route) => route.isFirst);
      }
    } catch (e) {
      debugPrint('❌ Error showing call completion notification: $e');
    }
  }

  /// Confirmation dialog after call completion.
  static Future<bool?> _showCallCompletionDialog({
    required String callId,
    required String nurseName,
    required String completionCode,
  }) async {
    return Get.dialog<bool>(
      AlertDialog(
        title: const Text('Дуудлага дууссан'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Сувилагч: $nurseName'),
            if (completionCode.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Баталгаажуулах код: $completionCode'),
            ],
            const SizedBox(height: 16),
            const Text(
              'Үйлчилгээг үнэлэх үү?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Үгүй'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Үнэлэх'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Handles “service completed” notification logic
  static void _handleBookingNotification(JSON data) {
    final actionId = data['action_id'].value ?? data['page_id'].value;
    final title = data['title'].string ?? data['section_title'].string ?? '';
    if (title == 'Үйлчилгээ дууслаа') {
      HomeRoute.toRating(callId: int.tryParse(actionId.toString()) ?? 0);
    }
  }
}
