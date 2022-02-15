import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pokedex/src/helpers/helpers.dart';
import 'package:pokedex/src/models/pokemon.dart';
import 'package:pokedex/src/models/pokemon_evolution_chain.dart';
import 'package:pokedex/src/models/pokemon_species_info.dart';
import 'package:pokedex/src/models/pokemon_type_info.dart';
import 'package:pokedex/src/models/species.dart';
import 'package:pokedex/src/services/pokemon_service.dart';
import 'package:pokedex/src/theme/constants.dart';
import 'package:pokedex/src/widgets/components/general/pokenix_circular_progress_indicator.dart';
import 'package:pokedex/src/widgets/components/pokedex/pokemon-details/pokemon_header.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PokemonDetailsPage extends StatelessWidget {
  const PokemonDetailsPage({Key key, @required this.pokemon}) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {

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
      await pokemonService.getPokemonSpeciesData(widget.pokemon.id, widget.pokemon.types[0].type.url );
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
                ? PokenixCircularProgressIndicator(animate: !pokemonService.isLoading )
                : FadeIn(
                  duration: Duration( milliseconds: 600 ),
                  child: TabBarView(
                      physics: BouncingScrollPhysics(),
                      controller: tabController,
                      children: [
                        AboutPokemonPage(pokemon: pokemon),
                        StatsPokemonPage(pokemon: pokemon),
                        EvolutionPokemonPage( pokemon: pokemon ),
                      ],
                    ),
                ),
          ),
        )
      ],
    );
  }
}

class EvolutionPokemonPage extends StatelessWidget {
  const EvolutionPokemonPage({ @required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final pokemonService = Provider.of<PokemonService>(context);
    final PokemonEvolutionChain pokemonEvolutionChain = pokemonService.pokemonEvolutionChain;
    final typeColor = getPokemonTypeColor(pokemon.types[0].type.name);
  
    final size = MediaQuery.of(context).size;

    return ( !pokemonService.isLoading )
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
                'Evolution Chart',
                style: pokeNixFilterTitleTextStyle.copyWith(
                    color: typeColor),
              ),
              SizedBox(
                height: 20,
              ),
              (pokemonEvolutionChain.chain.evolvesTo.length > 0)
              ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EvolutionItem(pokemonSpecies: pokemonEvolutionChain.chain.species ),
                      Container(
                        height: size.width * 0.32,
                        margin: EdgeInsets.symmetric( vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/svg/icons/Front.svg',
                              height: 25,
                              color: pokeNixTextGrey.withOpacity(0.5),
                            ),
                            Text('(Level ${pokemonEvolutionChain.chain.evolvesTo[0].evolutionDetails[0].minLevel?? "?"})', style: pokeNixPokemonNumberTextStlye)
                          ],
                        ),
                      ),
                      Column(
                        children: pokemonEvolutionChain.chain.evolvesTo.map(( evolution ) {
                            return EvolutionItem(pokemonSpecies: evolution.species );
                          }).toList(),
                      )
                    ],
                  ),
                  if( pokemonEvolutionChain.chain.evolvesTo[0].evolvesTo.length > 0 )
                  ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EvolutionItem(pokemonSpecies: pokemonEvolutionChain.chain.evolvesTo[0].species ),
                        Container(
                          height: size.width * 0.32,
                          margin: EdgeInsets.symmetric( vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/svg/icons/Front.svg',
                                height: 25,
                                color: pokeNixTextGrey.withOpacity(0.5),
                              ),
                              Text('(Level ${pokemonEvolutionChain.chain.evolvesTo[0].evolvesTo[0].evolutionDetails[0].minLevel ?? "?"})', style: pokeNixPokemonNumberTextStlye)
                            ],
                          ),
                        ),
                        Column(
                          children: pokemonEvolutionChain.chain.evolvesTo[0].evolvesTo.map((evolution) => EvolutionItem(pokemonSpecies: evolution.species )).toList()
                          // children: pokemonEvolutionChain.chain.evolvesTo.map(( evolution ) {
                          //     return EvolutionItem(pokemonSpecies: evolution.species );
                          //   }).toList(),
                        )
                      ],
                    ),
                  ]
                ],
              )
              : Center(
                heightFactor: 5,
                  child: Text( '${toBeginningOfSentenceCase(pokemon.name)} does not evolve', style: pokeNixPokemonTypeTextStlye.copyWith(color: pokeNixTextGrey) ),
              ),
            ],

          )
        )
      )
      : PokenixCircularProgressIndicator(animate: !pokemonService.isLoading );
  }
}

