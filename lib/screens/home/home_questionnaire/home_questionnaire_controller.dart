import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:nuPro/library/components/dropdown/io_dropdown_model.dart';
import 'package:nuPro/library/components/main/io_card_border.dart';
import 'package:nuPro/library/components/main/io_toast.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/routes/home_route.dart';
import 'package:nuPro/library/theme/io_colors.dart';
import 'package:nuPro/library/theme/io_styles.dart';
import 'package:nuPro/library/utils/validator.dart';
import 'package:nuPro/screens/home/home_questionnaire/model/health_info_model.dart';
import 'package:nuPro/screens/home/home_questionnaire/model/service_type_model.dart';
import 'package:nuPro/screens/home/home_questionnaire/sheets/calendar_sheet.dart';
import 'package:signature/signature.dart';

class HomeQuestionnaireController extends IOController {
  final nurseInfo = <HealthInfoModel>[].obs;
  final serviceTypes = <ServiceTypeModel>[].obs;
  final isLoadingServiceTypes = false.obs;
  final ImagePicker _imagePicker = ImagePicker();

  final currentStep = 0.obs;
  late PageController pageController;
  // final firstName = IOTextfieldModel(
  //   label: HelperManager.profileInfo.firstName,
  //   validators: [ValidatorType.notEmpty],
  // );

  // final lastName = IOTextfieldModel(
  //   label: HelperManager.profileInfo.lastName,
  //   validators: [ValidatorType.notEmpty],
  // );

  // final address = IOTextfieldModel(
  //   label: 'Гэрийн хаяг',
  //   validators: [ValidatorType.notEmpty],
  // );

  // final phone = IOTextfieldModel(
  //   label: HelperManager.profileInfo.phoneNumber,
  //   validators: [ValidatorType.phone],
  //   keyboardType: TextInputType.phone,
  // );

  // final dateBirthField = IOTextfieldModel(
  //   label: 'Төрсөн өдрөө оруулна уу',
  //   readOnly: true,
  // ).obs;

  var questionField = IOTextfieldModel(
    label: 'Сувилагч мэдэх ёстой нэмэлт мэдээлэл',
    validators: [ValidatorType.notEmpty],
  );

