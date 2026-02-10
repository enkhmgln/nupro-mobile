class MenuTabModel {
  final String title;
  final List<MenuTabItemModel> items;

  MenuTabModel({
    required this.title,
    required this.items,
  });
}

class MenuTabItemModel {
  final MenuTabItemType type;
  final bool isSvg;
  bool? value;

  MenuTabItemModel({
    required this.type,
    this.isSvg = true,
    this.value,
  });
}

enum MenuTabItemType {
  // branch(title: 'Салбарын байршил', icon: 'profile.svg'),
  myRatings(title: 'Миний үнэлгээ', icon: 'star-svgrepo-com.svg'),
  ratingNurse(title: 'Сувилагчийн үнэлгээ', icon: 'star-svgrepo-com.svg'),
  contact(title: 'Холбоо барих', icon: 'contact-pin-location-svgrepo-com.svg'),
  faq(title: 'Түгээмэл асуулт хариулт', icon: 'faq-svgrepo-com.svg'),
  terms(
      title: 'Үйлчилгээний нөхцөл',
      icon: 'bank-building-finance-svgrepo-com.svg'),
  policy(title: 'Нууцлалын бодлого', icon: 'policy-analyzer-svgrepo-com.svg'),
  logout(title: 'Системээс гарах', icon: 'logout-2-svgrepo-com.svg');

  const MenuTabItemType({
    required this.title,
    required this.icon,
  });
  final String title;
  final String icon;
}
