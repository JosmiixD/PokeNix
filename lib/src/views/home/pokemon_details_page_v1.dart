import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pokedex/src/helpers/helpers.dart';
import 'package:pokedex/src/models/pokemon.dart';
import 'package:pokedex/src/theme/constants.dart';
import 'package:pokedex/src/widgets/components/general/pokenix_custom_back_button.dart';
import 'package:pokedex/src/widgets/components/pokedex/pokemon_list_types.dart';
import 'package:shimmer/shimmer.dart';

class PokemonDetailPagev1 extends StatelessWidget {
  const PokemonDetailPagev1({Key key, @required this.pokemon}) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              delegate: _PokemonDetailsHeader(pokemon: pokemon),
              pinned: true,
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top : 10),
                    child: Text('Tab 1'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top : 20),
                    child: Text('Tab2'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top : 20),
                    child: Text('Tab3'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


const _maxHeaderExtent = 550.0;
const _minHeaderExtent = 200.0;

class _PokemonDetailsHeader extends SliverPersistentHeaderDelegate {
  final Pokemon pokemon;

  _PokemonDetailsHeader({@required this.pokemon});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    
    final percent = shrinkOffset / _maxHeaderExtent;
    final size = MediaQuery.of(context).size;

    final pokemonNameMaxTopMargin = 70.0;
    final pokemonNameMinTopMargin = 35.0;

    final pokemonImageMaxHeight = size.height * 0.47;
    final pokemonImageMinHeight = 150.0;

    final pokemonImageMaxTopMargin = 150.0;
    final pokemonImageMinTopMargin = 35.0;

    final pokemonImageMinLeftMargin = 5.0;
    final pokemonImageMaxLeftMargin = 250.0;

    final pokemonNameTopMargin = ( pokemonNameMaxTopMargin * ( 1 - percent )).clamp( pokemonNameMinTopMargin, pokemonNameMaxTopMargin);
    final pokemonIdOpacity = (1 - ( percent * 3.0 )).clamp(0.0, 1.0);
    final pokemonImageHeight = ( pokemonImageMaxHeight * ( 1 - percent )).clamp(pokemonImageMinHeight, pokemonImageMaxHeight);
    final pokemonImageTopMargin = ( pokemonImageMaxTopMargin * ( 1 - percent )).clamp(pokemonImageMinTopMargin, pokemonImageMaxTopMargin);
    final pokemonImageLeftMargin = ( pokemonImageMaxLeftMargin * ( percent * 1.6 )).clamp(pokemonImageMinLeftMargin, pokemonImageMaxLeftMargin);
      
    return Container(
      color: getPokemonTypeBackgroundColor(pokemon.types[0].type.name),
      child: Stack(
        children: [
          Positioned(
            left: -80,
            right: -80,
            top: 30,
            child: Container(
              height: 130,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Text(pokemon.name.toUpperCase(),
                textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 130,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1
                      ..color = Colors.white.withOpacity(0.2)
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              )
            ),
          ),
          Positioned(
            top: 5,
            left: 10,
            right: 10,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PokenixCustomBackButton(),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/svg/icons/Heart_Empty.svg',
                      color: pokeNixTextWhite,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: -20,
            top: 120,
            child: Opacity(
              opacity: 1 - pokemonIdOpacity,
              child: SvgPicture.asset(
                'assets/images/svg/patterns/6x3.svg',
                color: Colors.white.withOpacity(0.10),
                height: size.height * 0.07,
              ),
            ),
          ),
          Positioned(
              top: pokemonNameTopMargin,
              left: 20,
              right: 20,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: pokemonIdOpacity,
                      child: Text(
                        '#${(pokemon.id).toString().padLeft(3, '0')}',
                        style: pokeNixPokemonNumberTextStlye.copyWith(
                            color: pokeNixTextWhite),
                      ),
                    ),
                    SizedBox( height: 5,),
                    Text(
                      '${toBeginningOfSentenceCase(pokemon.name)}',
                      style: pokeNixApplicationTitleTextStyle.copyWith(
                          color: pokeNixTextWhite),
                    ),
                    SizedBox( height: 5,),
                    ListTypes(types: pokemon.types)
                  ],
                ),
              )),
          Positioned(
              top: pokemonImageTopMargin,
              left: pokemonImageLeftMargin,
              height: pokemonImageHeight,
              child: SafeArea(
                child: Hero(
                  tag: pokemon.id,
                  child: CachedNetworkImage(
                    key: UniqueKey(),
                    imageUrl:
                        '${pokemon.sprites.other.officialArtwork.frontDefault}',
                    placeholder: (_, __) {
                      return Shimmer.fromColors(
                        baseColor: pokeNixShimmerBaseColor,
                        highlightColor: pokeNixShimmerHighlightColor,
                        child: Image.asset('assets/images/png/25.png'),
                      );
                    },
                    // height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              )),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              child: TabBar(
                indicatorColor: Colors.transparent,
                // physics: BouncingScrollPhysics(),
                tabs: [
                  Tab(
                    icon: Text('About')
                  ),
                  Tab(
                    icon: Text('Stats')
                  ),
                  Tab(
                    icon: Text('Evolution')
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => _maxHeaderExtent;

  @override
  double get minExtent => _minHeaderExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
