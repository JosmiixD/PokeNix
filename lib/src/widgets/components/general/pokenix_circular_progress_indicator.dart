import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PokenixCircularProgressIndicator extends StatelessWidget {
  const PokenixCircularProgressIndicator({
    Key key, this.animate,
  }) : super(key: key);

  final bool animate;

  @override
  Widget build(BuildContext context) {
    return FadeOut(
      animate: animate,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all( 10 ),
        child: Center(
          child: Roulette(
            infinite: true,
            child: SvgPicture.asset(
              'assets/images/svg/patterns/Pokeball.svg',
              height: 20,
            ),
          )
        )
      ),
    );
  }
}