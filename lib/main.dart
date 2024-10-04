import 'package:allkar_loekar_apyarkar/data_binding/data_binding.dart';
import 'package:allkar_loekar_apyarkar/ui/categories_ui/first_categories_ui.dart';
import 'package:allkar_loekar_apyarkar/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
 
  runApp(const MyApp());
}

/*distributionUrl=https\://services.gradle.org/distributions/gradle-7.6.3-all.zip*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
     
      debugShowCheckedModeBanner: false,
      initialRoute: '/exam',
      initialBinding: DataBinding(),
      getPages: [GetPage(name: '/exam', page: () => const Home()),
      GetPage(name: "/dd", page: ()=> const FirstCategoriesUi())],
    );
  }
}
