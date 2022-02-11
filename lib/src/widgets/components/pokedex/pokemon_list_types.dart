import 'package:flutter/material.dart';
import 'package:pokedex/src/models/pokemon.dart';
import 'package:pokedex/src/models/species.dart';
import 'package:pokedex/src/widgets/components/pokedex/pokemon_type_chip.dart';

class ListTypes extends StatelessWidget {
  const ListTypes({
    Key key,
    @required this.types,
  }) : super(key: key);

  final List<Type> types;

  @override
  Widget build(BuildContext context) {
    return Row(
        children:
            List.generate(types.length, (index) {
              
      final Species type = types[index].type;

      return TypeChip(type: type);
    }));
  }
}