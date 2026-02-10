import 'package:g_json/g_json.dart';

class ProfileModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String sex;
  final String userType;
  final String dateOfBirth;
  final String subDistrict;
  final String subDistrictName;
  final String districtName;
  final String cityName;
  final String fullLocation;
  String profilePicture;
  final String createdAt;
  final String lastLogin;
  final dynamic nurseProfile;

  ProfileModel.fromJson(JSON json)
      : id = json['id'].integerValue,
        firstName = json['first_name'].stringValue,
        lastName = json['last_name'].stringValue,
        email = json['email'].stringValue,
        phoneNumber = json['phone_number'].stringValue,
        sex = json['sex'].stringValue,
        userType = json['user_type'].stringValue,
        dateOfBirth = json['date_of_birth'].stringValue,
        subDistrict = json['sub_district'].stringValue,
        subDistrictName = json['sub_district_name'].stringValue,
        districtName = json['district_name'].stringValue,
        cityName = json['city_name'].stringValue,
        fullLocation = json['full_location'].stringValue,
        profilePicture = json['profile_picture'].stringValue,
        createdAt = json['created_at'].stringValue,
        lastLogin = json['last_login'].stringValue,
        nurseProfile = json['nurse_profile'].value;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'sex': sex,
      'user_type': userType,
      'date_of_birth': dateOfBirth,
      'sub_district': subDistrict,
      'sub_district_name': subDistrictName,
      'district_name': districtName,
      'city_name': cityName,
      'full_location': fullLocation,
      'profile_picture': profilePicture,
      'created_at': createdAt,
      'last_login': lastLogin,
      'nurse_profile': nurseProfile,
    };
  }
}
