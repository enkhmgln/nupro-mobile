import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/button/io_button_widget.dart';
import 'package:nuPro/library/components/dropdown/io_dropdown_widget.dart';
import 'package:nuPro/library/components/dropdown/io_dropdown_model.dart';
import 'package:nuPro/library/components/dropdown/io_dropdown_sheet_model.dart';
import 'package:nuPro/library/components/main/io_appbar.dart';
import 'package:nuPro/library/components/main/io_bottom_navigation.dart';
import 'package:nuPro/library/components/main/io_card_border.dart';
import 'package:nuPro/library/components/main/io_scaffold.dart';
import 'package:nuPro/library/shared/helper_manager.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/screens/menu/menu_info/menu_info_controller.dart';
import 'package:nuPro/screens/menu/menu_info/widgets/menu_info_widget.dart';

class MenuInfoScreen extends GetView<MenuInfoController> {
  const MenuInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IOScaffold(
      appBar: IOAppBar(
        titleText: 'Миний мэдээлэл',
      ),
      body: Obx(
        () => GestureDetector(
          onTap: Get.focusScope?.unfocus,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                16, 24, 16, 24 + Get.mediaQuery.padding.bottom),
            child: IOCardBorderWidget(
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildAvatar(),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      '${controller.lastName.value} ${controller.firstName.value}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  MenuInfoWidget(
                    title: 'Нэр',
                    value: controller.firstName,
                    isEditable: true,
                  ),
                  MenuInfoWidget(
                    title: 'Овог',
                    value: controller.lastName,
                    isEditable: true,
                  ),
                  MenuInfoWidget(
                    title: 'И-мэйл',
                    value: controller.email,
                    isEditable: true,
                  ),
                  MenuInfoWidget(
                    title: 'Утас',
                    value: controller.phoneNumber,
                    isEditable: true,
                  ),
                  _buildSexField(),
                  MenuInfoWidget(
                    title: 'Төрсөн өдөр',
                    value: controller.dateOfBirth,
                    isEditable: true,
                  ),
                  // Location Section with better UI
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.location_on,
                                color: IOColors.brand500, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Хаяг',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Дараалалтай сонгоно уу',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // City Dropdown
                  Obx(() {
                    final items = controller.cities;
                    final value = controller.selectedCityId.value;
                    final dropdownModel = IODropdownModel<int>(
                      label: value == null
                          ? 'Хот сонгоно уу'
                          : HelperManager.profileInfo.cityName,
                      sheetTitle: 'Хот сонгох',
                      icon: 'chevron_down.svg',
                    );
                    final selected =
                        items.firstWhereOrNull((c) => c.id == value);

                    dropdownModel.setDropdownValue(selected == null
                        ? null
                        : IODropdownSheetModel<int>(
                            name: selected.name ?? '',
                            value: selected.id,
                          ));

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: IOColors.brand500, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12, top: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: IOColors.brand500,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '1',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Хот',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: IODropdownWidget<int>(
                              model: dropdownModel,
                              pickItems: items
                                  .map((city) => IODropdownSheetModel<int>(
                                      name: city.name ?? "", value: city.id))
                                  .toList(),
                              onSelect: (item) =>
                                  controller.onCitySelected(item.value),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // District Dropdown
                  Obx(() {
                    final citySelected =
                        controller.selectedCityId.value != null;
                    final items = controller.districts;
                    final value = controller.selectedDistrictId.value;
                    final dropdownModel = IODropdownModel<int>(
                      label: !citySelected
                          ? 'Эхлээд хот сонгоно уу'
                          : (value == null
                              ? 'Дүүрэг сонгоно уу'
                              : HelperManager.profileInfo.districtName),
                      sheetTitle: 'Дүүрэг сонгох',
                      icon: 'chevron_down.svg',
                    );
                    final selected =
                        items.firstWhereOrNull((d) => d.id == value);
                    dropdownModel.setDropdownValue(selected == null
                        ? null
                        : IODropdownSheetModel<int>(
                            name: selected.name ?? '',
                            value: selected.id!,
                          ));

                    return Opacity(
                      opacity: citySelected ? 1.0 : 0.5,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: citySelected
                                ? IOColors.brand500
                                : Colors.grey[400]!,
                            width: citySelected ? 1.5 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 8),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: citySelected
                                          ? IOColors.brand500
                                          : Colors.grey[400],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      '2',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Дүүрэг',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (!citySelected) ...[
                                    const SizedBox(width: 8),
                                    Icon(Icons.lock,
                                        size: 16, color: Colors.grey[400]),
                                  ],
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: IgnorePointer(
                                ignoring: !citySelected,
                                child: IODropdownWidget<int>(
                                  model: dropdownModel,
                                  pickItems: items
                                      .map((district) =>
                                          IODropdownSheetModel<int>(
                                              name: district.name ?? '',
                                              value: district.id!))
                                      .toList(),
                                  onSelect: citySelected
                                      ? (item) => controller
                                          .onDistrictSelected(item.value)
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // Sub-district Dropdown
                  Obx(() {
                    final districtSelected =
                        controller.selectedDistrictId.value != null;
                    final items = controller.subDistricts;
                    final value = controller.selectedSubDistrictId.value;
                    final dropdownModel = IODropdownModel<int>(
                      label: !districtSelected
                          ? 'Эхлээд дүүрэг сонгоно уу'
                          : (value == null
                              ? 'Хороо сонгоно уу'
                              : HelperManager.profileInfo.subDistrictName),
                      sheetTitle: 'Хороо сонгох',
                      icon: 'chevron_down.svg',
                    );
                    final selected =
                        items.firstWhereOrNull((s) => s.id == value);
                    dropdownModel.setDropdownValue(selected == null
                        ? null
                        : IODropdownSheetModel<int>(
                            name: selected.name ?? '',
                            value: selected.id!,
                          ));

                    return Opacity(
                      opacity: districtSelected ? 1.0 : 0.5,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: districtSelected
                                ? IOColors.brand500
                                : Colors.grey[400]!,
                            width: districtSelected ? 1.5 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 8),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: districtSelected
                                          ? IOColors.brand500
                                          : Colors.grey[400],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      '3',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Хороо',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (!districtSelected) ...[
                                    const SizedBox(width: 8),
                                    Icon(Icons.lock,
                                        size: 16, color: Colors.grey[400]),
                                  ],
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: IgnorePointer(
                                ignoring: !districtSelected,
                                child: IODropdownWidget<int>(
                                  model: dropdownModel,
                                  pickItems: items
                                      .map((sub) => IODropdownSheetModel<int>(
                                          name: sub.name ?? '', value: sub.id!))
                                      .toList(),
                                  onSelect: districtSelected
                                      ? (item) => controller
                                          .onSubDistrictSelected(item.value)
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: IOBottomNavigationBar(
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: IOButtonWidget(
              model: controller.updateButton.value,
              onPressed: controller.onTapUpdate,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: controller.onTapChangeAvatar,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    controller.proInfo.value.profilePicture,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person,
                          size: 100, color: Colors.grey);
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: controller.onTapChangeAvatar,
                  child: Container(
                    decoration: BoxDecoration(
                      color: IOColors.brand500,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSexField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(
        () => IODropdownWidget<String>(
          model: IODropdownModel(
            label: 'Хүйс',
            sheetTitle: 'Хүйс сонгох',
            icon: 'chevron_down.svg',
          )..setDropdownValue(
              controller.sexDisplay.value.isEmpty
                  ? null
                  : IODropdownSheetModel(
                      name: controller.sexDisplay.value,
                      value: controller.sexDisplay.value,
                    ),
            ),
          pickItems: [
            IODropdownSheetModel(
              name: 'Эрэгтэй',
              value: 'Эрэгтэй',
            ),
            IODropdownSheetModel(
              name: 'Эмэгтэй',
              value: 'Эмэгтэй',
            ),
          ],
          onSelect: (IODropdownSheetModel<String> selectedItem) {
            controller.updateSexFromDisplay(selectedItem.value);
          },
        ),
      ),
    );
  }
}
