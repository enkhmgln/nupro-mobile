import 'package:flutter/material.dart';
import 'package:nuPro/library/components/main/io_gesture.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';

class ContactItemWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  const ContactItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IOGesture(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _getMaterialIcon(icon),
              size: 24,
              color: IOColors.brand500,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: IOStyles.body2Semibold,
                  ),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: IOStyles.body2Regular.copyWith(
                      color: IOColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: IOColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMaterialIcon(String iconName) {
    switch (iconName) {
      case 'person':
        return Icons.person;
      case 'language':
        return Icons.language;
      case 'share':
        return Icons.share;
      case 'link':
        return Icons.link;
      case 'phone':
        return Icons.phone;
      case 'mail':
        return Icons.mail;
      case 'web':
        return Icons.web;
      default:
        return Icons.info;
    }
  }
}
