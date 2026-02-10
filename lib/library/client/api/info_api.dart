import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:nuPro/library/library.dart';

class InfoApi extends IOClient {
  Future<IOResponse> getFaq({
    required int page,
    required int limit,
  }) async {
    const url = '/api/common/faqs';
    final query = {
      'page': page,
      'limit': limit,
    };

    return sendGetRequest(url, query: query, hasToken: false);
  }

  Future<IOResponse> getHospitalInfo() {
    const url = '/api/nurses/hospitals';
    return sendGetRequest(url, hasToken: false);
  }

  Future<IOResponse> getSpecializations() {
    const url = '/api/nurses/specializations';
    return sendGetRequest(url, hasToken: false);
  }

  Future<IOResponse> getContactList() {
    const url = "/api/contacts/list";
    return sendGetRequest(url);
  }

  Future<IOResponse> profileImageChange(String profilePicture) async {
    const url = "/api/users/profile/picture";

    final base64Str = profilePicture.contains(",")
        ? profilePicture.split(",").last
        : profilePicture;

    final bytes = base64Decode(base64Str);

    final formData = FormData.fromMap({
      "profile_picture": MultipartFile.fromBytes(
        bytes,
        filename: "profile_picture.png",
        contentType: MediaType("image", "png"),
      ),
    });

    return sendMultiPartPutRequest(url, formData: formData);
  }

  Future<String?> getTermsOfService() async {
    try {
      const url = '/api/common/terms-of-service';
      final dio = getDio(hasToken: false);
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        return response.data?.toString();
      }
      return null;
    } catch (e) {
      print('Error fetching Terms of Service: $e');
      return null;
    }
  }

  Future<String?> getPrivacyPolicy() async {
    try {
      const url = '/api/common/privacy-policy';
      final dio = getDio(hasToken: false);
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        return response.data?.toString();
      }
      return null;
    } catch (e) {
      print('Error fetching Privacy Policy: $e');
      return null;
    }
  }

  Future<IOResponse> getMyRatings() {
    const url = '/api/ratings/my-ratings';
    return sendGetRequest(url);
  }

  Future<IOResponse> getRatingsNurse({
    required String id,
  }) {
    final url = '/api/ratings/nurse/$id';
    return sendGetRequest(url);
  }
}
