import 'package:g_json/g_json.dart';

class NurseTreatmentModel {
  final int id;
  final String customerPhone;
  final int customerAge;
  final String customerLocation;
  final String? customerProfilePicture;
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

  NurseTreatmentModel.fromJson(JSON json)
      : id = json['id'].integerValue,
        customerPhone = json['customer_phone'].stringValue,
        customerAge = json['customer_age'].integerValue,
        customerLocation = json['customer_location'].stringValue,
        customerProfilePicture = json['customer_profile_picture'].stringValue,
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
      'customer_phone': customerPhone,
      'customer_age': customerAge,
      'customer_location': customerLocation,
      'customer_profile_picture': customerProfilePicture,
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
