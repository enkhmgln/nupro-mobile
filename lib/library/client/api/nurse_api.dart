import 'package:nuPro/library/client/io_client.dart';
import 'package:nuPro/library/client/io_response.dart';

class NurseApi extends IOClient {
  Future<IOResponse> getSpecializations() async {
    const url = '/api/nurses/specializations';
    return sendGetRequest(url);
  }

  Future<IOResponse> searchNursesBySpecialization(
      {required int specializationId}) async {
    final url = '/api/nurses/search?specialization_id=$specializationId';
    return sendGetRequest(url, hasToken: true);
  }

  Future<IOResponse> sendNurseLocation({
    required double latitude,
    required double longitude,
  }) async {
    const url = '/api/nurses/location';
    final data = {
      'latitude': latitude,
      'longitude': longitude,
    };
    return sendPostRequest(
      url,
      data: data,
      hasToken: true,
    );
  }

  Future<IOResponse> getNurseHealthInfo() async {
    const url = '/api/health-info/get';
    return sendGetRequest(url);
  }

  Future<IOResponse> createCallNurse({
    required String nurse,
    required double? customerLatitude,
    required double? customerLongitude,
  }) async {
    const url = '/api/bookings/create-call';

    double? roundTo6Decimals(double? value) {
      if (value == null) return null;
      return double.parse(value.toStringAsFixed(6));
    }

    final data = {
      'nurse': nurse,
      'customer_latitude': roundTo6Decimals(customerLatitude),
      'customer_longitude': roundTo6Decimals(customerLongitude),
    };
    return sendPostRequest(
      url,
      data: data,
    );
  }

  Future<IOResponse> bookingsCallsDetailInfo({
    required int id,
  }) async {
    final url = '/api/bookings/calls/$id';
    return sendGetRequest(url);
  }

  Future<IOResponse> bookingsCallsUpdate({
    required String status,
    required int id,
    String? nurseNotes,
  }) async {
    final url = '/api/bookings/calls/$id/update';

    final data = {
      'status': status,
      'nurse_notes': nurseNotes,
    };
    return sendPatchRequest(
      url,
      data: data,
    );
  }
}
