import 'package:allkar_loekar_apyarkar/ui/watch_ui/watch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataViewAll extends StatelessWidget {
  final List list;
  const DataViewAll({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          padding: const EdgeInsets.all(1.0),
          child: Column(children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 10),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final img = list[index].img;
                  final title = list[index].title;
                  final link = list[index].link;
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
                          Get.to(() =>
                              MyWatch(img: img, title: title, link: link));
                        },
                      ),
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  );
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
