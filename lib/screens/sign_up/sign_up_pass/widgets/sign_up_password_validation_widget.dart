import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUpPasswordValidationWidget extends StatelessWidget {
  final String text;
  final bool isValid;
  const SignUpPasswordValidationWidget({
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
            child: Container(
              width: 16,
              height: 16,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isValid
                    ? IOColors.successSecondary
                    : IOColors.strokePrimary,
                borderRadius: BorderRadius.circular(9),
              ),
              child: isValid
                  ? SvgPicture.asset(
                      'assets/icons/check.circle.success.svg',
                      colorFilter: const ColorFilter.mode(
                        IOColors.successPrimary,
                        BlendMode.srcIn,
                      ),
                    )
                  : SvgPicture.asset(
                      'assets/icons/check.circle.normal.svg',
                      colorFilter: const ColorFilter.mode(
                        IOColors.textSecondary,
                        BlendMode.srcIn,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: IOStyles.caption1Regular.copyWith(
            color: isValid ? IOColors.successPrimary : IOColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
