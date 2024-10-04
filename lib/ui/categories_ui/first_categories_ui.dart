import 'package:allkar_loekar_apyarkar/controller/second_categories_controller.dart';
import 'package:allkar_loekar_apyarkar/ui/categories_ui/second_categories_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/categories_data_controller.dart';

class FirstCategoriesUi extends GetView<MovieCategories> {
  const FirstCategoriesUi({super.key});

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AllKar_KaBar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
               
              ),
              itemCount: controller.firstCategoriesDataModel.length,
              itemBuilder: (context, index) {
                final img = controller.firstCategoriesDataModel[index].img;
                final title = controller.firstCategoriesDataModel[index].title;
                final views = controller.firstCategoriesDataModel[index].views;
                final url = controller.firstCategoriesDataModel[index].url;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: img,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(), // Show loading indicator while image is being fetched
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error), // Handle error state

                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
                         Get.put(SecondCategoriesController());
                        Get.to(()=> SecondCategoriesUi(url: url));
                        
                      },
                    ),
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      views,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                );
              },
            );
          }
        }),
      )),
    );
  }
}
