import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PasswordValidationWidget extends StatelessWidget {
  final String text;
  final bool isValid;

  const PasswordValidationWidget({
    super.key,
    required this.text,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox.square(
          dimension: 24,
          child: Center(
            child: SvgPicture.asset(
              isValid
                  ? 'assets/icons/check.circle.success.svg'
                  : 'assets/icons/check.circle.normal.svg',
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: IOStyles.caption1Regular.copyWith(
            color: isValid ? IOColors.successPrimary : IOColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
