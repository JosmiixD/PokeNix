import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/src/models/pokemon.dart';
import 'package:pokedex/src/theme/constants.dart';
import 'package:shimmer/shimmer.dart';

class PokemonImage extends StatelessWidget {
  const PokemonImage({
    Key key,
    @required this.pokemon,
    this.height,
    this.width,
  }) : super(key: key);

  final Pokemon pokemon;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Hero(
      tag: pokemon.id,
      child: (pokemon.sprites.other.dreamWorld.frontDefault != null )
        ? Container(
          width: this.width != null ? this.width : size.width * 0.40,
          child: SvgPicture.asset(
            'assets/images/svg/pokemon/${pokemon.id}.svg',
            height: this.height != null ? this.height :size.height * 0.20,
            fit: BoxFit.scaleDown,
          ),
        )
        : CachedNetworkImage(
          key: UniqueKey(),
          imageUrl: '${pokemon.sprites.other.officialArtwork.frontDefault}',
          placeholder: (_, __) => Shimmer.fromColors(
            child: Image.asset('assets/images/png/25.png'), 
            baseColor: pokeNixShimmerBaseColor, 
            highlightColor: pokeNixShimmerHighlightColor
          ),
          height: size.height * 0.20,
          fit: BoxFit.cover,
        )
    );
  }
}