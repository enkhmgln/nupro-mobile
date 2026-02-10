import 'package:g_json/g_json.dart';

class HomeBannerModel {
  final int id;
  final String image;
  final String url;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get imageUrl => image;

  HomeBannerModel.fromJson(JSON json)
      : id = json['id'].integerValue,
        image = json['image'].stringValue,
        url = json['url'].stringValue,
        isActive = json['is_active'].booleanValue,
        createdAt = DateTime.parse(json['created_at'].stringValue),
        updatedAt = DateTime.parse(json['updated_at'].stringValue);
}
