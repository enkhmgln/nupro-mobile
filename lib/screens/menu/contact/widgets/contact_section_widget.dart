import 'package:flutter/material.dart';
import 'package:nuPro/library/theme/io_styles.dart';

class ContactSectionWidget extends StatelessWidget {
  final String title;
  const ContactSectionWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: IOStyles.body2Bold,
      ),
    );
  }
}
