import 'package:g_json/g_json.dart';

class UserModel {
  final String lastName;
  final String statusName;
  final String lastName2;
  final String registerCode;
  final String email;
  final String fullName;
  final String firstName;
  final String phone;
  final String address;

  UserModel.fromJson(JSON json)
      : lastName = json['lastName'].stringValue,
        statusName = json['statusName'].stringValue,
        lastName2 = json['lastName2'].stringValue,
        registerCode = json['registerCode'].stringValue,
        email = json['email'].stringValue,
        fullName = json['fullName'].stringValue,
        firstName = json['firstName'].stringValue,
        phone = json['phone'].stringValue,
        address = json['address'].stringValue;

  Map<String, dynamic> toMap() {
    return {
      'lastName': lastName,
      'statusName': statusName,
      'lastName2': lastName2,
      'registerCode': registerCode,
      'email': email,
      'fullName': fullName,
      'firstName': firstName,
      'phone': phone,
      'address': address,
    };
  }
}
