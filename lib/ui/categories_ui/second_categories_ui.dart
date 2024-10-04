import 'package:allkar_loekar_apyarkar/controller/second_categories_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecondCategoriesUi extends StatefulWidget {
  final String url;
  const SecondCategoriesUi({super.key,required this.url});

  @override
  State<SecondCategoriesUi> createState() => _SecondCategoriesUiState();
}

class _SecondCategoriesUiState extends State<SecondCategoriesUi> {
  final SecondCategoriesController controller = Get.find();

  @override
  void initState() {
    controller.fetchMoviesFromSection(widget.url);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AllKar_KaBar',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GetBuilder<SecondCategoriesController>(
          init: SecondCategoriesController(),
          builder: (_){
          if (controller.isLoading.value &&
              controller.secondCategoriesDataModel.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (controller.isLoading.value &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                controller.fetchMoviesFromSection(
                   widget.url); // Load more when scrolled to bottom
              }
              return false;
            },
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                itemCount: controller.secondCategoriesDataModel.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.secondCategoriesDataModel.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final movie = controller.secondCategoriesDataModel[index];
                  return Column(
                    children: [
                      GestureDetector(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: movie.img,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(), // Show loading indicator while image is being fetched
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error), // Handle error state

                            fit: BoxFit.cover,
                          ),
                        ),
                        onTap: () {},
                      ),
                      Text(
                        movie.title,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  );
                }),
          );
        })
      ),
    );
  }
}
