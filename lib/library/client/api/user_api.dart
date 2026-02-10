import 'package:nuPro/library/client/io_client.dart';
import 'package:nuPro/library/client/io_response.dart';
import 'package:nuPro/library/shared/helper_manager.dart';
import 'package:nuPro/screens/sign_up/sign_up_phone/model/sign_up_model.dart';
import 'package:dio/dio.dart';

class UserApi extends IOClient {
  Future<IOResponse> signIn({
    required String phone,
    required String pass,
  }) async {
    const url = '/api/users/login';
    final data = {
      'phone_number': phone,
      'password': pass,
      'fcm_token': HelperManager.fcmToken,
    };
    return sendPostRequest(url, data: data, hasToken: false);
  }

  Future<IOResponse> sendOtp({
    String? phone,
    String? email,
    required String type,
  }) async {
    const url = '/api/users/otp/send';

    final Map<String, dynamic> data = {
      'otp_type': type,
    };
    if (phone != null && phone.isNotEmpty) {
      data['phone_number'] = phone;
    }
    if (email != null && email.isNotEmpty) {
      data['email'] = email;
    }

    return sendPostRequest(url, data: data, hasToken: false);
  }

  Future<IOResponse> checkOtp({
    required String phoneNumber,
    required String otp,
    required String type,
  }) async {
    const url = '/api/users/otp/verify';
    final data = {
      'phone_number': phoneNumber,
      'code': otp,
      'otp_type': type,
    };
    return sendPostRequest(url, data: data, hasToken: false);
  }

  Future<IOResponse> register({
    required SignUpModel model,
    required userType,
    required pass,
    required String uploadFile,
    required String workedYears,
  }) async {
    const url = '/api/users/register';
    final List<MultipartFile> files = model.uploadedImages.map((path) {
      return MultipartFile.fromFileSync(
        path,
        filename: path.split('/').last,
      );
    }).toList();

    final Map<String, dynamic> formDataMap = {
      'token': model.otpToken,
      'phone_number': model.phone,
      'first_name': model.firstName,
      'last_name': model.lastName,
      'sex': model.sex,
      'email': model.email,
      'user_type': userType,
      'date_of_birth': model.dataBirth,
      'password': pass,
      'fcm_token': HelperManager.fcmToken,
      'hospital_id': model.hospitalId,
      'specialization_ids': model.specializationIds,
      'nursing_certificate': files.length == 1 ? files[0] : files,
      'worked_years': workedYears,
    };

    if (model.diplomaFront.isNotEmpty) {
      formDataMap['diploma_front'] = MultipartFile.fromFileSync(
        model.diplomaFront,
        filename: model.diplomaFront.split('/').last,
      );
    }

    if (model.diplomaBack.isNotEmpty) {
      formDataMap['diploma_back'] = MultipartFile.fromFileSync(
        model.diplomaBack,
        filename: model.diplomaBack.split('/').last,
      );
    }

    final formData = FormData.fromMap(formDataMap);

    return sendMultiPartRequest(url, formData: formData);
  }

  Future<IOResponse> getAccess({
    required String refresh,
  }) async {
    const path = '/api/users/auth/refresh';
    final data = {
      "refresh": refresh,
    };
    return sendPostRequest(path, data: data, hasToken: false);
  }

  Future<IOResponse> userInfo() async {
    const path = '/api/users/profile';
    return sendGetRequest(path);
  }

  Future<IOResponse> forgetPassChange({
    required String token,
    required String phone,
    required String newPass,
  }) async {
    const path = '/api/users/reset-password';
    final data = {
      'token': token,
      'phone_number': phone,
      'new_password': newPass
    };
    return sendPostRequest(
      path,
      data: data,
      hasToken: false,
    );
  }

  Future<IOResponse> logout() async {
    const path = '/api/users/logout';
    return sendPostRequest(path, hasToken: true);
  }
}
