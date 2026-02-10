import 'package:g_json/g_json.dart';

class ContactModel {
  String fullName;
  String email;
  String phoneNumber;
  String sex;
  String dateOfBirth;
  String userType;
  String profilePicture;
  String location;
  String city;
  String district;
  String subDistrict;
  String lastLogin;

  ContactModel.fromJson(JSON json)
      : fullName = json['full_name'].stringValue,
        email = json['email'].stringValue,
        phoneNumber = json['phone_number'].stringValue,
        sex = json['sex'].stringValue,
        dateOfBirth = json['date_of_birth'].stringValue,
        userType = json['user_type'].stringValue,
        profilePicture = json['profile_picture'].stringValue,
        location = json['location'].stringValue,
        city = json['city'].stringValue,
        district = json['district'].stringValue,
        subDistrict = json['sub_district'].stringValue,
        lastLogin = json['last_login'].stringValue;

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'sex': sex,
      'date_of_birth': dateOfBirth,
      'user_type': userType,
      'profile_picture': profilePicture,
      'location': location,
      'city': city,
      'district': district,
      'sub_district': subDistrict,
      'last_login': lastLogin,
    };
  }
}

// import 'package:g_json/g_json.dart';

// class ContactModel {
//   final String phone;
//   final String email;
//   final String address;
//   final String facebook;
//   final String instagram;
//   final String twitter;
//   final String youtube;
//   final String web;

//   ContactModel.fromJson(JSON json)
//       : phone = json['phone'].stringValue,
//         email = json['email'].stringValue,
//         address = json['address'].stringValue,
//         facebook = json['facebook'].stringValue,
//         instagram = json['instagram'].stringValue,
//         twitter = json['twitter'].stringValue,
//         youtube = json['youtube'].stringValue,
//         web = json['web'].stringValue;

//   ContactModel.mock()
//       : phone = '12345678',
//         email = 'info@nuPro.mn',
//         address = 'Улаанбаатар, Монгол',
//         facebook = 'https://facebook.com/nuPro',
//         instagram = 'https://instagram.com/nuPro',
//         twitter = 'https://twitter.com/nuPro',
//         youtube = 'https://youtube.com/nuPro',
//         web = 'https://nuPro.mn';
// }
