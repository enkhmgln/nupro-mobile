import 'package:flutter/material.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';

class HomeCustomAppbarWidget extends StatelessWidget {
  final VoidCallback onTapProfile;
  final Widget calling;
  const HomeCustomAppbarWidget({
    super.key,
    required this.onTapProfile,
    required this.calling,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: kToolbarHeight + 192,
      pinned: true,
      backgroundColor: IOColors.backgroundPrimary,
      centerTitle: false,
      leadingWidth: 124,
      leading: Padding(
        padding: const EdgeInsets.only(
          left: 24,
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 38,
              height: 38,
              fit: BoxFit.contain,
            ),
            Flexible(
              child: Text(
                'NuPro',
                overflow: TextOverflow.ellipsis,
                style: IOStyles.body1Bold.copyWith(
                  color: IOColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: GestureDetector(
            onTap: onTapProfile,
            child: CircleAvatar(
              radius: 20,
              backgroundImage:
                  HelperManager.profileInfo.profilePicture.isNotEmpty
                      ? NetworkImage(HelperManager.profileInfo.profilePicture)
                      : const AssetImage('assets/images/profile.png')
                          as ImageProvider,
            ),
          ),
        ),
      ],
      stretch: true,
      flexibleSpace: Stack(
        children: [
          FlexibleSpaceBar(
            background: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    height: 144,
                    child: calling,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
