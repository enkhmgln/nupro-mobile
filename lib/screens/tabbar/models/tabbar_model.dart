import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nuPro/library/theme/io_colors.dart';

class TabBarModel {
  final String icon;
  final String label;
  final bool isFab;
  final Widget screen;
  final color = IOColors.textTertiary;
  final activeColor = IOColors.brand600;

  TabBarModel({
    this.icon = '',
    this.label = '',
    this.isFab = false,
    required this.screen,
  });
}
