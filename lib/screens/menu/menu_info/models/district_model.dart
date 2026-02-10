import 'package:g_json/g_json.dart';

class Districts {
  int? id;
  String? name;
  int? city;
  String? cityName;
  String? cityCode;

  Districts.fromJson(JSON json)
      : id = json['id'].integerValue,
        name = json['name'].stringValue,
        city = json['city'].integerValue,
        cityName = json['city_name'].stringValue,
        cityCode = json['city_code'].stringValue;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'city_name': cityName,
      'city_code': cityCode,
    };
  }
}
