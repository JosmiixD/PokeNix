import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/src/models/pokemon.dart';
import 'package:pokedex/src/services/pokemon_service.dart';
import 'package:pokedex/src/widgets/components/pokedex/pokemon_item.dart';

class PokemonListView extends StatelessWidget {

  final PokemonService pokemonService;

  const PokemonListView({Key key, @required this.pokemonService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Pokemon> pokemonItems = pokemonService.pokemon;
    return pokemonService.pokemon.isNotEmpty
        ? Stack(
          children: [
            ListView.builder(
              padding: EdgeInsets.only( bottom: 20 ),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: pokemonItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      FadeIn(
                        duration: Duration( milliseconds: 500),
                        child: PokemonItem(
                          pokemon: pokemonItems[index],
                        ),
                      ),
                      if( (pokemonService.isLoading) && (index + 1 == pokemonService.pokemon.length))
                        ...[
                          Container(
                            padding: EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: CircularProgressIndicator( strokeWidth: 2,),
                            ),
                          )
                        ]
                    ],
                  );
                },
              ),
          ],
        )
        : Container(
          height: MediaQuery.of(context).size.height * 0.50,
          child: Center(child: Text('A wild Snorlax blocks our path, no pokemon around')));
  }
}