// To parse this JSON data, do
//
//     final pokemonTypeInfo = pokemonTypeInfoFromJson(jsonString);

import 'dart:convert';

PokemonTypeInfo pokemonTypeInfoFromJson(String str) => PokemonTypeInfo.fromJson(json.decode(str));

String pokemonTypeInfoToJson(PokemonTypeInfo data) => json.encode(data.toJson());

class PokemonTypeInfo {
    PokemonTypeInfo({
        this.damageRelations,
        this.id,
        this.name,
    });

    DamageRelations damageRelations;
    int id;
    String name;

    factory PokemonTypeInfo.fromJson(Map<String, dynamic> json) => PokemonTypeInfo(
        damageRelations: DamageRelations.fromJson(json["damage_relations"]),
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "damage_relations": damageRelations.toJson(),
        "id": id,
        "name": name,
    };
}

class DamageRelations {
    DamageRelations({
        this.doubleDamageFrom,
        this.doubleDamageTo,
        this.halfDamageFrom,
        this.halfDamageTo,
        this.noDamageFrom,
        this.noDamageTo,
    });

    List<Damage> doubleDamageFrom;
    List<Damage> doubleDamageTo;
    List<Damage> halfDamageFrom;
    List<Damage> halfDamageTo;
    List<dynamic> noDamageFrom;
    List<dynamic> noDamageTo;

    factory DamageRelations.fromJson(Map<String, dynamic> json) => DamageRelations(
        doubleDamageFrom: List<Damage>.from(json["double_damage_from"].map((x) => Damage.fromJson(x))),
        doubleDamageTo: List<Damage>.from(json["double_damage_to"].map((x) => Damage.fromJson(x))),
        halfDamageFrom: List<Damage>.from(json["half_damage_from"].map((x) => Damage.fromJson(x))),
        halfDamageTo: List<Damage>.from(json["half_damage_to"].map((x) => Damage.fromJson(x))),
        noDamageFrom: List<dynamic>.from(json["no_damage_from"].map((x) => x)),
        noDamageTo: List<dynamic>.from(json["no_damage_to"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "double_damage_from": List<dynamic>.from(doubleDamageFrom.map((x) => x.toJson())),
        "double_damage_to": List<dynamic>.from(doubleDamageTo.map((x) => x.toJson())),
        "half_damage_from": List<dynamic>.from(halfDamageFrom.map((x) => x.toJson())),
        "half_damage_to": List<dynamic>.from(halfDamageTo.map((x) => x.toJson())),
        "no_damage_from": List<dynamic>.from(noDamageFrom.map((x) => x)),
        "no_damage_to": List<dynamic>.from(noDamageTo.map((x) => x)),
    };
}

class Damage {
    Damage({
        this.name,
        this.url,
    });

    String name;
    String url;

    factory Damage.fromJson(Map<String, dynamic> json) => Damage(
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
    };
}

