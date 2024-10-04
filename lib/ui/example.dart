import 'package:allkar_loekar_apyarkar/controller/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Example extends GetView<HomeDataController> {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return ListView.builder(
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: controller.categories[index].img,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(), // Show loading indicator while image is being fetched
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error), // Handle error state

                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () {}),
                Text(
                  controller.categories[index].title,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            );
          },
        );
      }
    }));
  }
}
