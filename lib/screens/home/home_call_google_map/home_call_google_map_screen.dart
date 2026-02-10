import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuPro/library/components/main/io_loading.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/screens/home/home_call_google_map/home_call_google_map_controller.dart';
import 'package:nuPro/screens/sign_up/sign_up_info/model/specialization_model.dart';

class HomeCallGoogleMapScreen extends GetView<HomeCallGoogleMapController> {
  const HomeCallGoogleMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: IOAppBar(
          titleText: "Газрын зураг",
        ),
        body: SafeArea(
          child: controller.isLoading.value
              ? const IOLoading()
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: IOColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: IOColors.brand500, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: IOColors.brand500.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<SpecializationModel>(
                            isExpanded: true,
                            value: controller.selectedSpecialization.value,
                            hint: controller.isLoading.value
                                ? const Text('Мэргэжил ачааллаж байна...',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: IOColors.textPrimary))
                                : controller.availableSpecializations.isEmpty
                                    ? const Text('Мэргэжил олдсонгүй',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: IOColors.textPrimary))
                                    : const Text('Мэргэжлээр шүүх',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: IOColors.brand500)),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                                color: IOColors.brand500, size: 28),
                            dropdownColor: IOColors.backgroundSecondary,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: IOColors.textPrimary),
                            items: controller.availableSpecializations.isEmpty
                                ? []
                                : controller.availableSpecializations
                                    .map((spec) =>
                                        DropdownMenuItem<SpecializationModel>(
                                          value: spec,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              spec.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                color: IOColors.brand500,
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                            onChanged: controller
                                    .availableSpecializations.isEmpty
                                ? null
                                : (spec) {
                                    controller.selectedSpecialization.value =
                                        spec;
                                    if (spec != null) {
                                      controller.filterNursesBySpecialization(
                                          spec.id);
                                    }
                                  },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: controller.defaultLocation,
                              zoom: 14,
                            ),
                            mapType: MapType.normal,
                            markers: controller.markers.toSet(),
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            liteModeEnabled: false,
                            onMapCreated: (GoogleMapController mapController) {
                              if (!controller.mapController.isCompleted) {
                                controller.mapController
                                    .complete(mapController);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        floatingActionButton: controller.nearestNurses.isEmpty
            ? null
            : FloatingActionButton(
                onPressed: () => controller.showNursesList(),
                backgroundColor: IOColors.brand500,
                child: const Icon(Icons.call, color: Colors.white),
              ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
      ),
    );
  }
}