  final sigController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: null,
  );

  final expire = IODropdownModel<DateTime>(
    label: 'Хугацаа',
    sheetTitle: 'Хугацаа',
    icon: 'calendar.svg',
  );

  final nextButton = IOButtonModel(
    label: 'Үргэлжлүүлэх',
    type: IOButtonType.primary,
    size: IOButtonSize.large,
    isEnabled: false,
  ).obs;

  Future onTapExpire() async {
    final minDate = DateTime.now().add(
      const Duration(days: 1),
    );
    final maxDate = minDate.add(const Duration(days: 1000));
    final initDate = minDate;

    final result = await CalendarSheet(
      initial: initDate,
      start: minDate,
      end: maxDate,
    ).show();

    Get.focusScope?.unfocus();
    if (result == null) return;
  }

  // void onTapDateBirthField() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     DateBirthPicker(dateBirth: dateBirthField.value.controller.text)
  //         .show()
  //         .then((selectedDate) {
  //       if (selectedDate != null) {
  //         dateBirthField.value.controller.text = selectedDate;
  //       }
  //     });
  //   });
  // }

  final signature = ''.obs;
  final medicalCertificate = ''.obs;

  // Асуултууд
  final q1Yes = false.obs;
  final q1No = false.obs;

  final q2Yes = false.obs;
  final q2No = false.obs;
  final q2Details = IOTextfieldModel(label: 'Тийм бол ямар?');

  final q3Yes = false.obs;
  final q3No = false.obs;
  final q3Details = IOTextfieldModel(label: 'Тийм бол ямар?');

  final q4Yes = false.obs;
  final q4No = false.obs;

  final q5Yes = false.obs;
  final q5No = false.obs;

  final q6Yes = false.obs;
  final q6No = false.obs;

  final q7Yes = false.obs;
  final q7No = false.obs;

  final preferredServiceType = ''.obs;
  final dateYear = IOTextfieldModel(label: 'Он');
  final dateMonth = IOTextfieldModel(label: 'Сар');
  final dateDay = IOTextfieldModel(label: 'Өдөр');

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();

    questionField.controller.addListener(validateForm);
    everAll([signature, preferredServiceType], (_) => validateForm());

    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchServiceTypes();
    await loadExistingHealthInfo();
  }

  @override
  void onClose() {
    pageController.dispose();
    sigController.dispose(); // signature controller ч бас устгах хэрэгтэй
    super.onClose();
  }

  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void validateForm() {
    final isValid = questionField.controller.text.isNotEmpty &&
        signature.value.isNotEmpty &&
        preferredServiceType.value.isNotEmpty;

    nextButton.update((val) {
      val?.isEnabled = isValid;
    });
  }

  bool isStep1Valid() {
    return preferredServiceType.value.isNotEmpty;
  }

  bool isStep2Valid() {
    return (q1Yes.value || q1No.value) &&
        (q2Yes.value || q2No.value) &&
        (q3Yes.value || q3No.value) &&
        (q4Yes.value || q4No.value) &&
        (q5Yes.value || q5No.value) &&
        (q6Yes.value || q6No.value) &&
        (q7Yes.value || q7No.value);
  }

  bool isStep3Valid() {
    return signature.value.isNotEmpty;
  }

  String? getStep1ValidationMessage() {
    if (preferredServiceType.value.isEmpty) {
      return 'Эмчилгээний төрлийг сонгоно уу';
    }
    return null;
  }

  String? getStep2ValidationMessage() {
    if (!(q1Yes.value || q1No.value)) {
      return 'Биеийн байдлын асуултад хариулна уу';
    }
    if (!(q2Yes.value || q2No.value)) {
      return 'Эм тарианы асуултад хариулна уу';
    }
    if (!(q3Yes.value || q3No.value)) {
      return 'Харшилтын асуултад хариулна уу';
    }
    if (!(q4Yes.value || q4No.value)) {
      return 'Чихрийн шижний асуултад хариулна уу';
    }
    if (!(q5Yes.value || q5No.value)) {
      return 'Даралтын асуултад хариулна уу';
    }
    if (!(q6Yes.value || q6No.value)) {
      return 'Татаж унах асуултад хариулна уу';
    }
    if (!(q7Yes.value || q7No.value)) {
      return 'Зүрхний эмгэгийн асуултад хариулна уу';
    }
    return null;
  }

  String? getStep3ValidationMessage() {
    if (signature.value.isEmpty) {
      return 'Гарын үсэг зураарай';
    }
    return null;
  }

  void validateAndProceedToNextStep() {
    String? errorMessage;

    switch (currentStep.value) {
      case 0:
        if (!isStep1Valid()) {
          errorMessage = getStep1ValidationMessage();
        }
        break;
      case 1:
        if (!isStep2Valid()) {
          errorMessage = getStep2ValidationMessage();
        }
        break;
      case 2:
        if (!isStep3Valid()) {
          errorMessage = getStep3ValidationMessage();
        }
        break;
    }

    if (errorMessage != null) {
      showError(text: errorMessage);
    } else {
      nextStep();
    }
  }

  Future<void> clearSignature() async {
    sigController.clear();
  }

  Future<void> undoSignature() async {
    if (sigController.points.isNotEmpty) {
      sigController.points.removeLast();
    }
  }

  Future<void> saveSignatureToBase64() async {
    if (sigController.isEmpty) {
      IOToast(text: 'Гарын үсэг байхгүй байна.');
      return;
    }
    final bytes = await sigController.toPngBytes();
    if (bytes == null || bytes.isEmpty) {
      IOToast(text: 'Гарын үсэг байхгүй байна.');
      return;
    }

    final b64 = base64Encode(bytes);
    signature.value = 'data:image/png;base64,$b64';
    IOToast(text: 'Гарын үсэг хадгалагдлаа.');
  }

  // @override
  // void onClose() {
  //   sigController.dispose();
  //   super.onClose();
  // }

  /// 📍 Байршил авах тусгай функц
  Future<Position?> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      IOToast(text: 'Location service унтраалттай байна.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      // Re-check permission after requesting
      if (permission == LocationPermission.denied) {
        IOToast(text: 'Location permission татгалзсан.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      IOToast(text: 'Location permission бүрмөсөн татгалзсан.');
      return null;
    }

    // If permission is granted, try to get location
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } catch (e) {
        IOToast(text: 'Байршил авахад алдаа гарлаа: $e');
        return null;
      }
    }

    // Fallback: permission is not granted
    IOToast(text: 'Байршил авах эрх олгогдоогүй байна.');
    return null;
  }

  Future<void> fetchServiceTypes() async {
    try {
      isLoadingServiceTypes.value = true;
      final response = await CallApi().getServiceTypes();

      if (response.isSuccess) {
        final List<dynamic> data = response.data.listValue;
        serviceTypes.value = data
            .map((json) => ServiceTypeModel.fromJson(json))
            .where((serviceType) => serviceType.isActive)
            .toList();
      } else {
        showError(text: response.message.toString());
      }
    } catch (e) {
      showError(text: 'Үйлчилгээний төрлүүдийг татахад алдаа гарлаа');
    } finally {
      isLoadingServiceTypes.value = false;
    }
  }

  Future<void> loadExistingHealthInfo() async {
    final response = await NurseApi().getNurseHealthInfo();

    if (response.isSuccess) {
      final healthData = HealthInfoModel.fromJson(response.data);
      _populateFormWithExistingData(healthData);
    }
  }

  void _populateFormWithExistingData(HealthInfoModel healthData) {
    if (healthData.id == null) return;

    if (healthData.isHealthy != null) {
      q1Yes.value = healthData.isHealthy == true;
      q1No.value = healthData.isHealthy == false;
    }

    if (healthData.hasRegularMedication != null) {
      q2Yes.value = healthData.hasRegularMedication == true;
      q2No.value = healthData.hasRegularMedication == false;
      if (healthData.regularMedicationDetails != null &&
          healthData.regularMedicationDetails!.isNotEmpty) {
        q2Details.controller.text = healthData.regularMedicationDetails!;
      }
    }

    if (healthData.hasAllergies != null) {
      q3Yes.value = healthData.hasAllergies == true;
      q3No.value = healthData.hasAllergies == false;
      if (healthData.allergyDetails != null &&
          healthData.allergyDetails!.isNotEmpty) {
        q3Details.controller.text = healthData.allergyDetails!;
      }
    }

    if (healthData.hasDiabetes != null) {
      q4Yes.value = healthData.hasDiabetes == true;
      q4No.value = healthData.hasDiabetes == false;
    }

    if (healthData.hasHypertension != null) {
      q5Yes.value = healthData.hasHypertension == true;
      q5No.value = healthData.hasHypertension == false;
    }

    if (healthData.hasEpilepsy != null) {
      q6Yes.value = healthData.hasEpilepsy == true;
      q6No.value = healthData.hasEpilepsy == false;
    }

    if (healthData.hasHeartDisease != null) {
      q7Yes.value = healthData.hasHeartDisease == true;
      q7No.value = healthData.hasHeartDisease == false;
    }

    if (healthData.preferredServiceType != null &&
        healthData.preferredServiceType!.isNotEmpty) {
      final preferredServiceTypeId =
          int.tryParse(healthData.preferredServiceType!);
      if (preferredServiceTypeId != null) {
        final matchingServiceType = serviceTypes.firstWhereOrNull(
          (serviceType) => serviceType.id == preferredServiceTypeId,
        );
        if (matchingServiceType != null) {
          preferredServiceType.value = matchingServiceType.name;
        }
      }
    }

    if (healthData.additionalNotes != null &&
        healthData.additionalNotes!.isNotEmpty) {
      questionField.controller.text = healthData.additionalNotes!;
    }

    if (healthData.signature != null && healthData.signature!.isNotEmpty) {
      _loadSignatureFromUrl(healthData.signature!);
    }

    if (healthData.medicalCertificate != null &&
        healthData.medicalCertificate!.isNotEmpty) {
      _loadMedicalCertificateFromUrl(healthData.medicalCertificate!);
    }
  }

  Future<void> _loadSignatureFromUrl(String signatureUrl) async {
    final response = await http.get(Uri.parse(signatureUrl));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final base64Str = base64Encode(bytes);
      signature.value = 'data:image/png;base64,$base64Str';
    }
  }

  Future<void> _loadMedicalCertificateFromUrl(String certificateUrl) async {
    final response = await http.get(Uri.parse(certificateUrl));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final base64Str = base64Encode(bytes);
      medicalCertificate.value = 'data:image/jpeg;base64,$base64Str';
    }
  }

  void openSignaturePad() {
    Get.bottomSheet(
      SafeArea(
        child: IOCardBorderWidget(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Гарын үсэг зурна уу',
                  style:
                      IOStyles.body1Bold.copyWith(color: IOColors.textPrimary)),
              const SizedBox(height: 12),
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: IOColors.textPrimary),
                ),
                child: Signature(
                  controller: sigController,
                  backgroundColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: IOButtonWidget(
                      model: IOButtonModel(
                          size: IOButtonSize.small,
                          label: 'Цэвэрлэх',
                          type: IOButtonType.oulineGray),
                      onPressed: clearSignature,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: IOButtonWidget(
                      model: IOButtonModel(
                          size: IOButtonSize.small,
                          label: 'Хадгалах',
                          type: IOButtonType.primary),
                      onPressed: () async {
                        await saveSignatureToBase64();
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  int? getSelectedServiceTypeId() {
    final selectedServiceType = serviceTypes.firstWhereOrNull(
      (serviceType) => serviceType.name == preferredServiceType.value,
    );
    return selectedServiceType?.id;
  }

  Future<void> pickMedicalCertificate() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 1000,
        maxWidth: 1000,
      );

      if (pickedFile == null) return;

      final bytes = await pickedFile.readAsBytes();
      final base64Str = base64Encode(bytes);
      medicalCertificate.value = 'data:image/jpeg;base64,$base64Str';

      IOToast(text: 'Эмчийн бичиг амжилттай сонгогдлоо').show();
    } catch (e) {
      showError(text: 'Эмчийн бичиг сонгоход алдаа гарлаа');
    }
  }

  void removeMedicalCertificate() {
    medicalCertificate.value = '';
    IOToast(text: 'Эмчийн бичиг устгагдлаа').show();
  }

  void onTapSubmitHealthInfo() async {
    Get.focusScope?.unfocus();

    nextButton.update((val) => val?.isLoading = true);

    // Серверээс өмнөх мэдээллийг шалгах
    final existingInfo = await NurseApi().getNurseHealthInfo();
    final isUpdate = existingInfo.isSuccess;

    final serviceTypeId = getSelectedServiceTypeId();
    if (serviceTypeId == null) {
      nextButton.update((val) => val?.isLoading = false);
      showError(text: 'Эмчилгээний төрлийг сонгоно уу');
      return;
    }

    final position = await _determinePosition();

    IOResponse response;

    if (isUpdate) {
      response = await CallApi().updateHealthInfo(
        isHealthy: q1Yes.value,
        hasRegularMedication: q2Yes.value,
        regularMedicationDetails:
            q2Yes.value ? q2Details.controller.text : null,
        hasAllergies: q3Yes.value,
        allergyDetails: q3Yes.value ? q3Details.controller.text : null,
        hasDiabetes: q4Yes.value,
        hasHypertension: q5Yes.value,
        hasEpilepsy: q6Yes.value,
        hasHeartDisease: q7Yes.value,
        latitude: position?.latitude,
        longitude: position?.longitude,
        preferredServiceType: serviceTypeId,
        signature: signature.value.isNotEmpty ? signature.value : 'signature',
        additionalNotes: questionField.controller.text,
        medicalCertificate: medicalCertificate.value.isNotEmpty
            ? medicalCertificate.value
            : null,
      );
    } else {
      response = await CallApi().createHealthInfo(
        isHealthy: q1Yes.value,
        hasRegularMedication: q2Yes.value,
        regularMedicationDetails:
            q2Yes.value ? q2Details.controller.text : null,
        hasAllergies: q3Yes.value,
        allergyDetails: q3Yes.value ? q3Details.controller.text : null,
        hasDiabetes: q4Yes.value,
        hasHypertension: q5Yes.value,
        hasEpilepsy: q6Yes.value,
        hasHeartDisease: q7Yes.value,
        latitude: position?.latitude,
        longitude: position?.longitude,
        preferredServiceType: serviceTypeId,
        signature: signature.value.isNotEmpty ? signature.value : 'signature',
        additionalNotes: questionField.controller.text,
        medicalCertificate: medicalCertificate.value.isNotEmpty
            ? medicalCertificate.value
            : null,
      );
    }

    nextButton.update((val) => val?.isLoading = false);

    if (response.isSuccess) {
      IOToast(
              text: isUpdate
                  ? 'Мэдээлэл амжилттай шинэчилэгдлээ'
                  : 'Амжилттай мэдээлэл илгээгдлээ')
          .show();
      final healthInfo = HealthInfoModel.fromJson(response.data['health_info']);
      final nearestNurses = response.data['nearest_nurses'].listValue
          .map((e) => NearestNursesModel.fromJson(e))
          .toList();

      await HomeRoute.toHomeCallGoogleMap(
          healthInfo: healthInfo, nearestNurses: nearestNurses);
    } else {
      showError(text: response.message.toString());
    }
  }
}
