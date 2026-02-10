import 'package:g_json/g_json.dart';

class ContactListModel {
  final int id;
  final int user;
  final String fullName;
  final int role;
  final String roleName;
  final List<ContactLinkModel> activeLinks;
  final String createdAt;
  final String updatedAt;

  ContactListModel({
    required this.id,
    required this.user,
    required this.fullName,
    required this.role,
    required this.roleName,
    required this.activeLinks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContactListModel.fromJson(JSON json) {
    return ContactListModel(
      id: json['id'].integerValue,
      user: json['user'].integerValue,
      fullName: json['full_name'].stringValue,
      role: json['role'].integerValue,
      roleName: json['role_name'].stringValue,
      activeLinks: json['active_links']
          .listValue
          .map((e) => ContactLinkModel.fromJson(e))
          .toList(),
      createdAt: json['created_at'].stringValue,
      updatedAt: json['updated_at'].stringValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'full_name': fullName,
      'role': role,
      'role_name': roleName,
      'active_links': activeLinks.map((e) => e.toMap()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class ContactLinkModel {
  final int id;
  final String linkType;
  final String title;
  final String url;
  final String description;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  ContactLinkModel({
    required this.id,
    required this.linkType,
    required this.title,
    required this.url,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContactLinkModel.fromJson(JSON json) {
    return ContactLinkModel(
      id: json['id'].integerValue,
      linkType: json['link_type'].stringValue,
      title: json['title'].stringValue,
      url: json['url'].stringValue,
      description: json['description'].stringValue,
      isActive: json['is_active'].booleanValue,
      createdAt: json['created_at'].stringValue,
      updatedAt: json['updated_at'].stringValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'link_type': linkType,
      'title': title,
      'url': url,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
