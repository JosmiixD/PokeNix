import 'package:flutter/material.dart';
import 'package:pokedex/src/services/pokemon_service.dart';
import 'package:pokedex/src/widgets/components/pokedex/pokemon_list_view.dart';
import 'package:pokedex/src/widgets/components/pokedex/pokemon_shimmer_list.dart';
import 'package:provider/provider.dart';

class PokemonList extends StatefulWidget {
  const PokemonList({
    Key key,
  }) : super(key: key);

  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final pokemonService =
          Provider.of<PokemonService>(context, listen: false);
      await pokemonService.getPokemonData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pokemonService = Provider.of<PokemonService>(context);

    return SliverToBoxAdapter(
      child: Container(
        child: (pokemonService.isLoading && pokemonService.pokemon.isEmpty)
            ? PokemonShimmerList()
            : PokemonListView(
                pokemonService: pokemonService,
              ),
      ),
    );
  }
}