import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import '../model/seconde_categories_model.dart';

class SecondCategoriesController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  int currentPage = 1;
  bool hasMoreData = true;
  var secondCategoriesDataModel = <SecondeCategoriesModel>[].obs;

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

        secondResult
            .add(SecondeCategoriesModel(title: title, img: img, url: url));
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
