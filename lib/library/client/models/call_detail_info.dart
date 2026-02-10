import 'package:g_json/g_json.dart';

class CallDetailInfoModel {
  bool canRate;
  int id;
  String nurseName;
  String status;
  String statusDisplay;
  String customerLatitude;
  String customerLongitude;
  String createdAt;
  String acceptedAt;
  String completedAt;
  String nurseNotes;
  String customerFirstName;
  String customerLastName;
  String customerSex;
  String customerDateOfBirth;
  String customerProfilePicture;
  String customerLocation;
  bool customerHealthStatus;
  bool customerHasMedication;
  String customerMedicationDetails;
  bool customerHasAllergies;
  String customerAllergyDetails;
  bool customerHasDiabetes;
  bool customerHasHypertension;
  bool customerHasEpilepsy;
  bool customerHasHeartDisease;
  String customerMedicalConditionsSummary;
  String customerPreferredServiceType;
  String customerPreferredTime;
  String customerAdditionalHealthNotes;
  String customerSubDistrict;
  String customerDistrict;
  String customerCity;
  String customerPreferredServiceTypeName;
  String nurseLatitude;
  String nurseLongitude;
  String nurseLocationUpdatedAt;
  int paymentId;
  String paymentStatus;
  String paymentAmount;
  String paymentCurrency;

  CallDetailInfoModel.fromJson(JSON json)
      : id = json['id'].integerValue,
        nurseName = json['nurse_name'].stringValue,
        status = json['status'].stringValue,
        statusDisplay = json['status_display'].stringValue,
        customerLatitude = json['customer_latitude'].stringValue,
        customerLongitude = json['customer_longitude'].stringValue,
        createdAt = json['created_at'].stringValue,
        acceptedAt = json['accepted_at'].stringValue,
        completedAt = json['completed_at'].stringValue,
        nurseNotes = json['nurse_notes'].stringValue,
        customerFirstName = json['customer_first_name'].stringValue,
        customerLastName = json['customer_last_name'].stringValue,
        customerSex = json['customer_sex'].stringValue,
        customerDateOfBirth = json['customer_date_of_birth'].stringValue,
        customerProfilePicture = json['customer_profile_picture'].stringValue,
        customerLocation = json['customer_location'].stringValue,
        customerHealthStatus = json['customer_health_status'].booleanValue,
        customerHasMedication = json['customer_has_medication'].booleanValue,
        customerMedicationDetails =
            json['customer_medication_details'].stringValue,
        customerHasAllergies = json['customer_has_allergies'].booleanValue,
        customerAllergyDetails = json['customer_allergy_details'].stringValue,
        customerHasDiabetes = json['customer_has_diabetes'].booleanValue,
        customerHasHypertension =
            json['customer_has_hypertension'].booleanValue,
        customerHasEpilepsy = json['customer_has_epilepsy'].booleanValue,
        customerHasHeartDisease =
            json['customer_has_heart_disease'].booleanValue,
        customerMedicalConditionsSummary =
            json['customer_medical_conditions_summary'].stringValue,
        customerPreferredServiceType =
            json['customer_preferred_service_type'].stringValue,
        customerPreferredTime = json['customer_preferred_time'].stringValue,
        customerAdditionalHealthNotes =
            json['customer_additional_health_notes'].stringValue,
        customerSubDistrict = json['customer_sub_district'].stringValue,
        customerDistrict = json['customer_district'].stringValue,
        customerCity = json['customer_city'].stringValue,
        customerPreferredServiceTypeName =
            json['customer_preferred_service_type_name'].stringValue,
        nurseLatitude = json['nurse_latitude'].stringValue,
        nurseLongitude = json['nurse_longitude'].stringValue,
        nurseLocationUpdatedAt = json['nurse_location_updated_at'].stringValue,
        paymentId = json['payment_id'].integerValue,
        paymentStatus = json['payment_status'].stringValue,
        paymentAmount = json['payment_amount'].stringValue,
        paymentCurrency = json['payment_currency'].stringValue,
        canRate = json['can_rate'].booleanValue;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nurse_name': nurseName,
      'status': status,
      'status_display': statusDisplay,
      'customer_latitude': customerLatitude,
      'customer_longitude': customerLongitude,
      'created_at': createdAt,
      'accepted_at': acceptedAt,
      'completed_at': completedAt,
      'nurse_notes': nurseNotes,
      'customer_first_name': customerFirstName,
      'customer_last_name': customerLastName,
      'customer_sex': customerSex,
      'customer_date_of_birth': customerDateOfBirth,
      'customer_profile_picture': customerProfilePicture,
      'customer_location': customerLocation,
      'customer_health_status': customerHealthStatus,
      'customer_has_medication': customerHasMedication,
      'customer_medication_details': customerMedicationDetails,
      'customer_has_allergies': customerHasAllergies,
      'customer_allergy_details': customerAllergyDetails,
      'customer_has_diabetes': customerHasDiabetes,
      'customer_has_hypertension': customerHasHypertension,
      'customer_has_epilepsy': customerHasEpilepsy,
      'customer_has_heart_disease': customerHasHeartDisease,
      'customer_medical_conditions_summary': customerMedicalConditionsSummary,
      'customer_preferred_service_type': customerPreferredServiceType,
      'customer_preferred_time': customerPreferredTime,
      'customer_additional_health_notes': customerAdditionalHealthNotes,
      'customer_sub_district': customerSubDistrict,
      'customer_district': customerDistrict,
      'customer_city': customerCity,
      'customer_preferred_service_type_name': customerPreferredServiceTypeName,
      'nurse_latitude': nurseLatitude,
      'nurse_longitude': nurseLongitude,
      'nurse_location_updated_at': nurseLocationUpdatedAt,
      'payment_id': paymentId,
      'payment_status': paymentStatus,
      'payment_amount': paymentAmount,
      'payment_currency': paymentCurrency,
      'can_rate': canRate,
    };
  }
}
