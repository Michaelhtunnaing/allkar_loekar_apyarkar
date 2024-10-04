import 'dart:convert';

List<ChineseModel> chineseModelFromJson(String str) => List<ChineseModel>.from(
    json.decode(str).map((x) => ChineseModel.fromJson(x)));

String chineseModelToJson(List<ChineseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChineseModel {
  final String title;
  final String img;
  final List<Movie> movie;

  ChineseModel({
    required this.title,
    required this.img,
    required this.movie,
  });

  factory ChineseModel.fromJson(Map<String, dynamic> json) => ChineseModel(
        title: json["title"],
        img: json["img"],
        movie: List<Movie>.from(json["movie"].map((x) => Movie.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "img": img,
        "movie": List<dynamic>.from(movie.map((x) => x.toJson())),
      };
}

class Movie {
  final String title;
  final String img;
  final String link;

  Movie({
    required this.title,
    required this.img,
    required this.link,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        title: json["title"],
        img: json["img"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "img": img,
        "link": link,
      };
}
