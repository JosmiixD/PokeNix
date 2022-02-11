
import 'dart:convert';

List<PokemonList> pokemonListFromJson(String str) => List<PokemonList>.from(json.decode(str).map((x) => PokemonList.fromJson(x)));

String pokemonListToJson(List<PokemonList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PokemonList {
    PokemonList({
        this.name,
        this.url,
    });

    String name;
    String url;

    factory PokemonList.fromJson(Map<String, dynamic> json) => PokemonList(
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
    };
}
