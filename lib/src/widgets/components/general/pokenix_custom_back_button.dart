import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/src/theme/constants.dart';

class PokenixCustomBackButton extends StatelessWidget {

  final Color color;
  final double height;
  final VoidCallback onPressed;

  const PokenixCustomBackButton({Key key, this.color = pokeNixTextWhite, this.height = 20, this.onPressed }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        'assets/images/svg/icons/Back.svg',
        color: this.color,
        height: this.height,
      ),
      onPressed: this.onPressed != null ? this.onPressed : () => Navigator.of(context).pop()
    );
  }
}