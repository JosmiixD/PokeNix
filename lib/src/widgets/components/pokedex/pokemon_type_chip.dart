import 'package:flutter/material.dart';

import 'package:pokedex/src/helpers/helpers.dart';
import 'package:pokedex/src/models/pokemon.dart';
import 'package:pokedex/src/theme/constants.dart';

import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';


class TypeChip extends StatelessWidget {
  const TypeChip({
    Key key,
    @required this.type,
  }) : super(key: key);

  final Species type;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 3),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: getPokemonTypeColor(type.name)),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/svg/types/${toBeginningOfSentenceCase(type.name)}.svg',
            color: pokeNixTextWhite,
            height: 18,
          ),
          SizedBox(
            width: 7,
          ),
          Text(
            '${toBeginningOfSentenceCase(type.name)}',
            style: pokeNixPokemonTypeTextStlye.copyWith(
                color: pokeNixTextWhite),
          )
        ],
      ),
    );
  }
}