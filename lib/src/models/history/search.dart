// To parse this JSON data, do
//
//     final search = searchFromJson(jsonString);

import 'dart:convert';

List<Search> searchFromJson(String str) => List<Search>.from(json.decode(str).map((x) => Search.fromJson(x)));

String searchToJson(List<Search> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Search {
    Search({
        this.query,
    });

    String query;

    factory Search.fromJson(Map<String, dynamic> json) => Search(
        query: json["query"],
    );

    Map<String, dynamic> toJson() => {
        "query": query,
    };
}
