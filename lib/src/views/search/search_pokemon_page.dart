import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pokedex/src/env/environment.dart';
import 'package:pokedex/src/models/history/search.dart';
import 'package:pokedex/src/models/pokemon.dart';
import 'package:pokedex/src/models/pokemon_list.dart';
import 'package:pokedex/src/services/history_service.dart';
import 'package:pokedex/src/services/pokemon_service.dart';
import 'package:pokedex/src/theme/constants.dart';
import 'package:pokedex/src/views/home/pokemon_details_page.dart';
import 'package:pokedex/src/widgets/components/general/pokenix_custom_back_button.dart';
import 'package:provider/provider.dart';

class SearchPokemonPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final historyService = Provider.of<HistoryService>(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          child: PokenixCustomBackButton(
            color: pokeNixTextBlack,
            height: 12,
            onPressed: () {
              historyService.disposeSearch();
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Hero(
          tag: 'pokenixSearch',
          child: SearchPokemonTextField(),
        )
      ),
      body: Container(
        padding: EdgeInsets.symmetric( horizontal: 20 ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox( height: 10),
            if( historyService.isSearchActive )
            ...[
              FadeIn( duration: Duration( milliseconds: 500 ), child: Text('Results', style: pokeNixPokemonNameTextStyle)),
            ] else...[
              FadeIn(duration: Duration( milliseconds: 500 ), child: Text('History', style: pokeNixPokemonNameTextStyle)),
            ],
            SizedBox( height: 10),
            Expanded(
              child: 
                (historyService.isSearchActive && historyService.searchResults.length > 0 ) ?
                ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: historyService.searchResults.length,
                itemBuilder: (BuildContext context, int index) {

                  final PokemonList item = historyService.searchResults[index];

                  return FadeIn(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text( toBeginningOfSentenceCase(item.name) ),
                      leading: Align( 
                        widthFactor: 1.0,
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/images/svg/patterns/Pokeball.svg',
                          height: 15,
                          color: pokeNixTextBlack,
                        )
                      ),
                      minLeadingWidth: 2.0,
                      onTap: () async {

                        historyService.searchResults.add(item);

                        final url = '${Environment.pokeApiUrl}pokemon/${item.name}';
                        final Pokemon pokemon = await Provider.of<PokemonService>(context, listen: false).getPokemon(url);
                        Navigator.of(context).push(CupertinoPageRoute(builder: (_) => PokemonDetailsPage(pokemon: pokemon)));

                      },
                    ),
                  );
                },
              )
              : Container(
                child:
                  (historyService.searches.length > 0)
                  ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: historyService.searches.length,
                    itemBuilder: (BuildContext context, int index) {

                      final Search item = historyService.searches[index];

                      return FadeIn(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text( item.query ),
                          leading: Align( widthFactor: 1.0, alignment: Alignment.center ,child: Icon(Icons.schedule_rounded, size: 18, color: pokeNixTextBlack )),
                          minLeadingWidth: 2.0,
                          onTap: () async {
                            final url = '${Environment.pokeApiUrl}pokemon/${item.query}';
                            final Pokemon pokemon = await Provider.of<PokemonService>(context, listen: false).getPokemon(url);
                            Navigator.of(context).push(CupertinoPageRoute(builder: (_) => PokemonDetailsPage(pokemon: pokemon)));
                          },
                        ),
                      );
                    },
                  )
                  : Center(child: Text('There is nothing here'))
                
              ),
            ),
          ],
        )
      ),
    );

  }
}

class SearchPokemonTextField extends StatefulWidget {
  const SearchPokemonTextField({
    Key key,
  }) : super(key: key);

  @override
  _SearchPokemonTextFieldState createState() => _SearchPokemonTextFieldState();
}

class _SearchPokemonTextFieldState extends State<SearchPokemonTextField> {

  final TextEditingController searchController = new TextEditingController();
  Timer _debounce;

  @override
  void dispose() {
    searchController?.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final historyService = Provider.of<HistoryService>(context);

    return CupertinoSearchTextField(
      controller: searchController,
      placeholder: 'What Pókemon are you looking for?',
      placeholderStyle: pokeNixDescriptionTextStlye.copyWith(
        color: pokeNixTextGrey),
      onSubmitted: ( String query ) {
        historyService.saveSearch( query: query);
      },
      onChanged: ( query ) {
        if(_debounce?.isActive ?? false ) _debounce.cancel();
        _debounce = Timer( Duration( milliseconds:  750 ), () {

          if( query == '' ) {
            historyService.isSearchActive = false;
            return;
          }

          //BEGIN:: Search pokemon
          historyService.searchPokemon( query );

        });
        
      },
    );
  }
}