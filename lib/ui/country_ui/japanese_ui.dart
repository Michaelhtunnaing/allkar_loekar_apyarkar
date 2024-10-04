import 'package:allkar_loekar_apyarkar/controller/japanese_controller.dart';
import 'package:allkar_loekar_apyarkar/ui/data_viewall.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JapaneseUi extends GetView<JapaneseController> {
  const JapaneseUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ALLKAR"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(3),
        child: Obx(() {
          if (controller.isLoaidng.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Text(controller.errorMessage.toString()),
            );
          } else {
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.3,
                    crossAxisCount: 2),
                itemCount: controller.japaneseData.length,
                itemBuilder: (context, index) {
                  String title = controller.japaneseData[index].title;
                  String img = controller.japaneseData[index].img;
                  List list = controller.japaneseData[index].movie;
                  return Column(
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
                          Get.to(() => DataViewAll(list: list));
                        },
                      ),
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  );
                });
          }
        }),
      )),
    );
  }
}
