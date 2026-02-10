import 'package:g_json/g_json.dart';

class SubDistrictModel {
  District? district;
  List<SubDistricts>? subDistricts;

  SubDistrictModel({this.district, this.subDistricts});

  SubDistrictModel.fromJson(Map<String, dynamic> json) {
    district =
        json['district'] != null ? District.fromJson(json['district']) : null;
    if (json['sub_districts'] != null) {
      subDistricts = <SubDistricts>[];
      json['sub_districts'].forEach((v) {
        subDistricts!.add(SubDistricts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (district != null) {
      data['district'] = district!.toJson();
    }
    if (subDistricts != null) {
      data['sub_districts'] = subDistricts!.map((v) => v).toList();
    }
    return data;
  }
}

class District {
  int? id;
  String? name;
  int? city;
  String? cityName;
  String? cityCode;

  District({this.id, this.name, this.city, this.cityName, this.cityCode});

  District.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    city = json['city'];
    cityName = json['city_name'];
    cityCode = json['city_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['city'] = city;
    data['city_name'] = cityName;
    data['city_code'] = cityCode;
    return data;
  }
}

class SubDistricts {
  int? id;
  String? name;
  int? city;
  int? district;
  String? cityName;
  String? cityCode;
  String? districtName;

  SubDistricts(
      {this.id,
      this.name,
      this.city,
      this.district,
      this.cityName,
      this.cityCode,
      this.districtName});

  SubDistricts.fromJson(JSON json)
      : id = json['id'].integerValue,
        name = json['name'].stringValue,
        city = json['city'].integerValue,
        district = json['district'].integerValue,
        cityName = json['city_name'].stringValue,
        cityCode = json['city_code'].stringValue,
        districtName = json['district_name'].stringValue;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'district': district,
      'city_name': cityName,
      'city_code': cityCode,
      'district_name': districtName,
    };
  }
}
