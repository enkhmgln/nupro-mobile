import 'package:nuPro/library/library.dart';

class CustomerApi extends IOClient {
  Future<IOResponse> getNotificationList({
    required int limit,
    required int page,
  }) {
    final unreadOnly =
        HelperManager.profileInfo.userType == 'nurse' ? 'nurse' : 'customer';

    const path = '/api/notifications/list';
    final query = {
      'limit': limit,
      'page': page,
      'unread_only': unreadOnly,
    };

    return sendGetRequest(path, query: query);
  }

  Future<IOResponse> getNotificationCount() {
    const path = '/api/notifications/unread-count';
    return sendGetRequest(path);
  }

  Future<IOResponse> getNotificationsMarkViewed({required int id}) {
    const path = '/api/notifications/mark-viewed';
    final data = {'notification_id': id};
    return sendPostRequest(path, data: data);
  }

  Future<IOResponse> getBanner({
    required int limit,
    required int page,
  }) {
    const path = '/api/common/banners';
    final query = {
      'limit': limit,
      'page': page,
    };
    return sendGetRequest(path, query: query, hasToken: false);
  }

  Future<IOResponse> getTreatment({
    int limit = 5,
    String? startDate,
    String? endDate,
    String? status,
  }) {
    const path = '/api/bookings/history';
    final query = <String, dynamic>{
      'limit': limit,
    };

    if (startDate != null) {
      query['start_date'] = startDate;
    }
    if (endDate != null) {
      query['end_date'] = endDate;
    }
    if (status != null) {
      query['status'] = status;
    }

    return sendGetRequest(path, query: query);
  }

  Future<IOResponse> getTreatmentDetail({required int id}) {
    final path = '/api/bookings/history/$id';
    return sendGetRequest(path);
  }

  Future<IOResponse> profileChange({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String sex,
    required String dateOfBirth,
    required int subDistrict,
  }) {
    const path = '/api/users/profile';

    final data = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone_number": phoneNumber,
      "sex": sex,
      "date_of_birth": dateOfBirth,
      "sub_district": subDistrict,
    };
    return sendPatchRequest(path, data: data);
  }

  Future<IOResponse> getCities() {
    const path = '/api/locations/cities?page=1&limit=20';
    return sendGetRequest(path);
  }

  Future<IOResponse> getDistricts({required int cityId}) {
    final path = '/api/locations/cities/$cityId/districts';
    return sendGetRequest(path);
  }

  Future<IOResponse> getSubDistricts({required int districtId}) {
    final path = '/api/locations/districts/$districtId/sub-districts';
    return sendGetRequest(path);
  }

  Future<IOResponse> nurseActiveCallToggle() {
    const path = '/api/nurses/active-call/toggle';
    return sendPostRequest(path);
  }
}
