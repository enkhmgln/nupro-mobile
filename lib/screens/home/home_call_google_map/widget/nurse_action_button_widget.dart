import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuPro/library/components/button/io_button_model.dart';
import 'package:nuPro/library/components/button/io_button_widget.dart';
import 'package:nuPro/screens/home/home_call_google_map/home_call_google_map_controller.dart';
import 'package:nuPro/screens/home/home_questionnaire/model/health_info_model.dart';
import 'package:maps_launcher/maps_launcher.dart';

class NurseActionButtonWidget extends GetView<HomeCallGoogleMapController> {
  final NearestNursesModel nurse;
  final VoidCallback? onTapCall;

  const NurseActionButtonWidget({
    super.key,
    required this.nurse,
    this.onTapCall,
  });

  @override
  Widget build(BuildContext context) {
    final completeLoading = RxBool(false);
    final cancelLoading = RxBool(false);

    return Obx(() {
      final isCalled = controller.calledNurseId.value == nurse.id;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Дуудлага өгөх
          if (!isCalled)
            IOButtonWidget(
              onPressed: controller.loadingNurseId.value == nurse.id
                  ? null
                  : onTapCall,
              model: IOButtonModel(
                label: "Дуудлага өгөх",
                type: IOButtonType.primary,
                size: IOButtonSize.small,
                isLoading: controller.loadingNurseId.value == nurse.id,
              ),
            ),

          // Дуудлага дуусгах болон цуцлах
          if (isCalled) ...[
            IOButtonWidget(
              onPressed: completeLoading.value
                  ? null
                  : () async {
                      completeLoading.value = true;
                      await controller
                          .completeCall(controller.activeCallId.value!);

                      completeLoading.value = false;
                    },
              model: IOButtonModel(
                label: "Дуудлага дуусгах",
                type: IOButtonType.primary,
                size: IOButtonSize.small,
                isLoading: completeLoading.value,
              ),
            ),
            const SizedBox(height: 8),
            IOButtonWidget(
              onPressed: cancelLoading.value
                  ? null
                  : () async {
                      final TextEditingController reasonController =
                          TextEditingController();
                      final result = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) {
                          return SingleChildScrollView(
                            reverse: true,
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(ctx).viewInsets.bottom,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(28)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 24,
                                    offset: Offset(0, -8),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Дуудлага цуцлах шалтгаан',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.close,
                                            size: 28, color: Colors.grey[600]),
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextField(
                                      controller: reasonController,
                                      maxLines: 4,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black87),
                                      decoration: const InputDecoration(
                                        hintText: 'Шалтгаанаа бичнэ үү...',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 14),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                    ),
                                    onPressed: () {
                                      final reason =
                                          reasonController.text.trim();
                                      if (reason.isNotEmpty) {
                                        Navigator.of(ctx).pop(reason);
                                      }
                                    },
                                    child: const Text(
                                      'Цуцлах',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      if (result != null && result.isNotEmpty) {
                        cancelLoading.value = true;
                        await controller.cancelCall(result);
                        cancelLoading.value = false;
                        // Rating screen removed as requested
                      }
                    },
              model: IOButtonModel(
                label: "Дуудлага цуцлах",
                type: IOButtonType.secondary,
                size: IOButtonSize.small,
                isLoading: cancelLoading.value,
              ),
            ),
          ],

          const SizedBox(height: 12),
          IOButtonWidget(
            onPressed: () {
              MapsLauncher.launchCoordinates(
                nurse.latitude,
                nurse.longitude,
                nurse.fullName ?? "Сувилагч",
              );
            },
            model: IOButtonModel(
              label: "Чиглэл харах",
              type: IOButtonType.secondary,
              size: IOButtonSize.small,
            ),
          ),
        ],
      );
    });
  }
}
