import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nuPro/library/components/main/io_card_border.dart';
import 'package:nuPro/library/theme/io_colors.dart';

class ImageUploadWidget extends StatefulWidget {
  final ValueChanged<XFile?> onImageAdded;
  final String label;

  const ImageUploadWidget({
    super.key,
    required this.onImageAdded,
    required this.label,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUploadWidget> {
  XFile? image;

  Future<void> getCam() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 1000,
        maxWidth: 1000,
      );
      if (pickedImage != null) addImage(pickedImage);
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
    }
  }

  Future<void> getGall() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 1000,
        maxWidth: 1000,
      );
      if (pickedImage != null) addImage(pickedImage);
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
    }
  }

  void addImage(XFile newImage) {
    image = newImage; // өмнөх зургийг солих
    widget.onImageAdded(image);
    setState(() {});
  }

  void deleteImage() {
    image = null;
    widget.onImageAdded(image);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: IOColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        image != null
            ? Stack(
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: IOColors.brand700,
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: FileImage(File(image!.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: deleteImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: IOColors.brand700,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: IOColors.backgroundPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : GestureDetector(
                onTap: () => showPicker(context),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        IOColors.backgroundSecondary,
                        IOColors.strokePrimary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: IOColors.backgroundQuarternary,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: IOColors.brand700.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: IOColors.brand700.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 28,
                          color: IOColors.brand700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Зураг оруулах',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: IOColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  void showPicker(BuildContext context) {
    Get.bottomSheet(
      IOCardBorderWidget(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                getCam();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                getGall();
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}
