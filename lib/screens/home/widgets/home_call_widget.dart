import 'package:flutter/material.dart';
import 'package:nuPro/library/client/models/profile_model.dart';
import 'package:nuPro/library/components/button/io_button_model.dart';
import 'package:nuPro/library/components/button/io_button_widget.dart';
import 'package:nuPro/library/shared/shared.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/library/utils/greeting_util.dart';

class HomeCallWidget extends StatelessWidget {
  final VoidCallback? onTapCall;
  final ProfileModel profileInfo;
  final String? callStatusLabel;
  final VoidCallback? toggleCall;
  const HomeCallWidget({
    super.key,
    this.onTapCall,
    required this.profileInfo,
    this.callStatusLabel,
    this.toggleCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IOColors.brand500,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${GreetingUtil.getGreeting()}!',
                  style: IOStyles.body2Bold.copyWith(
                    color: IOColors.backgroundPrimary,
                  ),
                ),
                Text(
                  "${profileInfo.lastName} ${profileInfo.firstName}",
                  style: IOStyles.h6.copyWith(
                    color: IOColors.backgroundPrimary,
                  ),
                ),
                if (HelperManager.profileInfo.userType != 'nurse')
                  IOButtonWidget(
                    model: IOButtonModel(
                      label: 'Дуудлага өгөх',
                      type: IOButtonType.secondary,
                      size: IOButtonSize.small,
                      suffixIcon: 'call-medicine-rounded-svgrepo-com.svg',
                    ),
                    onPressed: onTapCall,
                  )
                else
                  IOButtonWidget(
                    model: IOButtonModel(
                      label: callStatusLabel ?? 'Дуудлага идэвхжүүлэх',
                      type: (callStatusLabel == 'Дуудлага идэвхжүүлсэн')
                          ? IOButtonType.success
                          : IOButtonType.secondary,
                      size: IOButtonSize.small,
                      suffixIcon: 'call-medicine-rounded-svgrepo-com.svg',
                    ),
                    onPressed: toggleCall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
