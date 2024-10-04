import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WatchGenerate extends GetxController {
  bool loading = false;
  bool isSuccess = false;
  String watchLink = '';
  Future<void> watchLinkGenerate(String url) async {
    loading = true;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final urls = RegExp('https?://[^\'"]+')
        .allMatches(response.body)
        .map((match) => match.group(0))
        .toList();
    loading = false;

    watchLink = urls.firstWhere(
      (url) => url!.contains(".mp4"),
      orElse: () {
        isSuccess = true;
        loading =
            false; // Set isSuccess to false only if no matching URL is found

        return "Not Found"; // Return an empty string as a fallback value
      },
    )!;

    update();
  }
}
