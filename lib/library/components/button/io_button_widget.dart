import 'package:nuPro/library/components/button/io_button_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IOButtonWidget extends StatelessWidget {
  final IOButtonMainModel model;
  final VoidCallback? onPressed;
  const IOButtonWidget({
    super.key,
    required this.model,
    this.onPressed,
  });

  VoidCallback? onTap() {
    return (model.isLoading || !model.isEnabled) ? null : onPressed;
  }

  Widget get child => model.onlyIcon
      ? Center(
          child: SizedBox.square(
            dimension: model.size.iconSize,
            child: model.isLoading
                ? CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(
                      model.foreColor,
                    ),
                  )
                : SvgPicture.asset(
                    'assets/icons/${model.icon}',
                    width: model.size.iconSize,
                    height: model.size.iconSize,
                    colorFilter: ColorFilter.mode(
                      model.foreColor,
                      BlendMode.srcIn,
                    ),
                  ),
          ),
        )
      : Padding(
          padding: model.size.padding,
          child: Row(
            mainAxisSize:
                model.isExpanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: model.isLoading
                ? [
                    SizedBox.square(
                      dimension: model.size.iconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          model.foreColor,
                        ),
                      ),
                    )
                  ]
                : [
                    if (model.hasPrefix)
                      Padding(
                        padding: EdgeInsets.only(
                          right: model.size.separator,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/${model.prefixIcon}',
                          width: model.size.iconSize,
                          height: model.size.iconSize,
                          colorFilter: ColorFilter.mode(
                            model.foreColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    Flexible(
                      child: Text(
                        model.label,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: model.size.style.copyWith(
                          color: model.foreColor,
                        ),
                      ),
                    ),
                    if (model.hasSuffix)
                      Padding(
                        padding: EdgeInsets.only(
                          left: model.size.separator,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/${model.suffixIcon}',
                          width: model.size.iconSize,
                          height: model.size.iconSize,
                          colorFilter: ColorFilter.mode(
                            model.foreColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                  ],
          ),
        );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: model.size.height,
      width: model.onlyIcon ? model.size.height : null,
      child: switch (model.type) {
        (IOButtonType.primary ||
              IOButtonType.success ||
              IOButtonType.secondary ||
              IOButtonType.oulineBrand ||
              IOButtonType.oulineGray) =>
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: model.foreColor,
              backgroundColor: model.backColor,
              disabledForegroundColor: model.foreColor,
              disabledBackgroundColor: model.backColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  model.borderRadius,
                ),
              ),
              side: BorderSide(
                width: 1.5,
                color: model.borderColor,
              ),
            ),
            onPressed: onTap(),
            child: child,
          ),
        (IOButtonType.textBrand || IOButtonType.textGray) => TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: model.foreColor,
              backgroundColor: model.backColor,
              disabledForegroundColor: model.foreColor,
              disabledBackgroundColor: model.backColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  model.borderRadius,
                ),
              ),
            ),
            onPressed: onTap(),
            child: child,
          ),
      },
    );
  }
}
