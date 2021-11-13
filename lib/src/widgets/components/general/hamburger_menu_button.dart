import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/src/theme/constants.dart';

class HamburgerMenuButton extends StatelessWidget {
  const HamburgerMenuButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        'assets/images/svg/icons/Menu.svg',
        height: 30,
        color: pokeNixTextBlack,
      ),
      onPressed: () => Scaffold.of(context).openDrawer()
    );
  }
}