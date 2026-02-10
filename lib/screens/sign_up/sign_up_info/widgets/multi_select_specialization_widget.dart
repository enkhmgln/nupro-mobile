import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/screens/sign_up/sign_up_info/model/specialization_model.dart';

class MultiSelectSpecializationWidget extends StatelessWidget {
  final List<SpecializationModel> allSpecializations;
  final List<SpecializationModel> selectedSpecializations;
  final Function(List<SpecializationModel>) onChanged;

  const MultiSelectSpecializationWidget({
    super.key,
    required this.allSpecializations,
    required this.selectedSpecializations,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMultiSelectDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: IOColors.backgroundPrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: IOColors.backgroundSecondary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: selectedSpecializations.isEmpty
                  ? Text(
                      'Мэргэжил сонгох',
                      style: IOStyles.body2Medium
                          .copyWith(color: IOColors.textSecondary),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedSpecializations.map((spec) {
                        return Chip(
                          label: Text(
                            spec.name,
                            style: IOStyles.caption2Medium
                                .copyWith(color: IOColors.backgroundPrimary),
                          ),
                          backgroundColor: IOColors.brand700,
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 16,
                            color: IOColors.backgroundPrimary,
                          ),
                          onDeleted: () {
                            final newList = List<SpecializationModel>.from(
                                selectedSpecializations);
                            newList.remove(spec);
                            onChanged(newList);
                          },
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset('assets/icons/chevron_down.svg'),
          ],
        ),
      ),
    );
  }

  void _showMultiSelectDialog(BuildContext context) {
    final tempSelected =
        List<SpecializationModel>.from(selectedSpecializations);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Мэргэжил сонгох',
                        style: IOStyles.h6,
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: Get.height * 0.5,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: allSpecializations.map((specialization) {
                          final isSelected = tempSelected
                              .any((s) => s.id == specialization.id);
                          return CheckboxListTile(
                            title: Text(
                              specialization.name,
                              style: IOStyles.body2Medium,
                            ),
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  tempSelected.add(specialization);
                                } else {
                                  tempSelected.removeWhere(
                                      (s) => s.id == specialization.id);
                                }
                              });
                            },
                            activeColor: IOColors.brand700,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: IOColors.brand700),
                          ),
                          child: Text(
                            'Цуцлах',
                            style: IOStyles.body2Semibold
                                .copyWith(color: IOColors.brand700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            onChanged(tempSelected);
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: IOColors.brand700,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Хадгалах',
                            style: IOStyles.body2Semibold
                                .copyWith(color: IOColors.backgroundPrimary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
