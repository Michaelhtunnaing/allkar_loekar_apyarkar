import 'package:allkar_loekar_apyarkar/model/data_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

import '../model/example_model.dart';

class HomeDataController extends GetxController {
  // List of movies
  var movies = <DataModel>[].obs;
  var page = 1.obs;
  var isLoading = false.obs;
  var isLoadMore = false.obs;
  var categories = <ExampleModel>[].obs;

 //https://anySex.com/new-movies/
 
  Future<void> homeDataFetch(String homeUrl) async {
    try {
      if (isLoading.value || isLoadMore.value) return;

      isLoading.value = true;
      final String url =
          "$homeUrl${page.value}/"; // Replace with actual URL
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        dom.Document html = parser.parse(response.body);

        final titles = html
            .querySelectorAll("a > div.img > img")
            .map((e) => e.attributes["alt"])
            .toList();

        final imgs = html
            .querySelectorAll("a > div.img > img")
            .map((e) => e.attributes["src"])
            .toList();

        final links = html
            .querySelectorAll(".item > a")
            .map((e) => e.attributes["href"])
            .toList();

        var newMovies = List.generate(
          titles.length,
          (index) => DataModel(
            title: titles[index]!,
            img: imgs[index]!,
            url: 'https://anySex.com${links[index]}',
          ),
        );
       categories.value  = List.generate(
          titles.length,
          (index) => ExampleModel(
            title: titles[index]!,
            img: imgs[index]!,
            url: 'https://anySex.com${links[index]}',
          ),
        );

        // Append new movies to the existing list
        movies.addAll(newMovies);
       

        page.value++; // Increment page number for load more
      }

      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

 
}
