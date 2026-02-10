import 'package:nuPro/library/theme/io_colors.dart';
import 'package:flutter/material.dart';

class IOShadow {
  static final primary1 = [
    BoxShadow(
      offset: const Offset(0, 1),
      blurRadius: 1,
      color: IOColors.brand500.withOpacity(0.08),
    ),
  ];
  static final primary2 = [
    BoxShadow(
      offset: const Offset(0, 2),
      blurRadius: 13,
      color: IOColors.brand500.withOpacity(0.08),
    ),
  ];
  static final primary3 = [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 5,
      spreadRadius: -1,
      color: IOColors.brand500.withOpacity(0.08),
    ),
  ];
  static final primary4 = [
    BoxShadow(
      offset: const Offset(0, 7),
      blurRadius: 7,
      spreadRadius: -2,
      color: IOColors.brand500.withOpacity(0.08),
    ),
  ];
  static final primary5 = [
    BoxShadow(
      offset: const Offset(0, 8),
      blurRadius: 11,
      spreadRadius: -3,
      color: IOColors.brand500.withOpacity(0.08),
    ),
  ];
  static final primary6 = [
    BoxShadow(
      offset: const Offset(0, 12),
      blurRadius: 19,
      spreadRadius: -5,
      color: IOColors.brand500.withOpacity(0.08),
    ),
  ];
  static final primary7 = [
    BoxShadow(
      offset: const Offset(0, 24),
      blurRadius: 24,
      spreadRadius: -16,
      color: IOColors.brand500.withOpacity(0.08),
    ),
  ];
  static final primary8 = [
    BoxShadow(
      offset: const Offset(0, 12),
      blurRadius: 24,
      spreadRadius: -21,
      color: IOColors.brand500.withOpacity(0.08),
    ),
  ];

  static final black2 = [
    BoxShadow(
      offset: const Offset(1, 1),
      blurRadius: 6,
      spreadRadius: 0,
      color: Colors.black.withOpacity(0.08),
    ),
  ];

  static final black8 = [
    BoxShadow(
      offset: const Offset(0, 6),
      blurRadius: 24,
      spreadRadius: -20,
      color: Colors.black.withOpacity(0.03),
    ),
  ];
}
