import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuPro/library/components/main/io_appbar.dart';
import 'package:nuPro/library/components/main/io_loading.dart';
import 'package:nuPro/library/components/widgets/call_status_widget.dart';
import 'package:nuPro/library/components/widgets/completion_code_display_widget.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/utils/call_status_enum.dart';
import 'package:nuPro/screens/customer_call_map/customer_call_map_controller.dart';
import 'package:nuPro/screens/customer_call_map/widget/customer_call_map_info.dart';

class CustomerCallMapScreen extends GetView<CustomerCallMapController> {
  const CustomerCallMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: IOAppBar(
          titleText: "Газрын зураг",
          leading: controller.callDetailInfoModel.status ==
                  CallStatus.completed.value
              ? null // default back button
              : Container(), // hide back button
        ),
        body: SafeArea(
          child: controller.isLoading.value
              ? const IOLoading()
              : Column(
                  children: [
                    CallStatusWidget(
                      currentStatus: controller.callDetailInfoModel.status,
                      callId: controller.callDetailInfoModel.id,
                      onStatusChanged: () {
                        controller.refreshCallDetails();
                      },
                    ),
                    if (controller.callDetailInfoModel.status ==
                        CallStatus.accepted.value)
                      CompletionCodeDisplayWidget(
                        callId: controller.callDetailInfoModel.id,
                      ),
                    // Зайг харуулах хэсэг
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 4),
                      child: Obx(() => Text(
                            controller.distanceKm.value > 0
                                ? 'Сувилагчтай зай: ${controller.distanceKm.value.toStringAsFixed(2)} км'
                                : '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          )),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: controller.defaultLocation,
                              zoom: 14,
                            ),
                            mapType: MapType.normal,
                            markers: controller.markers.toSet(),
                            polylines: controller.polylines.toSet(),
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
                    ),
                    if (controller.callDetailInfoModel.status ==
                            CallStatus.completed.value &&
                        controller.callDetailInfoModel.canRate)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: IOColors.brand500,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.star_rate),
                            label: const Text(
                              'Үйлчилгээг үнэлэх',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            onPressed: () {
                              Get.toNamed('/customer_call_map_rating',
                                  arguments: {
                                    'callId': controller.callDetailInfoModel.id
                                  });
                            },
                          ),
                        ),
                      ),
                  ],
                ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 16,
            left: 16,
          ),
          child: FloatingActionButton.extended(
            onPressed: () {
              Get.bottomSheet(
                NurseInfoBottomSheet(
                    callDetailInfoModel: controller.callDetailInfoModel),
              );
            },
            backgroundColor: IOColors.brand500,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.info_outline),
            label: const Text(
              'Сувилагчийн мэдээлэл',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
