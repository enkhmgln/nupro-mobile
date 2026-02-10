import 'package:nuPro/library/theme/io_colors.dart';
import 'package:flutter/material.dart';

class IOTheme {
  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: IOColors.backgroundSecondary,

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: IOColors.brand600,
      iconTheme: IconThemeData(
        color: IOColors.backgroundPrimary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(
      thickness: 1,
      color: IOColors.strokePrimary,
    ),

    // extensions: <ThemeExtension<dynamic>>[lightColors],
  );
}
