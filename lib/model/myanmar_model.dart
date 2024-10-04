import 'dart:convert';

List<MyanmarModel> myanmarModelFromJson(String str) => List<MyanmarModel>.from(json.decode(str).map((x) => MyanmarModel.fromJson(x)));

String myanmarModelToJson(List<MyanmarModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyanmarModel {
    final String title;
    final String img;
    final List<Movie> movie;

    MyanmarModel({
        required this.title,
        required this.img,
        required this.movie,
    });

    factory MyanmarModel.fromJson(Map<String, dynamic> json) => MyanmarModel(
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
