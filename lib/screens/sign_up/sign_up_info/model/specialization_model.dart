import 'package:g_json/g_json.dart';

class SpecializationModel {
  final int id;
  final String name;

  SpecializationModel({required this.id, required this.name});

  SpecializationModel.fromJson(JSON json)
      : id = json['id'].integerValue,
        name = json['name'].stringValue;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
