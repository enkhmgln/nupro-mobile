import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nuPro/library/client/api/info_api.dart';
import 'package:nuPro/library/components/button/io_button_model.dart';
import 'package:nuPro/library/components/main/io_controller.dart';
import 'package:nuPro/library/client/api/customer_api.dart';
import 'package:nuPro/library/components/main/io_toast.dart';
import 'package:nuPro/library/shared/client_manager.dart';
import 'package:nuPro/screens/menu/menu_info/models/city_model.dart';
import 'package:nuPro/screens/menu/menu_info/models/district_model.dart';
import 'package:nuPro/screens/menu/menu_info/models/sub_district_model.dart';

class MenuInfoController extends IOController {
  final CustomerApi api = CustomerApi();
  final InfoApi infoApi = InfoApi();
  final ImagePicker _picker = ImagePicker();
  final cities = <CityData>[].obs;
  final districts = <Districts>[].obs;
  final subDistricts = <SubDistricts>[].obs;

  final selectedCityId = RxnInt();
  final selectedDistrictId = RxnInt();
  final selectedSubDistrictId = RxnInt();

  var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var sex = ''.obs;
  var dateOfBirth = ''.obs;
  var sexDisplay = ''.obs;

  final updateButton = IOButtonModel(
    label: 'Шинэчлэх',
    type: IOButtonType.primary,
    size: IOButtonSize.medium,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    firstName.value = proInfo.value.firstName;
    lastName.value = proInfo.value.lastName;
    email.value = proInfo.value.email;
    phoneNumber.value = proInfo.value.phoneNumber;
    sex.value = proInfo.value.sex;
    dateOfBirth.value = proInfo.value.dateOfBirth;
    _updateSexDisplay();
    fetchCities();
  }

  Future<void> fetchCities() async {
    final response = await CustomerApi().getCities();
    if (response.isSuccess) {
      final data = response.data.listValue;
      cities.value = data.map((e) => CityData.fromJson(e)).toList();

      print('Fetched ${cities.length} cities');
    }
  }

  Future<void> fetchDistricts(int cityId) async {
    final response = await CustomerApi().getDistricts(cityId: cityId);
    if (response.isSuccess) {
      final districtsJson = response.data['districts'].listValue;
      districts.value =
          districtsJson.map((e) => Districts.fromJson(e)).toList();
      print('Fetched ${districts.length} districts');
    }
  }

  Future<void> fetchSubDistricts(int districtId) async {
    final response =
        await CustomerApi().getSubDistricts(districtId: districtId);
    if (response.isSuccess) {
      subDistricts.value = (response.data['sub_districts'].listValue)
          .map((e) => SubDistricts.fromJson(e))
          .toList();
    }
  }

  void onCitySelected(int cityId) {
    selectedCityId.value = cityId;
    fetchDistricts(cityId);
    subDistricts.clear();
    selectedDistrictId.value = null;
    selectedSubDistrictId.value = null;
  }

  void onDistrictSelected(int districtId) {
    selectedDistrictId.value = districtId;
    fetchSubDistricts(districtId);
    subDistricts.clear();
    selectedSubDistrictId.value = null;
  }

  void onSubDistrictSelected(int subDistrictId) {
    selectedSubDistrictId.value = subDistrictId;
  }

  void _updateSexDisplay() {
    switch (sex.value.toUpperCase()) {
      case 'M':
        sexDisplay.value = 'Эрэгтэй';
        break;
      case 'F':
        sexDisplay.value = 'Эмэгтэй';
        break;
      default:
        sexDisplay.value = 'Тодорхойгүй';
        break;
    }
  }

  void updateSexFromDisplay(String displayValue) {
    switch (displayValue) {
      case 'Эрэгтэй':
        sex.value = 'M';
        break;
      case 'Эмэгтэй':
        sex.value = 'F';
        break;
      default:
        sex.value = '';
        break;
    }
    _updateSexDisplay();
  }

  Future<void> onTapChangeAvatar() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      final bytes = await pickedFile.readAsBytes();
      final base64Str = base64Encode(bytes);

      final response = await infoApi.profileImageChange(base64Str);

      if (response.isSuccess) {
        proInfo.update((val) {
          if (val != null) val.profilePicture = pickedFile.path;
        });
        ClientManager.getUserInfo();
        IOToast(
          text: response.message,
          time: 2,
          gravity: ToastGravity.TOP,
        ).show();
      } else {
        showError(text: response.message);
      }
    } catch (e) {
      showError(text: "Зураг шинэчлэхэд алдаа гарлаа");
      print(e);
    }
  }

  Future<void> onTapUpdate() async {
    if (selectedSubDistrictId.value == null) {
      showError(text: "Хороог сонгоно уу");
      return;
    }

    isLoading.value = true;
    updateButton.update((val) {
      val?.isLoading = true;
    });

    final response = await api.profileChange(
      firstName: firstName.value,
      lastName: lastName.value,
      email: email.value,
      phoneNumber: phoneNumber.value,
      sex: sex.value,
      dateOfBirth: dateOfBirth.value,
      subDistrict: selectedSubDistrictId.value!,
    );

    isLoading.value = false;
    updateButton.update((val) {
      val?.isLoading = false;
    });

    if (response.isSuccess) {
      IOToast(
        text: response.message,
        time: 2,
        gravity: ToastGravity.TOP,
      ).show();
      ClientManager.getUserInfo();
      Get.back();
    } else {
      showError(text: response.message);
    }
  }
}
