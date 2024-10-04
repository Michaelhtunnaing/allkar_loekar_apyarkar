import 'package:allkar_loekar_apyarkar/constant/constant.dart';
import 'package:allkar_loekar_apyarkar/dataService/http_service.dart';
import 'package:allkar_loekar_apyarkar/error/error.dart';
import 'package:allkar_loekar_apyarkar/model/categories_model.dart';
import 'package:get/get.dart';

class CategoriesController extends GetxController {
  DataService dataService = Get.find<DataService>();
  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;
  var categoriesModel = <CategoriesModel>[].obs;

  @override
  void onInit() {
    super.onInit();
   // categoriesGetData();
  }

  Future<void> categoriesGetData() async {
    try {
      isLoading.value = true;
      dataService.getApi(Constant.dd).then((value) {
        if (value is Success) {
          final jsonData = value.object as String;
          var data = categoriesModelFromJson(jsonData);
          categoriesModel.value = data;
        }
        if (value is Failture) {
          final error = value.object as String;
          errorMessage.value = error;
        }
      });
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
