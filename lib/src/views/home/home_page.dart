import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/src/models/pokemon.dart';
import 'package:pokedex/src/services/pokemon_service.dart';
import 'package:pokedex/src/theme/constants.dart';
import 'package:pokedex/src/widgets/components/pokemon_item.dart';
import 'package:pokedex/src/widgets/custom_input.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverPersistentHeader(
          delegate: _PokeNixHeader(),
          pinned: true,
        ),
        PokemonList()
      ],
    ));
  }
}

class PokemonList extends StatefulWidget {

  const PokemonList({
    Key key,
  }) : super(key: key);

  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final pokemonService = Provider.of<PokemonService>(context, listen: false);
      await pokemonService.getPokemonData();
    });
  }

  @override
  Widget build(BuildContext context) {

    final pokemonService = Provider.of<PokemonService>(context);

    return SliverToBoxAdapter(
      child: Container(
        child: pokemonService.isLoading
          ? Center( child: CircularProgressIndicator(strokeWidth: 2.5,),)
          : PokemonListView( pokemonService: pokemonService , ),
      ),
    );
  }
}

class PokemonListView extends StatefulWidget {

  const PokemonListView({
    Key key, this.pokemonService,
  }) : super(key: key);

  final PokemonService pokemonService;

  @override
  _PokemonListViewState createState() => _PokemonListViewState();
}

class _PokemonListViewState extends State<PokemonListView> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final List<Pokemon> pokemonItems = widget.pokemonService.pokemon;

    return widget.pokemonService.pokemon.isNotEmpty
      ? ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: pokemonItems.length,
        itemBuilder: (BuildContext context, int index) {
          return PokemonItem(
            pokemon: pokemonItems[index],
          );
        },
      )
      : Center( child: Text('A wild Snorlax blocks our path, no pokemon around'),)
      ;

  }
}

const _maxHeaderExtent = 300.0;
const _minHeaderExtent = 180.0;

class _PokeNixHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
        
        final percent = shrinkOffset/_maxHeaderExtent;
        
        final titleMaxTopMargin = 70.0;
        final titleMinTopMargin = 10.0;

        final searchMaxBottomMargin = 20.0;
        final searchMinBottomMargin = 10.0;

        final titleTopMargin = (titleMaxTopMargin * ( 1 - (percent * 2 ) )).clamp(titleMinTopMargin, titleMaxTopMargin);
        final searchBottomMargin = (searchMaxBottomMargin * ( 1 - percent )).clamp(searchMinBottomMargin, searchMaxBottomMargin);

        print( '$searchBottomMargin $percent' );
        
    return Container(
      color: pokeNixBackgroundWhite,
      child: Stack(
        children: [
          Positioned(
            top: (_maxHeaderExtent / 2) * -1,
            child: SvgPicture.asset(
                'assets/images/svg/patterns/Pokeball.svg',
                fit: BoxFit.cover,
                color: Color(0xffF5F5F5).withOpacity(0.3),
                width: MediaQuery.of(context).size.width,
            ),
          ),
          Positioned(
            top: 5,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                            'assets/images/svg/icons/Generation.svg'),
                        color: pokeNixTextBlack,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon:
                            SvgPicture.asset('assets/images/svg/icons/Sort.svg'),
                        color: pokeNixTextBlack,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                            'assets/images/svg/icons/Filter.svg'),
                        color: pokeNixTextBlack,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: titleTopMargin,
            left: 20,
            right: 20,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pokédex', style: pokeNixApplicationTitleTextStyle,),
                  SizedBox( height: 10,),
                  Opacity(
                    opacity: (1 - (percent * 3.0 )).clamp(0.0, 1),
                    child: Text('Search for Pokémon by name or using the National Pokédex number.', style: pokeNixDescriptionTextStlye,)
                  ),
                ],
          ),
            )),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: pokeNixBackgroundDefaultInput,
                borderRadius: BorderRadius.circular( 10)
              ),
              padding: EdgeInsets.symmetric( vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/svg/icons/Search.svg', color: pokeNixTextGrey,),
                  SizedBox( width: 5,),
                  Text('What Pokémon are you lookin for?', style: pokeNixDescriptionTextStlye.copyWith( color: pokeNixTextGrey), )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => _maxHeaderExtent;

  @override
  double get minExtent => _minHeaderExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
