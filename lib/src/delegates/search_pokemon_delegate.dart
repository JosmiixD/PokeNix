
import 'package:flutter/material.dart';
import 'package:pokedex/src/theme/constants.dart';
import 'package:pokedex/src/widgets/components/general/pokenix_custom_back_button.dart';

class SearchPokemonDelegate extends SearchDelegate {

  @override
    String get searchFieldLabel => 'What Pokémon are you looking for?';
  
  @override
    TextStyle get searchFieldStyle => pokeNixDescriptionTextStlye.copyWith( color: pokeNixTextGrey );
      

  @override
  List<Widget> buildActions(BuildContext context) {
    
    return [
      
    ];

  }

  @override
  Widget buildLeading(BuildContext context) {
    return Container(
      child: PokenixCustomBackButton(
        color: pokeNixTextBlack,
        height: 10,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('Build Results');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('Build Suggestions');
  }



}