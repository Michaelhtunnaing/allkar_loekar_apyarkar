import 'package:allkar_loekar_apyarkar/controller/categories_data_controller.dart';
import 'package:allkar_loekar_apyarkar/controller/home_controller.dart';
import 'package:get/get.dart';
import '../controller/chinese_controller.dart';
import '../controller/japanese_controller.dart';
import '../controller/myanmar_controller.dart';
import '../dataService/http_service.dart';

class DataBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DataService());
    Get.put(HomeDataController());
   // Get.put(CategoriesController());
     Get.put(ChineseController());
      Get.put(MyanmarController());
         Get.put(JapaneseController());
         Get.put(MovieCategories());
    
  }
}
