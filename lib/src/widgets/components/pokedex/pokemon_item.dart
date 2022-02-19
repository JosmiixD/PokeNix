import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/src/helpers/helpers.dart';
import 'package:pokedex/src/models/pokemon.dart';
import 'package:pokedex/src/theme/constants.dart';
import 'package:intl/intl.dart';
import 'package:pokedex/src/views/home/pokemon_details_page.dart';
import 'package:pokedex/src/widgets/components/pokedex/pokemon_image.dart';
import 'package:pokedex/src/widgets/components/pokedex/pokemon_list_types.dart';

class PokemonItem extends StatelessWidget {
  const PokemonItem({
    Key key,
    @required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Color color = getPokemonTypeBackgroundColor( pokemon.types[0].type.name );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (_) => PokemonDetailsPage(pokemon: pokemon)));
      },
      child: Container(
        height: size.height * 0.21,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Stack(
                  children: [
                    Container(
                      height: size.height * 0.17,
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                              color: color.withOpacity(0.5),
                              offset:  Offset(0, 7.0)
                            )
                          ]
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -50,
                            top: -20,
                            child: SvgPicture.asset(
                              'assets/images/svg/patterns/Pokeball.svg',
                              color: Colors.white.withOpacity(0.10),
                              height: size.height * 0.25,
                            ),
                          ),
                          Positioned(
                            left: size.width * 0.15,
                            top: 5,
                            child: SvgPicture.asset(
                              'assets/images/svg/patterns/6x3.svg',
                              color: Colors.white.withOpacity(0.10),
                              height: size.height * 0.07,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              top: 20,
              child: Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${(pokemon.id).toString().padLeft(3, '0')}',
                          style: pokeNixPokemonNumberTextStlye.copyWith(
                              color: pokeNixTextNumber),
                        ),
                        Text(
                          '${toBeginningOfSentenceCase(pokemon.name)}',
                          style: pokeNixPokemonNameTextStyle.copyWith(
                              color: pokeNixTextWhite),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTypes(types: pokemon.types)
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 0,
              child: FadeIn(child: PokemonImage(pokemon: pokemon)),
            )
          ],
        ),
      ),
    );
  }
}
