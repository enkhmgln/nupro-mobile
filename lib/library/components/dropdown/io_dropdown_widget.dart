import 'package:nuPro/library/components/dropdown/io_dropdown_model.dart';
import 'package:nuPro/library/components/dropdown/io_dropdown_sheet.dart';
import 'package:nuPro/library/components/dropdown/io_dropdown_sheet_model.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nuPro/library/library.dart';

class IODropdownWidget<T> extends StatelessWidget {
  final IODropdownModel model;
  final List<IODropdownSheetModel<T>> pickItems;
  final ValueChanged<IODropdownSheetModel<T>>? onSelect;
  final VoidCallback? onTap;
  const IODropdownWidget({
    super.key,
    required this.model,
    required this.pickItems,
    this.onSelect,
  }) : onTap = null;

  IODropdownWidget.custom({
    super.key,
    required this.model,
    required this.onTap,
  })  : pickItems = [],
        onSelect = null;

  @override
  Widget build(BuildContext context) {
    return IOTextfieldWidget(
      model: model,
      suffix: SizedBox.square(
        dimension: 48,
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/${model.icon}',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            colorFilter: const ColorFilter.mode(
              IOColors.textSecondary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      onTap: onTap ?? showBottomSheet,
    );
  }

  showBottomSheet() async {
    final value = await IODropdownSheet<T>(
      title: model.sheetTitle,
      items: pickItems,
    ).show();

    if (value == null) return;

    onSelect?.call(value);
  }
}
