import 'package:allkar_loekar_apyarkar/controller/categories_controller.dart';
import 'package:allkar_loekar_apyarkar/controller/home_controller.dart';
import 'package:allkar_loekar_apyarkar/ui/country_ui/chinese_ui.dart';
import 'package:allkar_loekar_apyarkar/ui/country_ui/japanese_ui.dart';
import 'package:allkar_loekar_apyarkar/ui/country_ui/myanmar_ui.dart';
import 'package:allkar_loekar_apyarkar/ui/watch_ui/watch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/hepler_drawe.dart'; // Import your controller

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeDataController homeDataController = Get.find<HomeDataController>();

  final CategoriesController categoriesController = Get.find();
  @override
  void initState() {
    homeDataController.homeDataFetch("https://anySex.com/new-movies/");
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          child: HelperDrewerWidget(
            categoriesController: categoriesController,
            homeDataController: homeDataController,
          ),
        ),
      ),
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
        child: Obx(() {
          if (homeDataController.isLoading.value &&
              homeDataController.movies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!homeDataController.isLoading.value &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                homeDataController.homeDataFetch(
                    "https://anySex.com/new-movies/"); // Load more when scrolled to bottom
              }
              return false;
            },
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            Get.to(() => const ChineseUi());
                          },
                          child: Text(
                            "Chinese",
                            style: textStyle,
                          )),
                      OutlinedButton(
                          onPressed: () {
                            Get.to(() => const MyanmarUi());
                          },
                          child: Text(
                            "Myanmar",
                            style: textStyle,
                          )),
                      OutlinedButton(
                          onPressed: () {
                            Get.to(() => const JapaneseUi());
                          },
                          child: Text(
                            "Japanese",
                            style: textStyle,
                          ))
                    ]),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.4,
                              crossAxisSpacing: 10),
                      itemCount: homeDataController.movies.length + 1,
                      itemBuilder: (context, index) {
                        if (index == homeDataController.movies.length) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final movie = homeDataController.movies[index];
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
                                      const Icon(
                                          Icons.error), // Handle error state

                                  fit: BoxFit.cover,
                                ),
                              ),
                              onTap: () {
                                Get.to(() => MyWatch(
                                    img: movie.img,
                                    title: movie.title,
                                    link: movie.url));
                              },
                            ),
                            Text(
                              movie.title,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        );
                      }),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
