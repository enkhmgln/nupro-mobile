import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:nuPro/library/client/io_client.dart';
import 'package:nuPro/library/client/io_response.dart';
import 'package:http_parser/http_parser.dart';

class CallApi extends IOClient {
  bool _looksLikeBase64(String s) {
    final base64Str = s.contains(',') ? s.split(',').last : s;
    try {
      base64Decode(base64Str);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<IOResponse> createHealthInfo({
    required bool isHealthy,
    required bool hasRegularMedication,
    String? regularMedicationDetails,
    required bool hasAllergies,
    String? allergyDetails,
    required bool hasDiabetes,
    required bool hasHypertension,
    required bool hasEpilepsy,
    required bool hasHeartDisease,
    required int preferredServiceType,
    required String signature,
    String? additionalNotes,
    String? medicalCertificate,
    double? latitude,
    double? longitude,
  }) async {
    const path = '/api/health-info/create';

    double? roundTo6Decimals(double? value) {
      if (value == null) return null;
      return double.parse(value.toStringAsFixed(6));
    }

    final formDataMap = {
      "is_healthy": isHealthy,
      "has_regular_medication": hasRegularMedication,
      "regular_medication_details": regularMedicationDetails,
      "has_allergies": hasAllergies,
      "allergy_details": allergyDetails,
      "has_diabetes": hasDiabetes,
      "has_hypertension": hasHypertension,
      "has_epilepsy": hasEpilepsy,
      "has_heart_disease": hasHeartDisease,
      "latitude": roundTo6Decimals(latitude),
      "longitude": roundTo6Decimals(longitude),
      "preferred_service_type": preferredServiceType,
      "additional_notes": additionalNotes,
    };

    if (signature.isNotEmpty && _looksLikeBase64(signature)) {
      final base64Str =
          signature.contains(",") ? signature.split(",").last : signature;

      final bytes = base64Decode(base64Str);

      formDataMap["signature"] = MultipartFile.fromBytes(
        bytes,
        filename: "signature.png",
        contentType: MediaType("image", "png"),
      );
    }

    if (medicalCertificate != null &&
        medicalCertificate.isNotEmpty &&
        _looksLikeBase64(medicalCertificate)) {
      final base64Str = medicalCertificate.contains(",")
          ? medicalCertificate.split(",").last
          : medicalCertificate;

      final bytes = base64Decode(base64Str);

      formDataMap["medical_certificate"] = MultipartFile.fromBytes(
        bytes,
        filename: "medical_certificate.jpg",
        contentType: MediaType("image", "jpeg"),
      );
    }

    final formData = FormData.fromMap(formDataMap);
    return sendMultiPartRequest(path, formData: formData);
  }

  Future<IOResponse> updateHealthInfo({
    required bool isHealthy,
    required bool hasRegularMedication,
    String? regularMedicationDetails,
    required bool hasAllergies,
    String? allergyDetails,
    required bool hasDiabetes,
    required bool hasHypertension,
    required bool hasEpilepsy,
    required bool hasHeartDisease,
    required int preferredServiceType,
    required String signature,
    String? additionalNotes,
    String? medicalCertificate,
    double? latitude,
    double? longitude,
  }) async {
    const path = '/api/health-info/update';

    double? roundTo6Decimals(double? value) {
      if (value == null) return null;
      return double.parse(value.toStringAsFixed(6));
    }

    final formDataMap = {
      "is_healthy": isHealthy,
      "has_regular_medication": hasRegularMedication,
      "regular_medication_details": regularMedicationDetails,
      "has_allergies": hasAllergies,
      "allergy_details": allergyDetails,
      "has_diabetes": hasDiabetes,
      "has_hypertension": hasHypertension,
      "has_epilepsy": hasEpilepsy,
      "has_heart_disease": hasHeartDisease,
      "latitude": roundTo6Decimals(latitude),
      "longitude": roundTo6Decimals(longitude),
      "preferred_service_type": preferredServiceType,
      "additional_notes": additionalNotes,
    };

    if (signature.isNotEmpty && _looksLikeBase64(signature)) {
      final base64Str =
          signature.contains(",") ? signature.split(",").last : signature;

      final bytes = base64Decode(base64Str);

      formDataMap["signature"] = MultipartFile.fromBytes(
        bytes,
        filename: "signature.png",
        contentType: MediaType("image", "png"),
      );
    }

    if (medicalCertificate != null &&
        medicalCertificate.isNotEmpty &&
        _looksLikeBase64(medicalCertificate)) {
      final base64Str = medicalCertificate.contains(",")
          ? medicalCertificate.split(",").last
          : medicalCertificate;

      final bytes = base64Decode(base64Str);

      formDataMap["medical_certificate"] = MultipartFile.fromBytes(
        bytes,
        filename: "medical_certificate.jpg",
        contentType: MediaType("image", "jpeg"),
      );
    }

    final formData = FormData.fromMap(formDataMap);

    return sendMultiPartPutRequest(path, formData: formData);
  }

  Future<IOResponse> getServiceTypes() async {
    const url = '/api/health-info/service-types';
    return sendGetRequest(url, hasToken: false);
  }

  Future<IOResponse> getActiveCall() async {
    const url = '/api/bookings/active-call';
    return sendGetRequest(url, hasToken: true);
  }

  Future<IOResponse> getCallDetails({
    required int callId,
  }) async {
    final url = '/api/bookings/calls/$callId';
    return sendGetRequest(url);
  }

  Future<IOResponse> updateCallStatus({
    required int callId,
    required String status,
  }) async {
    final url = '/api/bookings/calls/$callId/update';
    final data = {
      'status': status,
    };
    return sendPatchRequest(url, data: data);
  }

  Future<IOResponse> getCompletionCode({
    required int callId,
  }) async {
    final url = '/api/bookings/calls/$callId/completion-code';
    return sendGetRequest(url);
  }

  Future<IOResponse> completeCall({
    required int callId,
    required String completionCode,
  }) async {
    final url = '/api/bookings/calls/$callId/complete';
    final data = {
      'completion_code': completionCode,
    };
    return sendPostRequest(url, data: data);
  }
}