class EvolutionItem extends StatelessWidget {
  const EvolutionItem({
    Key key,
    @required this.pokemonSpecies,
  }) : super(key: key);

  final Species pokemonSpecies;

  @override
  Widget build(BuildContext context) {

    final splitedURL = pokemonSpecies.url.split('pokemon-species/');
    final id = splitedURL[1].split('/')[0];
    final size = MediaQuery.of(context).size;


    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric( vertical: 10),
          width: size.width * 0.32,
          height: size.width * 0.32,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SvgPicture.asset(
                'assets/images/svg/patterns/Pokeball.svg',
                color: pokeNixTextGrey.withOpacity(0.05)
              ),
              CachedNetworkImage(
                fadeInDuration: Duration( milliseconds: 400 ),
                key: UniqueKey(),
                imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
                placeholder: (_, __) => Shimmer.fromColors(
                    child: Image.asset('assets/images/png/25.png'),
                    baseColor: pokeNixShimmerBaseColor,
                    highlightColor: pokeNixShimmerHighlightColor),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none,
              ),
            ],
          ),
        ),
        SizedBox( height: 5),
        Column(
          children: [
            Text(
              '#${id.toString().padLeft(3, '0')}',
              style: pokeNixPokemonNumberTextStlye.copyWith(
                  color: pokeNixTextGrey),
            ),
            Text('${toBeginningOfSentenceCase( pokemonSpecies.name )}', style: pokeNixFilterTitleTextStyle ),
            SizedBox( height: 5)
          ],
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

    final width = MediaQuery.of(context).size.width;
    final typeColor = getPokemonTypeColor(pokemon.types[0].type.name);

    final pokemonService = Provider.of<PokemonService>(context);
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
                        color: typeColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ...List.generate(pokemon.stats.length, (index) {
                    return PokemonStatItem(
                      stat: pokemon.stats[index],
                      pokemonType: pokemon.types[0].type.name,
                      index: index,
                    );
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: width * 0.15,
                        child: Text( 'Total', style: pokeNixPokemonTypeTextStlye),
                      ),
                      Container(
                        width: width * 0.10,
                        child: Text(
                          pokemonTotalStat( pokemon.stats ),
                          style:
                              pokeNixDescriptionTextStlye.copyWith(color: pokeNixTextGrey, fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                      SizedBox( width: width * 0.45),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.10,
                        child: Text('Max',
                            style: pokeNixDescriptionTextStlye.copyWith(
                                color: pokeNixTextGrey),
                            textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric( vertical: 20),
                    child: Text( pokemonStatAdvertise, style: pokeNixPokemonTypeTextStlye.copyWith(color: pokeNixTextGrey) )
                  ),
                  Text(
                    'Type Defenses',
                    style: pokeNixFilterTitleTextStyle.copyWith(
                        color: typeColor),
                  ),
                  SizedBox( height: 20),
                  Text('The effectiveness of each type on ${toBeginningOfSentenceCase(pokemon.name)}'),
                  SizedBox( height: 20),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        EffectivenessTypesChips(
                          pokemonService: pokemonService,
                        ),
                        SizedBox( height: 10),
                        EffectivenessTypesChips(
                          pokemonService: pokemonService,
                          begin: 9
                        ),
                        SizedBox( height: 20),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : Container();
  }
}

class EffectivenessTypesChips extends StatelessWidget {
  const EffectivenessTypesChips({
    Key key,
    @required this.pokemonService, this.begin = 0,
  }) : super(key: key);

  final PokemonService pokemonService;
  final int begin;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate( 9 , (index) {

        bool hasDoubleDamage = false;
        bool hasHalfDamage = false;
        int position = index + begin;

        String pokemonTypeName = pokemonTypesList[position];
        List<Damage> doubleDamageFrom = pokemonService.pokemonTypeInfo.damageRelations.doubleDamageFrom;
        List<Damage> halfDamageFrom = pokemonService.pokemonTypeInfo.damageRelations.halfDamageFrom;
        
        doubleDamageFrom.forEach(( doubleDamage ) {

          if( doubleDamage.name == pokemonTypeName ) {
            hasDoubleDamage = true;
          }

        });

        halfDamageFrom.forEach(( halfDamage ) {

          if( halfDamage.name == pokemonTypeName ) {
            hasHalfDamage = true;
          }

        });

        return BounceInDown(
          from: 20,
          delay: Duration(milliseconds: (30 * position) + 1 ),
          child: PokemonTypeChip(
            typeName: pokemonTypesList[position],
            doubleDamage: hasDoubleDamage,
            halfDamage: hasHalfDamage,
          ),
        );
      } )
    );
  }
}

class PokemonTypeChip extends StatelessWidget {
  const PokemonTypeChip({
    Key key, @required this.typeName, this.doubleDamage = false, this.halfDamage = false,
  }) : super(key: key);

  final String typeName;
  final bool doubleDamage;
  final bool halfDamage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: getPokemonTypeColor( typeName )),
          child: SvgPicture.asset(
            'assets/images/svg/types/${toBeginningOfSentenceCase(typeName)}.svg',
            color: pokeNixTextWhite,
            height: 18,
          ),
        ),
        if( doubleDamage )
        ...[
          Text('2', style: pokeNixDescriptionTextStlye.copyWith( color: pokeNixTextGrey ))
        ] else if( halfDamage )
        ...[
          Text('½', style: pokeNixDescriptionTextStlye.copyWith( color: pokeNixTextGrey ))
        ] else
        ...[
          Text('', style: pokeNixDescriptionTextStlye.copyWith( color: pokeNixTextGrey ))
        ],
      ],
    );
  }
}

