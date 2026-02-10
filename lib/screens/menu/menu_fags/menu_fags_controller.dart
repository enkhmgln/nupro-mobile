import 'package:get/get.dart';
import 'package:nuPro/library/client/api/info_api.dart';
import 'package:nuPro/library/client/models/pagination_model.dart';
import 'package:nuPro/library/components/main/io_controller.dart';
import 'package:nuPro/screens/menu/menu_fags/models/fags_model.dart';

class MenuFagsController extends IOController {
  final faq = <FagsModel>[].obs;
  final pagination = PaginationModel();

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future getData() async {
    final response = await InfoApi().getFaq(
      page: pagination.page,
      limit: pagination.limit,
    );

    if (response.isSuccess) {
      final dataList = response.data.listValue;
      faq.value = dataList.map((e) => FagsModel.fromJson(e)).toList();
    }
  }
}
