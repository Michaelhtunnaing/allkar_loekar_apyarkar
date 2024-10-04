import 'package:allkar_loekar_apyarkar/model/seconde_categories_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

import '../model/first_categories_model.dart.dart';

class MovieCategories extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  int currentPage = 1;
  bool hasMoreData = true;
  var firstCategoriesDataModel = <FirstCategoriesModel>[].obs;
  var secondCategoriesDataModel = <SecondeCategoriesModel>[].obs;

  @override
  void onInit() {
    super.onInit();
   // fetchSections();
  }

  // Fetch the main sections (like New Movies, Top Rated, etc.)
  Future<void> fetchSections() async {
    isLoading.value = true; // Show loading state

    const String url = "https://anysex.com/categories/";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);

      // Extract sections
      var sections = document.querySelectorAll('ul.box > li.item');

      List<FirstCategoriesModel> result = [];

      for (var section in sections) {
        final categoriesTitle =
            section.querySelector('a')!.attributes['title'] ?? "Unknown Title";
        final categoriesImg =
            section.querySelector('img')?.attributes['src'] ?? '';
        final categoriesView =
            section.querySelector(".desc > .views")?.text ?? "";
        final categoriesUrl =
            section.querySelector("a")?.attributes["href"] ?? "";

        // Create and add the Category Data Model
        result.add(FirstCategoriesModel(
          title: categoriesTitle,
          img: categoriesImg,
          views: categoriesView,
          url: categoriesUrl,
        ));
      }

      firstCategoriesDataModel.value =
          result; // Assign the result to the observable list
    } else {
      throw Exception("Failed to load webpage");
    }

    isLoading.value = false; // Hide loading state
  }

  // Fetch the movies in each section
  Future<void> fetchMoviesFromSection(
    String dataUrl,
  ) async {
    if (isLoading.value || isLoadingMore.value) return;
    final response = await http.get(Uri.parse('$dataUrl$currentPage/'));

    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);

      // Extract movies from each section
      var movieItems = document.querySelectorAll('.item');
      if (movieItems.isEmpty) {
        hasMoreData = false; // No more data to load
      }

      List<SecondeCategoriesModel> secondResult = [];

      for (var item in movieItems) {
        final title =
            item.querySelector('img')?.attributes['alt'] ?? 'Unknown Title';
        final img = item.querySelector('img')?.attributes['src'] ?? '';
        final url = item.querySelector('a')?.attributes['href'] ?? '';

        secondResult.add(SecondeCategoriesModel(title: title, img: img, url: url));
      }

      secondCategoriesDataModel
          .addAll(secondResult); // Append new data to the existing list
      currentPage++; // Increment page for the next request
    } else {
      throw Exception("Failed to load section page");
    }

    isLoading.value = false;
  }
}
