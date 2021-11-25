import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final pokemonService =
          Provider.of<PokemonService>(context, listen: false);
      await pokemonService.getPokemonSpeciesData(widget.pokemon.id);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Radius backgroundRadius = Radius.circular(5);
    final Pokemon pokemon = widget.pokemon;
    final pokemonService = Provider.of<PokemonService>(context);

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
            Text('Stats'),
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
            child: (pokemonService.isLoading &&
                    pokemonService.pokemonSpeciesInfo !=
                        new PokemonSpeciesInfo())
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : TabBarView(
                    physics: BouncingScrollPhysics(),
                    controller: tabController,
                    children: [
                      AboutPokemonPage(pokemon: pokemon),
                      StatsPokemonPage(pokemon: pokemon),
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

class StatsPokemonPage extends StatelessWidget {
  final Pokemon pokemon;

  const StatsPokemonPage({Key key, @required this.pokemon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pokemonService = Provider.of<PokemonService>(context);
    PokemonSpeciesInfo pokemonSpeciesInfo = pokemonService.pokemonSpeciesInfo;

    return !pokemonService.isLoading
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Base Stats',
                    style: pokeNixFilterTitleTextStyle.copyWith(
                        color: getPokemonTypeColor(pokemon.types[0].type.name)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  PokemonStatItem(pokemon: pokemon),
                ],
              ),
            ),
          )
        : Container();
  }
}

class PokemonStatItem extends StatelessWidget {
  const PokemonStatItem({
    Key key,
    @required this.pokemon,
    this.label,
    this.baseStat,
    this.percent,
    this.minStat,
    this.maxStat,
  }) : super(key: key);

  final Pokemon pokemon;
  final String label;
  final String baseStat;
  final double percent;
  final String minStat;
  final String maxStat;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            child: Text('HP', style: pokeNixPokemonTypeTextStlye),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.10,
            child: Text(
              '45',
              style:
                  pokeNixDescriptionTextStlye.copyWith(color: pokeNixTextGrey),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: 10,
            child: LinearPercentIndicator(
              progressColor: getPokemonTypeColor(pokemon.types[0].type.name),
              backgroundColor: pokeNixBackgroundDefaultInput,
              percent: 0.6,
              animation: true,

            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.10,
            child: Text(
              '200',
              style:
                  pokeNixDescriptionTextStlye.copyWith(color: pokeNixTextGrey),
              textAlign: TextAlign.right,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.10,
            child: Text(
              '294',
              style:
                  pokeNixDescriptionTextStlye.copyWith(color: pokeNixTextGrey),
              textAlign: TextAlign.right
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPokemonPage extends StatelessWidget {
  const AboutPokemonPage({Key key, @required this.pokemon}) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final pokemonService = Provider.of<PokemonService>(context);
    String pokemonDescription = '';
    PokemonSpeciesInfo pokemonSpeciesInfo = pokemonService.pokemonSpeciesInfo;

    if (!pokemonService.isLoading && pokemonSpeciesInfo != null) {
      final pokemonFlavorTextEntry =
          pokemonSpeciesInfo.flavorTextEntries.firstWhere((flavorText) {
        if (flavorText.language.name == 'en' &&
            flavorText.version.name == 'ruby') {
          return true;
        } else {
          return false;
        }
      });

      pokemonDescription = pokemonFlavorTextEntry.flavorText
          .replaceAll("\n", " ")
          .replaceAll("\f", " ");
    }

    return !pokemonService.isLoading
        ? Scrollbar(
            radius: Radius.circular(20),
            thickness: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '$pokemonDescription',
                      style: pokeNixDescriptionTextStlye.copyWith(
                        color: pokeNixTextGrey,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Pokédex Data',
                      style: pokeNixFilterTitleTextStyle.copyWith(
                          color:
                              getPokemonTypeColor(pokemon.types[0].type.name)),
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
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: Text('Abilities',
                              style: pokeNixPokemonTypeTextStlye),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(pokemon.abilities.length,
                                (index) {
                              final Ability ability = pokemon.abilities[index];
                              return Text(
                                ' ${!ability.isHidden ? index + 1 : ''} ${toBeginningOfSentenceCase(ability.ability.name)} ${ability.isHidden ? '(hidden ability)' : ''}',
                                style: ability.isHidden
                                    ? pokeNixPokemonTypeTextStlye.copyWith(
                                        color: pokeNixTextGrey)
                                    : pokeNixDescriptionTextStlye.copyWith(
                                        color: pokeNixTextGrey),
                              );
                            }),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Training',
                      style: pokeNixFilterTitleTextStyle.copyWith(
                          color:
                              getPokemonTypeColor(pokemon.types[0].type.name)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    PokemoLabelInfo(
                      label: 'Catch Rate',
                      description:
                          '${pokemonSpeciesInfo.captureRate} ${getCatchRate(pokemonSpeciesInfo.captureRate)}',
                    ),
                    PokemoLabelInfo(
                      label: 'Base Friendship',
                      description: '${pokemonSpeciesInfo.baseHappiness}',
                    ),
                    PokemoLabelInfo(
                      label: 'Base Exp',
                      description: '${pokemon.baseExperience}',
                    ),
                    PokemoLabelInfo(
                      label: 'Growth Rate',
                      description:
                          '${getGrowthRate(pokemonSpeciesInfo.growthRate.name)}',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Breeding',
                      style: pokeNixFilterTitleTextStyle.copyWith(
                          color:
                              getPokemonTypeColor(pokemon.types[0].type.name)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.30,
                            child: Text('Gender',
                                style: pokeNixPokemonTypeTextStlye),
                          ),
                          Container(
                              child: (pokemonSpeciesInfo.genderRate == -1)
                                  ? Text('No gender')
                                  : Row(
                                      children: getGenderRate(
                                              pokemonSpeciesInfo.genderRate)
                                          .split(',')
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                      return Text(
                                        '${entry.value}  ',
                                        style: pokeNixDescriptionTextStlye
                                            .copyWith(
                                                color: entry.key == 0
                                                    ? pokeNixTypeFlyingColor
                                                    : pokeNixTypeFairyColor),
                                      );
                                    }).toList()))
                        ],
                      ),
                    ),
                    PokemoLabelInfo(
                      label: 'Base Exp',
                      description: getEggGroups(pokemonSpeciesInfo.eggGroups),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Expanded(
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
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
