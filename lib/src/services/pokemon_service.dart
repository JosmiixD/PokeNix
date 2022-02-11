import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex/src/env/environment.dart';
import 'package:pokedex/src/models/pokemon.dart';
import 'package:pokedex/src/models/pokemon_evolution_chain.dart';
import 'package:pokedex/src/models/pokemon_list.dart';
import 'package:pokedex/src/models/pokemon_species_info.dart';
import 'package:pokedex/src/models/pokemon_type_info.dart';

class PokemonService with ChangeNotifier {

  bool _isLoading = false;

  String nextPokemon = '';
  List<Pokemon> pokemon = [];  
  PokemonSpeciesInfo _pokemonSpeciesInfo;
  PokemonTypeInfo _pokemonTypeInfo;
  PokemonEvolutionChain _pokemonEvolutionChain;
  List<PokemonList> allPokemonList = [];
  int currentPokemonListOffset = 0;


  PokemonService() {

    this.initPokemonService();

  }

  initPokemonService() async {
    String jsonPokemon = await rootBundle.loadString('assets/data/pokemon.json');
    this.allPokemonList = pokemonListFromJson( jsonPokemon );
  }

  bool get isLoading => this._isLoading;
  set isLoading( bool value ) {
    this._isLoading = value;
    notifyListeners();
  }

  PokemonSpeciesInfo get pokemonSpeciesInfo => this._pokemonSpeciesInfo;

  set pokemonSpeciesInfo( PokemonSpeciesInfo info ) {
    this._pokemonSpeciesInfo = info;
    notifyListeners();
  }

  PokemonTypeInfo get pokemonTypeInfo => this._pokemonTypeInfo;

  set pokemonTypeInfo( PokemonTypeInfo info ) {
    this._pokemonTypeInfo = info;
    notifyListeners();
  }

  PokemonEvolutionChain get pokemonEvolutionChain => this._pokemonEvolutionChain;

  set pokemonEvolutionChain( PokemonEvolutionChain evolutionChain ) {
    this._pokemonEvolutionChain = evolutionChain;
    notifyListeners();
  }


  Future<dynamic> getPokemonData() async {

    this.isLoading = true;

    // this.allPokemonList.sublist()

    final response = await Dio().get( (nextPokemon != '') ? nextPokemon : '${Environment.pokeApiUrl}/pokemon?limit=20' );

    final List<dynamic> data = response.data['results'];
    nextPokemon = response.data['next'];

    final List<Pokemon> pokemonList = await Future.wait( data.map((element) {

      return getPokemon( element['url'] );
    
    }));

    this.pokemon.addAll(pokemonList);
    this.isLoading = false;

  }

  Future<dynamic> getPokemonSpeciesData( int id, String url ) async {

    this.isLoading = true;

    try {

      final speciesResponse = await Dio().get('${Environment.pokeApiUrl}pokemon-species/$id');
      final PokemonSpeciesInfo pokemonSpeciesInfo = pokemonSpeciesInfoFromJson( jsonEncode(speciesResponse.data) );

      final typesResponse = await Dio().get(url);
      final PokemonTypeInfo pokemonTypeInfo = pokemonTypeInfoFromJson( jsonEncode(typesResponse.data) );

      final evolutionResponse = await Dio().get( pokemonSpeciesInfo.evolutionChain.url );
      final PokemonEvolutionChain pokemonEvolutionChain = pokemonEvolutionChainFromJson( jsonEncode( evolutionResponse.data ) );

      this.isLoading = false;
      this.pokemonSpeciesInfo = pokemonSpeciesInfo;
      this.pokemonTypeInfo = pokemonTypeInfo;
      this.pokemonEvolutionChain = pokemonEvolutionChain;

    } catch (e) {
      this.isLoading = false;
      this.pokemonSpeciesInfo = null;
      this.pokemonTypeInfo = null;
    }

  }



  Future<Pokemon> getPokemon( String url ) async {

    final response = await Dio().get( url );
    final pokemon = pokemonFromJson( jsonEncode(response.data) );
    return pokemon;

  }



}