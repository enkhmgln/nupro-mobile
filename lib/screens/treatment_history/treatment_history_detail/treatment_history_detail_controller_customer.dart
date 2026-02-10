import 'package:get/get.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/screens/home/model/treatment_model.dart';
import 'package:nuPro/screens/treatment_history/treatment_history_detail/model/treatment_histoy_detail_model.dart';

class TreatmentHistoryDetailControllerCustomer extends IOController {
  final TreatmentModel item;
  HealthInfo? healthInfo;
  TreatmentHistoyDetailModel? detailInfo;

  TreatmentHistoryDetailControllerCustomer({required this.item});

  final reCallButton = IOButtonModel(
    label: 'Дахин дуудлага өгөх',
    type: IOButtonType.primary,
    size: IOButtonSize.large,
    isLoading: false,
  ).obs;

  int? nurseId;
  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    final response = await CustomerApi().getTreatmentDetail(id: item.id);

    isLoading.value = false;
    if (response.isSuccess) {
      try {
        // Try to parse the full detail model from the plain map if available
        try {
          final map = response.data.mapValue;
          detailInfo = TreatmentHistoyDetailModel.fromJson(map);
          healthInfo = detailInfo?.healthInfo;
          nurseId = detailInfo?.nurse?.id;
        } catch (_) {
          // ignore and fallback to g_json parsing below
        }

        // If parsing via model failed, fallback to parsing via g_json
        if (detailInfo == null) {
          final data = response.data;

          // Parse call info
          Call? call;
          try {
            final c = data['call'];
            call = Call(
              id: c['id'].integerValue,
              status: c['status'].stringValue,
              statusDisplay: c['status_display'].stringValue,
              createdAt: c['created_at'].stringValue,
              acceptedAt: c['accepted_at'].stringValue,
              completedAt: c['completed_at'].stringValue,
              paymentTransferredAt: c['payment_transferred_at'].stringValue,
              customerLatitude: c['customer_latitude'].stringValue,
              customerLongitude: c['customer_longitude'].stringValue,
              nurseNotes: c['nurse_notes'].stringValue,
              completionCode: c['completion_code'].stringValue,
              completionCodeExpiresAt:
                  c['completion_code_expires_at'].stringValue,
            );
          } catch (e) {
            print("Error parsing call: $e");
          }

          // Parse nurse info
          Nurse? nurse;
          try {
            final n = data['nurse'];
            final nid = n['id'].integerValue;
            if (nid != 0) {
              nurseId = nid;

              // Parse hospital
              Hospital? hospital;
              try {
                final h = n['hospital'];
                hospital = Hospital(
                  id: h['id'].integerValue,
                  name: h['name'].stringValue,
                  address: h['address'].stringValue,
                  phoneNumber: h['phone_number'].stringValue,
                );
              } catch (_) {}

              // Parse specializations
              List<Specializations>? specializations;
              try {
                final specList = n['specializations'].listValue;
                specializations = specList
                    .map((s) => Specializations(
                          id: s['id'].integerValue,
                          name: s['name'].stringValue,
                        ))
                    .toList();
              } catch (_) {}

              // Parse average rating
              AverageRating? averageRating;
              try {
                final ar = n['average_rating'];
                averageRating = AverageRating(
                  averageRating: ar['average_rating'].integerValue,
                  totalRatings: ar['total_ratings'].integerValue,
                );
              } catch (_) {}

              nurse = Nurse(
                id: nid,
                firstName: n['first_name'].stringValue,
                lastName: n['last_name'].stringValue,
                phoneNumber: n['phone_number'].stringValue,
                profilePicture: n['profile_picture'].stringValue,
                workedYears: n['worked_years'].integerValue,
                experienceLevel: n['experience_level'].stringValue,
                isVerified: n['is_verified'].booleanValue,
                hospital: hospital,
                specializations: specializations,
                averageRating: averageRating,
              );
            }
          } catch (e) {
            print("Error parsing nurse: $e");
          }

          // Parse payment info
          Payment? payment;
          try {
            final p = data['payment'];
            payment = Payment(
              paidAt: p['paid_at'].stringValue,
              paymentStatus: p['payment_status'].stringValue,
              paymentStatusDisplay: p['payment_status_display'].stringValue,
              amount: p['amount'].stringValue,
            );
          } catch (e) {
            print("Error parsing payment: $e");
          }

          // Parse health info
          try {
            final h = data['health_info'];
            final pref = h['preferred_service_type'];
            final prefId = pref['id'].integerValue;
            final prefObj = prefId != 0
                ? Specializations(id: prefId, name: pref['name'].stringValue)
                : null;

            healthInfo = HealthInfo(
              isHealthy: h['is_healthy'].booleanValue,
              hasRegularMedication: h['has_regular_medication'].booleanValue,
              regularMedicationDetails:
                  h['regular_medication_details'].stringValue,
              hasAllergies: h['has_allergies'].booleanValue,
              allergyDetails: h['allergy_details'].stringValue,
              hasDiabetes: h['has_diabetes'].booleanValue,
              hasHypertension: h['has_hypertension'].booleanValue,
              hasEpilepsy: h['has_epilepsy'].booleanValue,
              hasHeartDisease: h['has_heart_disease'].booleanValue,
              medicalConditionsSummary:
                  h['medical_conditions_summary'].stringValue,
              preferredServiceType: prefObj,
              additionalNotes: h['additional_notes'].stringValue,
              signature: h['signature'].stringValue,
              medicalCertificate: h['medical_certificate'].stringValue,
            );
          } catch (e) {
            print("Error parsing health_info: $e");
          }

          // Parse nurse location
          NurseLocation? nurseLocation;
          try {
            final nurseLocationJson = data['nurse_location'];
            nurseLocation = NurseLocation(
              latitude: nurseLocationJson['latitude'].ddoubleValue,
              longitude: nurseLocationJson['longitude'].ddoubleValue,
              updatedAt: nurseLocationJson['updated_at'].stringValue,
            );
          } catch (e) {
            print("Error parsing nurse_location: $e");
          }

          // Build complete detailInfo
          detailInfo = TreatmentHistoyDetailModel(
            call: call,
            nurse: nurse,
            payment: payment,
            healthInfo: healthInfo,
            nurseLocation: nurseLocation,
            userType: data['user_type'].stringValue,
          );

          print("Parsed detail info successfully");
        }
        update(); // UI-г шинэчлэх
      } catch (e) {
        showError(text: 'Мэдээлэл задлахад алдаа гарав');
      }
    } else {
      showError(text: response.message);
    }
    update(); // UI-г шинэчлэх
  }

  Future<bool> repeatCall() async {
    isLoading.value = true;
    try {
      final healthResponse = await CallApi().updateHealthInfo(
        isHealthy: healthInfo?.isHealthy ?? false,
        hasRegularMedication: healthInfo?.hasRegularMedication ?? false,
        regularMedicationDetails:
            healthInfo?.regularMedicationDetails?.isNotEmpty == true
                ? healthInfo!.regularMedicationDetails
                : null,
        hasAllergies: healthInfo?.hasAllergies ?? false,
        allergyDetails: healthInfo?.allergyDetails?.isNotEmpty == true
            ? healthInfo!.allergyDetails
            : null,
        hasDiabetes: healthInfo?.hasDiabetes ?? false,
        hasHypertension: healthInfo?.hasHypertension ?? false,
        hasEpilepsy: healthInfo?.hasEpilepsy ?? false,
        hasHeartDisease: healthInfo?.hasHeartDisease ?? false,
        preferredServiceType: healthInfo?.preferredServiceType?.id ?? 1,
        signature: healthInfo?.signature?.isNotEmpty == true
            ? healthInfo!.signature!
            : 'signature',
        latitude: null,
        longitude: null,
        additionalNotes: healthInfo?.additionalNotes,
        medicalCertificate: healthInfo?.medicalCertificate,
      );
      if (!healthResponse.isSuccess) {
        showError(text: healthResponse.message);
        isLoading.value = false;
        return false;
      }

      final lat = detailInfo?.nurseLocation?.latitude;
      final lon = detailInfo?.nurseLocation?.longitude;
      final response = await NurseApi().createCallNurse(
        nurse: (nurseId != null) ? nurseId.toString() : '',
        customerLatitude: lat,
        customerLongitude: lon,
      );
      isLoading.value = false;
      if (response.isSuccess) {
        return true;
      } else {
        showError(text: response.message);
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      showError(text: e.toString());
      print(e.toString());
      return false;
    }
  }
}
