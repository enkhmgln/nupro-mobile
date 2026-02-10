import 'package:get/get.dart';
import 'package:nuPro/library/library.dart';
import 'package:nuPro/library/routes/auth_route.dart';
import 'package:nuPro/screens/sign_up/sign_up_info/model/user_type_model.dart';
import 'package:nuPro/screens/sign_up/sign_up_phone/model/sign_up_model.dart';

class SignUpUserTypeController extends IOController {
  final SignUpModel model;
  SignUpUserTypeController({
    required this.model,
  });

  final nextButton = IOButtonModel(
    label: 'Үргэлжлүүлэх',
    type: IOButtonType.primary,
    size: IOButtonSize.medium,
    isEnabled: true,
  ).obs;

  final userTypes = <UserTypeModel?>[
    null,
    UserTypeModel(label: "Сувилагч", value: "nurse"),
    UserTypeModel(label: "Хэрэглэгч", value: "customer"),
  ];

  final selectedUserTypeIndex = 0.obs;

  UserTypeModel? get selectedUserType => userTypes[selectedUserTypeIndex.value];

  void onChangeUserType(UserTypeModel? val) {
    if (val == null) {
      selectedUserTypeIndex.value = 0;
      return;
    }
    final index = userTypes.indexWhere((e) => e?.value == val.value);
    if (index != -1) {
      selectedUserTypeIndex.value = index;
    }
  }

  void onTapNext() async {
    model.userType = selectedUserType?.value ?? '';
    nextButton.update((val) => val?.isLoading = true);

    if (selectedUserType == null) {
      showError(text: 'User type сонгоно уу');
      nextButton.update((val) => val?.isLoading = false);
      return;
    }

    nextButton.update((val) => val?.isLoading = false);

    await AuthRoute.toSignUpInfo(model);
  }
}
