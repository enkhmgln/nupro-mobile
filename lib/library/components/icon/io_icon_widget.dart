import 'package:nuPro/library/components/icon/io_icon_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IOIconWidget extends StatelessWidget {
  final IOIconModel model;
  const IOIconWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return switch (model.type) {
      IOIconType.svg => SvgPicture.asset(
          'assets/icons/${model.icon}',
          width: model.width,
          height: model.height,
          colorFilter: model.tinColor == null
              ? null
              : ColorFilter.mode(
                  model.tinColor!,
                  BlendMode.srcIn,
                ),
        ),
      IOIconType.image => Image.asset(
          'assets/images/${model.icon}',
          width: model.width,
          height: model.height,
          color: model.tinColor,
        ),
    };
  }
}
