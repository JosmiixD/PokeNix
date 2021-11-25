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

class PokemonHeader extends StatelessWidget {
  const PokemonHeader({
    Key key,
    @required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.30,
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
            right: -20,
            top: 180,
            child: SvgPicture.asset(
              'assets/images/svg/patterns/10x5.svg',
              color: Colors.white.withOpacity(0.10),
              height: size.height * 0.07,
            ),
          ),
          Column(
            children: [
              SafeArea(
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
              Padding(
                padding: const EdgeInsets.symmetric( horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Hero(
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
                        fit: BoxFit.cover,
                        height: 150,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox( height: 5,),
                        Text(
                          '#${(pokemon.id).toString().padLeft(3, '0')}',
                          style: pokeNixPokemonNumberTextStlye.copyWith(
                              color: pokeNixTextWhite),
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
                  ],
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}