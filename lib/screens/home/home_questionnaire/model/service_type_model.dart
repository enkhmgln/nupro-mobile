import 'package:g_json/g_json.dart';

class ServiceTypeModel {
  final int id;
  final String name;
  final String description;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  ServiceTypeModel.fromJson(JSON json)
      : id = json['id'].integerValue,
        name = json['name'].stringValue,
        description = json['description'].stringValue,
        isActive = json['is_active'].booleanValue,
        createdAt = json['created_at'].stringValue,
        updatedAt = json['updated_at'].stringValue;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
