import 'package:g_json/g_json.dart';

class CitiesModel {
  List<CityData>? data;
  String? message;

  CitiesModel({
    this.data,
    this.message,
  });

  CitiesModel.fromJson(JSON json) {
    data = <CityData>[];
    for (var v in json['data'].listValue) {
      data!.add(CityData.fromJson(v));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toMap()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class CityData {
  int id;
  int code;
  String? name;

  CityData.fromJson(JSON json)
      : id = json['id'].integerValue,
        code = json['code'].integerValue,
        name = json['name'].stringValue;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
    };
  }
}
