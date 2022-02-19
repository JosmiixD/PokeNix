
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/src/global/global.dart';
import 'package:pokedex/src/models/history/search.dart';
import 'package:pokedex/src/models/pokemon_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService with ChangeNotifier {

  bool _isLoading = false;
  bool _isSearchActive = false;

  List<Search> _searches = [];
  List<PokemonList> searchResults = [];

  HistoryService() {
    this.getSearches();
    // this.saveSearch();
  }

  bool get isLoading => this._isLoading;

  set isLoading( bool value ) {
    this._isLoading = value;
    notifyListeners();
  }

  bool get isSearchActive => this._isSearchActive;

  set isSearchActive( bool value ) {
    this._isSearchActive = value;
    notifyListeners();
  }

  List<Search> get searches => this._searches;

  set searches( List<Search> searches ) {
    this._searches = searches;
    notifyListeners();
  }
  
  // BEGIN:: READ HISTORY FROM SHAREDPREFERENCES

  Future getSearches() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String history = prefs.getString('history');
    
    if( history != null ) {
      this.searches = searchFromJson( history );
    }

  }

  // END:: READ HISTORY FROM SHAREDPREFERENCES

  Future saveSearch({ String query }) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final Search search = Search.fromJson({
      'query': query
    });

    this._searches.insert( 0, search );

    if( this._searches.length > 10 ) {
      this._searches.removeLast();
    }

    prefs.setString('history', jsonEncode( this._searches ));

    
  }

  void searchPokemon( String query ) {

    this.searchResults = [];
    this.isSearchActive = true;

    final List<PokemonList> results = globalPokemonList.where((pokemon) {

      if( pokemon.name.contains(query.toLowerCase()) ) {
        return true;
      } else {
        return false;
      }

    }).toList();

    this.searchResults.addAll( results );


  }

  void disposeSearch() {
    this.isSearchActive = false;
    this.searchResults = [];
  }


}