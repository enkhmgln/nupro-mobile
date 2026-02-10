import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuPro/library/components/main/io_appbar.dart';
import 'package:nuPro/library/components/main/io_loading.dart';
import 'package:nuPro/library/components/widgets/call_status_widget.dart';
import 'package:nuPro/library/components/widgets/completion_code_widget.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/utils/call_status_manager.dart';
import 'package:nuPro/nurse_screen/nurse_call_google_map/nurse_call_google_map_controller.dart';

class NurseCallGoogleMapScreen extends GetView<NurseCallGoogleMapController> {
  const NurseCallGoogleMapScreen({super.key});

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
              : Column(
                  children: [
                    CallStatusWidget(
                      currentStatus: controller.callDetailInfoModel.status,
                      callId: controller.callDetailInfoModel.id,
                      onStatusChanged: () {
                        controller.refreshCallDetails();
                      },
                    ),
                    if (CallStatusManager.canCompleteCall(
                        controller.callDetailInfoModel.status))
                      CompletionCodeWidget(
                        callId: controller.callDetailInfoModel.id,
                        onCallCompleted: () {
                          controller.refreshCallDetails();
                        },
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
                            onTap: (LatLng position) {
                              controller.showInfo(
                                  customer: controller.callDetailInfoModel);
                            },
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
              controller.showInfo(customer: controller.callDetailInfoModel);
            },
            backgroundColor: IOColors.brand500,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.info_outline),
            label: const Text(
              'Хэрэглэгчийн мэдээлэл',
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
