import 'package:flutter/material.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';

class IOAppBar extends AppBar {
  IOAppBar({
    super.key,
    super.bottom,
    super.leading,
    super.leadingWidth,
    super.actions,
    String? titleText,
    Widget? title,
  }) : super(
          backgroundColor: IOColors.brand500,
          iconTheme: const IconThemeData(
            color: IOColors.backgroundPrimary,
          ),
          centerTitle: true,
          title: title ??
              Text(
                titleText ?? '',
                style: IOStyles.body1Bold.copyWith(
                  color: IOColors.backgroundPrimary,
                ),
              ),
        );
}
