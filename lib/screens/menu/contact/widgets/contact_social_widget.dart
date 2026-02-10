import 'package:flutter/material.dart';
import 'package:nuPro/library/components/main/io_card_border.dart';
import 'package:nuPro/screens/menu/contact/models/contact_social_model.dart';
import 'package:nuPro/screens/menu/contact/widgets/contact_item_widget.dart';

class ContactSocialWidget extends StatelessWidget {
  final List<ContactSocialModel> items;
  final ValueChanged<ContactSocialModel> onTap;
  const ContactSocialWidget({
    super.key,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IOCardBorderWidget(
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = items[index];
          return ContactItemWidget(
            icon: item.icon,
            title: item.name,
            description: item.link,
            onTap: () => onTap(item),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(height: 1, thickness: 1);
        },
        itemCount: items.length,
      ),
    );
  }
}
