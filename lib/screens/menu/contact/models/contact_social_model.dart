class ContactSocialModel {
  final ContactSocialType linkType;
  final String icon;
  final String name;
  final String link;

  ContactSocialModel({
    required this.linkType,
    required this.icon,
    required this.name,
    required this.link,
  });
}

enum ContactSocialType { phone, mail, link }
