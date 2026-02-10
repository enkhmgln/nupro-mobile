import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nuPro/library/client/models/profile_model.dart';
import 'package:nuPro/library/components/button/io_button_opacity_widget.dart';
import 'package:nuPro/library/components/image/io_image_network_widget.dart';
import 'package:nuPro/library/components/main/io_card_border.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';

class MenuProfileWidget extends StatelessWidget {
  final ProfileModel user;
  final VoidCallback onTap;

  const MenuProfileWidget({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: IOCardBorderWidget(
        padding: EdgeInsets.zero,
        child: IOButtonOpacityWidget(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox.square(
                  dimension: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: IOImageNetworkWidget(
                      imageUrl: user.profilePicture,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName} ${user.lastName}',
                        overflow: TextOverflow.ellipsis,
                        style: IOStyles.body2Bold.copyWith(
                          color: IOColors.brand700,
                        ),
                      ),
                      Text(
                        user.phoneNumber,
                        overflow: TextOverflow.ellipsis,
                        style: IOStyles.caption1Medium.copyWith(
                          color: IOColors.brand400,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SvgPicture.asset(
                    'assets/icons/chevron.right.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      IOColors.brand600,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
