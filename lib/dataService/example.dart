import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class MovieCategories {
  // Fetch the main sections (like New Movies, Top Rated, etc.)
  Future<void> fetchSections() async {
    const String url = "https://anysex.com/categories/";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);

      // Example: Extract sections
      var sections = document.querySelectorAll('li.item'); //.mainmenu > li > a

      List<Map<String, dynamic>> result = [];

      for (var section in sections) {
        final categoriesTitle = section.text;
        final categoriesImg = section.querySelector('img')?.attributes['src'] ?? '';
        final categoriesUrl = section.querySelector("a")!.attributes["href"] ?? "";

        // Scrape individual section URLs for their content
           var movies = await fetchMoviesFromSection(categoriesUrl);

        result.add({
          'title': categoriesTitle,
          'img':categoriesImg,
          "data":movies

        });
      }
  

    
    } else {
      throw Exception("Failed to load webpage");
    }
  }

  // Fetch the movies in each section
  Future<List<Map<String, String>>> fetchMoviesFromSection(
      String sectionUrl) async {
    final response = await http.get(Uri.parse(sectionUrl));

    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);

      // Example: Extract movies from each section
      var movieItems = document.querySelectorAll('.item');

      List<Map<String, String>> movies = [];

      for (var item in movieItems) {
        final title =
            item.querySelector('img')?.attributes['alt'] ?? 'Unknown Title';
        final img = item.querySelector('img')?.attributes['src'] ?? '';
        final url = item.querySelector('a')?.attributes['href'] ?? '';

        movies.add({
          'title': title,
          'img': img,
          'url': url
        });
      }

      return movies;
    } else {
      throw Exception("Failed to load section page");
    }
  }
}
