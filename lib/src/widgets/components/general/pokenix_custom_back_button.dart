import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/src/theme/constants.dart';

class PokenixCustomBackButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        'assets/images/svg/icons/Back.svg',
        height: 40,
        color: pokeNixTextWhite,
      ),
      onPressed: () => Navigator.of(context).pop()
    );
  }
}