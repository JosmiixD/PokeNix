import 'dart:convert';

import 'package:pokedex/src/models/species.dart';

PokemonEvolutionChain pokemonEvolutionChainFromJson(String str) => PokemonEvolutionChain.fromJson(json.decode(str));

String pokemonEvolutionChainToJson(PokemonEvolutionChain data) => json.encode(data.toJson());

class PokemonEvolutionChain {
    PokemonEvolutionChain({
        this.chain,
        this.id,
    });

    Chain chain;
    int id;

    factory PokemonEvolutionChain.fromJson(Map<String, dynamic> json) => PokemonEvolutionChain(
        chain: Chain.fromJson(json["chain"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "chain": chain.toJson(),
        "id": id,
    };
}

class Chain {
    Chain({
        this.evolutionDetails,
        this.evolvesTo,
        this.species,
    });

    List<EvolutionDetail> evolutionDetails;
    List<Chain> evolvesTo;
    Species species;

    factory Chain.fromJson(Map<String, dynamic> json) => Chain(
        evolutionDetails: List<EvolutionDetail>.from(json["evolution_details"].map((x) => EvolutionDetail.fromJson(x))),
        evolvesTo: List<Chain>.from(json["evolves_to"].map((x) => Chain.fromJson(x))),
        species: Species.fromJson(json["species"]),
    );

    Map<String, dynamic> toJson() => {
        "evolution_details": List<dynamic>.from(evolutionDetails.map((x) => x.toJson())),
        "evolves_to": List<dynamic>.from(evolvesTo.map((x) => x.toJson())),
        "species": species.toJson(),
    };
}

class EvolutionDetail {
    EvolutionDetail({
        this.minLevel,
    });

    int minLevel;

    factory EvolutionDetail.fromJson(Map<String, dynamic> json) => EvolutionDetail(
        minLevel: json["min_level"],
    );

    Map<String, dynamic> toJson() => {
        "min_level": minLevel,
    };
}

