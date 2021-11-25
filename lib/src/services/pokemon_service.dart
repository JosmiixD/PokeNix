import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/src/env/environment.dart';
import 'package:pokedex/src/models/pokemon.dart';
import 'package:pokedex/src/models/pokemon_species_info.dart';

class PokemonService with ChangeNotifier {

  bool _isLoading = false;

  String nextPokemon = '';
  List<Pokemon> pokemon = [];  

  bool get isLoading => this._isLoading;
  set isLoading( bool value ) {
    this._isLoading = value;
    notifyListeners();
  }


  Future<dynamic> getPokemonData() async {

    this.isLoading = true;

    final response = await Dio().get( (nextPokemon != '') ? nextPokemon : '${Environment.pokeApiUrl}/pokemon' );

    final List<dynamic> data = response.data['results'];
    nextPokemon = response.data['next'];

    final List<Pokemon> pokemonList = await Future.wait( data.map((element) {

      return getPokemon( element['url'] );
    
    }));

    this.pokemon.addAll(pokemonList);
    this.isLoading = false;

  }

  Future<dynamic> getPokemonSpeciesData( int id ) async {

    this.isLoading = true;

    try {

      final response = await Dio().get('${Environment.pokeApiUrl}/pokemon-species/$id');
      final PokemonSpeciesInfo pokemonSpeciesInfo = pokemonSpeciesInfoFromJson( jsonEncode(response.data) );

      this.isLoading = false;

      return pokemonSpeciesInfo;
    } catch (e) {
      this.isLoading = false;
      return [];
    }

  }

  Future<Pokemon> getPokemon( String url ) async {

    final response = await Dio().get( url );
    final pokemon = pokemonFromJson( jsonEncode(response.data) );
    return pokemon;

  }



}