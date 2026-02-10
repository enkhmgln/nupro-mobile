import 'package:flutter/material.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';

class IOChip extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback? onPressed;
  const IOChip({
    super.key,
    required this.title,
    required this.selected,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 16,
        ),
        backgroundColor: IOColors.backgroundPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: selected
            ? const BorderSide(
                width: 1.5,
                color: IOColors.brand500,
              )
            : const BorderSide(
                width: 1,
                color: IOColors.strokePrimary,
              ),
      ),
      child: Text(
        title,
        style: IOStyles.caption1Medium.copyWith(
          color: selected ? IOColors.textPrimary : IOColors.textSecondary,
        ),
      ),
    );
  }
}
