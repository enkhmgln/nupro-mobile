import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nuPro/library/components/button/io_button_opacity_widget.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/notification/notification_list/models/notification_list_model.dart';

class NotificatoinListItemWidget extends StatelessWidget {
  final NotificationListModel item;
  final VoidCallback onTap;
  const NotificatoinListItemWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IOButtonOpacityWidget(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: IOColors.brand50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/${item.type.icon}',
                    colorFilter: const ColorFilter.mode(
                      IOColors.brand600,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                if (!item.isViewed)
                  Transform.translate(
                    offset: const Offset(5, -5),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: IOColors.secondary500,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 2,
                          color: IOColors.secondary300,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style:
                        IOStyles.body2Bold.copyWith(color: IOColors.brand700),
                  ),
                  Text(
                    item.body,
                    style: IOStyles.body2Regular
                        .copyWith(color: IOColors.brand700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${item.createdAt.year}/${item.createdAt.month}/${item.createdAt.day.toString().padLeft(2, '0')} '
                    '${item.createdAt.hour.toString().padLeft(2, '0')}:${item.createdAt.minute.toString().padLeft(2, '0')}',
                    style: IOStyles.caption1Regular
                        .copyWith(color: IOColors.brand200),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
