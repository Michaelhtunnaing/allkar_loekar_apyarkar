import 'package:allkar_loekar_apyarkar/utils/widget_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/watchlink_generate.dart';

class MyWatch extends StatelessWidget {
  final String img;
  final String title;
  final String link;
  const MyWatch(
      {super.key, required this.img, required this.title, required this.link});

  @override
  Widget build(BuildContext context) {
    Get.put(WatchGenerate());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 198, 194),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              SizedBox(
                height: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                      imageUrl: img,
                      fit: BoxFit.fill,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    backgroundColor: Colors.redAccent,
                                    value: downloadProgress.progress),
                              ),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/error.jpg')),
                ),
              ),
              const SizedBox(height: 10),
              Text(title),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 4),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.amber),
                      child: const Text('Watch to Gentrate'),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => MyDialog(link: link));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
           
           
            ],
          ),
        ),
      ),
    );
  }
}
