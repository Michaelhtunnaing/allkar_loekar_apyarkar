import 'package:allkar_loekar_apyarkar/constant/constant.dart';
import 'package:allkar_loekar_apyarkar/dataService/http_service.dart';
import 'package:allkar_loekar_apyarkar/error/error.dart';
import 'package:allkar_loekar_apyarkar/model/japanese_model.dart';
import 'package:get/get.dart';

class JapaneseController extends GetxController {
  DataService dataService = Get.find<DataService>();
  RxBool isLoaidng = false.obs;
  RxString errorMessage = "".obs;
  var japaneseData = <JapaneseModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    japaneseGetData();
  }

  Future<void> japaneseGetData() async {
    isLoaidng.value = true;
    dataService.getApi('${Constant.appUrl}Japanese/main/Popular').then((value) {
      if (value is Success) {
        final jsonData = value.object as String;
        var data = japaneseModelFromJson(jsonData);
        japaneseData.value = data;
      }
      if (value is Failture) {
        final error = value.object as String;
        errorMessage.value = error;
      }
    });
    isLoaidng.value = false;
  }
}
