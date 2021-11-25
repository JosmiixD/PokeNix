import 'package:flutter/material.dart';
import 'package:pokedex/src/helpers/helpers.dart';
import 'package:pokedex/src/models/pokemon.dart';
import 'package:pokedex/src/models/pokemon_species_info.dart';
import 'package:pokedex/src/services/pokemon_service.dart';
import 'package:pokedex/src/theme/constants.dart';
import 'package:pokedex/src/widgets/components/pokedex/pokemon-details/pokemon_header.dart';
import 'package:provider/provider.dart';

class PokemonDetailsPage extends StatelessWidget {
  const PokemonDetailsPage({Key key, @required this.pokemon}) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor:
            getPokemonTypeBackgroundColor(pokemon.types[0].type.name),
        body: Column(
          children: [
            PokemonHeader(pokemon: pokemon),
            Expanded(child: PokemonDetailsTabBar(pokemon: pokemon))
          ],
        ));
  }
}

class PokemonDetailsTabBar extends StatefulWidget {
  const PokemonDetailsTabBar({
    Key key,
    @required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  _PokemonDetailsTabBarState createState() => _PokemonDetailsTabBarState();
}

class _PokemonDetailsTabBarState extends State<PokemonDetailsTabBar>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int currentTabIndex = 1;
  var pokemonSpeciesInfo = new PokemonSpeciesInfo();

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final pokemonService =
          Provider.of<PokemonService>(context, listen: false);

      pokemonSpeciesInfo =
          await pokemonService.getPokemonSpeciesData(widget.pokemon.id);
      setState(() {});
      print('get');
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Radius backgroundRadius = Radius.circular(30);
    final Pokemon pokemon = widget.pokemon;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          controller: tabController,
          indicatorColor: Colors.transparent,
          labelStyle: pokeNixFilterTitleTextStyle,
          unselectedLabelStyle: pokeNixDescriptionTextStlye,
          tabs: [
            Text('About'),
            Text('Status'),
            Text('Evolution'),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: backgroundRadius, topRight: backgroundRadius),
                color: Colors.white),
            child: TabBarView(
              physics: BouncingScrollPhysics(),
              controller: tabController,
              children: [
                AboutPokemonPage(
                    pokemon: pokemon, pokemonSpeciesInfo: pokemonSpeciesInfo),
                Container(
                  child: Text('Segundo Tab'),
                ),
                Container(
                  child: Text('Terceri Tab'),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class AboutPokemonPage extends StatelessWidget {
  const AboutPokemonPage(
      {Key key, @required this.pokemon, @required this.pokemonSpeciesInfo})
      : super(key: key);

  final Pokemon pokemon;
  final PokemonSpeciesInfo pokemonSpeciesInfo;

  @override
  Widget build(BuildContext context) {

    final pokemonService = Provider.of<PokemonService>(context);
    String pokemonDescription = '';
    
    if( !pokemonService.isLoading && pokemonSpeciesInfo != null ) {
        final pokemonFlavorTextEntry =
          pokemonSpeciesInfo.flavorTextEntries.firstWhere((flavorText) {
        if (flavorText.language.name == 'en' &&
            flavorText.version.name == 'ruby') {
          return true;
        } else {
          return false;
        }
      });

      pokemonDescription = pokemonFlavorTextEntry.flavorText.replaceAll("\n", " ").replaceAll("\f", " ");

    }
    
    return !pokemonService.isLoading 
      ? Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Text('$pokemonDescription', style: pokeNixDescriptionTextStlye.copyWith( color: pokeNixTextGrey,),),
              SizedBox(
                height: 20,
              ),
              Text(
                'Pokédex Data',
                style: pokeNixFilterTitleTextStyle.copyWith(
                    color: getPokemonTypeColor(pokemon.types[0].type.name)),
              ),
              SizedBox(
                height: 30,
              ),
              PokemoLabelInfo(
                label: 'Species',
                description: '${pokemonSpeciesInfo.genera[7].genus}',
              ),
              PokemoLabelInfo(
                label: 'Height',
                description: '${pokemon.height / 10} m.',
              ),
              PokemoLabelInfo(
                label: 'Height',
                description: '${pokemon.height / 10} m.',
              ),
            ],
          ),
        ),
      )
      : Expanded(
        child: Center(
          child: CircularProgressIndicator( strokeWidth: 1,),
        ),
      );
  }
}

class PokemoLabelInfo extends StatelessWidget {
  const PokemoLabelInfo({
    Key key,
    @required this.label,
    @required this.description,
  }) : super(key: key);

  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: size.width * 0.30,
            child: Text('${this.label}', style: pokeNixPokemonTypeTextStlye),
          ),
          Container(
            child: Text(
              '${this.description}',
              style:
                  pokeNixDescriptionTextStlye.copyWith(color: pokeNixTextGrey),
            ),
          )
        ],
      ),
    );
  }
}
