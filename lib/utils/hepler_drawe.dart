import 'package:allkar_loekar_apyarkar/controller/home_controller.dart';
import 'package:allkar_loekar_apyarkar/ui/example.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/categories_controller.dart';

class HelperDrewerWidget extends StatelessWidget {
  const HelperDrewerWidget(
      {super.key,
      required this.categoriesController,
      required this.homeDataController});

  final CategoriesController categoriesController;
  final HomeDataController homeDataController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 100,
          child: Column(
            children: [
              Text(
                "Welcome Our",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                "ALLKAR_KABAR",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Obx(() {
          if (categoriesController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Expanded(
              child: ListView.builder(
                itemCount: categoriesController.categoriesModel.length,
                itemBuilder: (context, index) {
                  final String title =
                      categoriesController.categoriesModel[index].title;
                  final String url =
                      categoriesController.categoriesModel[index].url;
                  return GestureDetector(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(3),
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        title,
                      ),
                    ),
                    onTap: () {
                      homeDataController.homeDataFetch(url);

                      Get.to(() => const Example());
                      print(url);
                    },
                  );
                },
              ),
            );
          }
        })
      ],
    );
  }
}