class PokemonStatItem extends StatelessWidget {
  const PokemonStatItem({
    Key key,
    @required this.pokemonType,
    @required this.stat,
    this.index
  }) : super(key: key);

  final String pokemonType;
  final Stat stat;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            child: Text( pokemonStatNameFormated( index ), style: pokeNixPokemonTypeTextStlye),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.10,
            child: Text(
              stat.baseStat.toString(),
              style:
                  pokeNixDescriptionTextStlye.copyWith(color: pokeNixTextGrey),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 10,
            child: LinearPercentIndicator(
              progressColor: getPokemonTypeColor(pokemonType),
              backgroundColor: pokeNixBackgroundDefaultInput,
              percent: pokemonStatPercent( stat.baseStat + stat.effort, pokemonMaxStat( index == 0 ? true : false, stat.baseStat)),
              animation: true,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.10,
            child: Text('${pokemonMaxStat( index == 0 ? true : false, stat.baseStat)}',
                style: pokeNixDescriptionTextStlye.copyWith(
                    color: pokeNixTextGrey),
                textAlign: TextAlign.right),
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
                      description: pokemonSpeciesInfo?.genera[7].genus ?? '',
                    ),
                    PokemoLabelInfo(
                      label: 'Height',
                      description: '${pokemon.height / 10} m.',
                    ),
                    PokemoLabelInfo(
                      label: 'Weight',
                      description: '${pokemon.weight / 10} kg. (${(pokemon.weight / 4.536).toStringAsFixed(2)} lbs)',
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
