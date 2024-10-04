import 'package:allkar_loekar_apyarkar/constant/constant.dart';
import 'package:allkar_loekar_apyarkar/dataService/http_service.dart';
import 'package:allkar_loekar_apyarkar/error/error.dart';
import 'package:allkar_loekar_apyarkar/model/myanmar_model.dart';
import 'package:get/get.dart';

class MyanmarController extends GetxController {
  DataService dataService = Get.find<DataService>();
  RxBool isLoaidng = false.obs;
  RxString errorMessage = "".obs;
  var myanmarData = <MyanmarModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    myanmarGetData();
  }

  Future<void> myanmarGetData() async {
    isLoaidng.value = true;
    dataService.getApi('${Constant.appUrl}myanmar/main/Popular').then((value) {
      if (value is Success) {
        final jsonData = value.object as String;
        var data = myanmarModelFromJson(jsonData);
        myanmarData.value = data;
      }
      if (value is Failture) {
        final error = value.object as String;
        errorMessage.value = error;
      }
    });
    isLoaidng.value = false;
  }
}
