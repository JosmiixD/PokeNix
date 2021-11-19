import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/src/theme/constants.dart';
import 'package:shimmer/shimmer.dart';

class PokemonShimmerList extends StatelessWidget {
  const PokemonShimmerList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return FadeIn(
          delay: Duration( milliseconds: ( index * 2 ) * 100 ),
          child: Shimmer.fromColors(
            baseColor: pokeNixShimmerBaseColor,
            highlightColor: pokeNixShimmerHighlightColor,
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
                              color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  
      },
    );
  }
}