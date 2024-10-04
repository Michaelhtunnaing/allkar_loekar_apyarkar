import 'package:allkar_loekar_apyarkar/constant/constant.dart';
import 'package:allkar_loekar_apyarkar/dataService/http_service.dart';
import 'package:allkar_loekar_apyarkar/error/error.dart';
import 'package:allkar_loekar_apyarkar/model/chinese_model.dart';
import 'package:get/get.dart';

class ChineseController extends GetxController {
  DataService dataService = Get.find<DataService>();
  RxBool isLoaidng = false.obs;
  RxString errorMessage = "".obs;
  var chineseData = <ChineseModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    chineseGetData();
  }

  Future<void> chineseGetData() async {
    isLoaidng.value = true;
    dataService.getApi('${Constant.appUrl}Chinese/main/Popular').then((value) {
      if (value is Success) {
        final jsonData = value.object as String;
        var data = chineseModelFromJson(jsonData);
        chineseData.value = data;
      }
      if (value is Failture) {
        final error = value.object as String;
        errorMessage.value = error;
      }
    });
    isLoaidng.value = false;
  }
}
