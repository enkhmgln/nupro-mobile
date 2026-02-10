import 'package:flutter/material.dart';

class IOIconModel {
  final IOIconType type;
  String icon;
  Color? tinColor;
  double? width;
  double? height;

  IOIconModel({
    required this.type,
    required this.icon,
    this.tinColor,
    this.width,
    this.height,
  });
}

enum IOIconType { svg, image }
