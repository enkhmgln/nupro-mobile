import 'package:g_json/g_json.dart';

class TreatmentModel {
  final int id;
  final String nurseName;
  final String nursePhone;
  final String nurseHospital;
  final String nurseExperience;
  final String? nurseProfilePicture;
  final String status;
  final String statusDisplay;
  final String serviceType;
  final double? amount;
  final String? currency;
  final String? paymentStatus;
  final String createdAt;
  final String? acceptedAt;
  final String? completedAt;
  final String? nurseNotes;

  TreatmentModel.fromJson(JSON json)
      : id = json['id'].integerValue,
        nurseName = json['nurse_name'].stringValue,
        nursePhone = json['nurse_phone'].stringValue,
        nurseHospital = json['nurse_hospital'].stringValue,
        nurseExperience = json['nurse_experience'].stringValue,
        nurseProfilePicture = json['nurse_profile_picture'].stringValue,
        status = json['status'].stringValue,
        statusDisplay = json['status_display'].stringValue,
        serviceType = json['service_type'].stringValue,
        amount = json['amount'].ddoubleValue,
        currency = json['currency'].stringValue,
        paymentStatus = json['payment_status'].stringValue,
        createdAt = json['created_at'].stringValue,
        acceptedAt = json['accepted_at'].stringValue,
        completedAt = json['completed_at'].stringValue,
        nurseNotes = json['nurse_notes'].stringValue;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nurse_name': nurseName,
      'nurse_phone': nursePhone,
      'nurse_hospital': nurseHospital,
      'nurse_experience': nurseExperience,
      'nurse_profile_picture': nurseProfilePicture,
      'status': status,
      'status_display': statusDisplay,
      'service_type': serviceType,
      'amount': amount,
      'currency': currency,
      'payment_status': paymentStatus,
      'created_at': createdAt,
      'accepted_at': acceptedAt,
      'completed_at': completedAt,
      'nurse_notes': nurseNotes,
    };
  }
}
