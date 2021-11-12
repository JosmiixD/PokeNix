import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/src/helpers/helpers.dart';
import 'package:pokedex/src/models/pokemon.dart';
import 'package:pokedex/src/theme/constants.dart';
import 'package:intl/intl.dart';

class PokemonItem extends StatelessWidget {
  const PokemonItem({
    Key key,
    @required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
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
                        color: getPokemonTypeBackgroundColor( pokemon.types[0].type.name),
                        borderRadius: BorderRadius.circular(10)),
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
              padding: EdgeInsets.only( left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('#${(pokemon.id).toString().padLeft(3, '0')}' ,style: pokeNixPokemonNumberTextStlye.copyWith( color: pokeNixTextNumber),),
                      Text('${toBeginningOfSentenceCase(pokemon.name)}', style: pokeNixPokemonNameTextStyle.copyWith( color: pokeNixTextWhite),),
                      SizedBox( height: 10,),
                      Row(
                        children: List.generate(pokemon.types.length, (index) {
                          
                          final Species type = pokemon.types[index].type;

                          return Container(
                            margin: EdgeInsets.only( right: 3),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: getPokemonTypeColor( type.name )
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/images/svg/types/${toBeginningOfSentenceCase(type.name)}.svg', color: pokeNixTextWhite, height: 18,),
                                SizedBox( width: 7,),
                                Text('${toBeginningOfSentenceCase(type.name)}', style: pokeNixPokemonTypeTextStlye.copyWith( color: pokeNixTextWhite),)
                              ],
                            ),
                          );
                        })
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
              right: 10,
              top: 0,
              child: FadeInImage(
                placeholder: AssetImage('assets/images/gif/loading.gif'),
                image: NetworkImage(
                  '${pokemon.sprites.other.officialArtwork.frontDefault}',
                ),
                height: size.height * 0.20,
                fit: BoxFit.cover,
              )
          )
        ],
      ),
    );
  }
}
