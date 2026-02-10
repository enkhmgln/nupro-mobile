import 'package:g_json/g_json.dart';

class HospitalInfoModel {
  final int id;
  final String name;
  final String nameEn;
  final String address;
  final String phoneNumber;
  final String email;
  final String website;
  final String hospitalType;
  final String hospitalTypeDisplay;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  HospitalInfoModel.fromJson(JSON json)
      : id = json['id'].integerValue,
        name = json['name'].stringValue,
        nameEn = json['name_en'].stringValue,
        address = json['address'].stringValue,
        phoneNumber = json['phone_number'].stringValue,
        email = json['email'].stringValue,
        website = json['website'].stringValue,
        hospitalType = json['hospital_type'].stringValue,
        hospitalTypeDisplay = json['hospital_type_display'].stringValue,
        isActive = json['is_active'].booleanValue,
        createdAt = json['created_at'].stringValue,
        updatedAt = json['updated_at'].stringValue;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'address': address,
      'phone_number': phoneNumber,
      'email': email,
      'website': website,
      'hospital_type': hospitalType,
      'hospital_type_display': hospitalTypeDisplay,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
