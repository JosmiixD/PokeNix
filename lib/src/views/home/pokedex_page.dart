import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/src/services/pokemon_service.dart';
import 'package:pokedex/src/theme/constants.dart';
import 'package:pokedex/src/widgets/components/general/hamburger_menu_button.dart';
import 'package:pokedex/src/widgets/components/pokedex/pokemon_list.dart';
import 'package:pokedex/src/widgets/components/general/pokenix_navigation_drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    final pokemonService =
          Provider.of<PokemonService>(context, listen: false);

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 400 &&
          !pokemonService.isLoading) {
        pokemonService.getPokemonData();
        print('Gettin new pokemon');
        }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    print("Dispose scrollcontroller");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final pokemonService = Provider.of<PokemonService>(context);

    

    return Scaffold(
        drawer: ClientNavigationDrawer(),
        body: CustomScrollView(
          controller: scrollController,
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

const _maxHeaderExtent = 300.0;
const _minHeaderExtent = 180.0;

class _PokeNixHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / _maxHeaderExtent;

    final titleMaxTopMargin = 70.0;
    final titleMinTopMargin = 10.0;

    final titleMaxLeftMargin = 50.0;
    final titleMinLeftMargin = 20.0;

    final titleTopMargin = (titleMaxTopMargin * (1 - (percent * 2)))
        .clamp(titleMinTopMargin, titleMaxTopMargin);

    final titleLeftMargin = (titleMaxLeftMargin * (percent * 2.4))
        .clamp(titleMinLeftMargin, titleMaxLeftMargin);

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
            right: 8,
            left: 8,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HamburgerMenuButton(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                            'assets/images/svg/icons/Generation.svg'),
                        color: pokeNixTextBlack,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                            'assets/images/svg/icons/Sort.svg'),
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
                  )
                ],
              ),
            ),
          ),
          Positioned(
              top: titleTopMargin,
              left: titleLeftMargin,
              right: 20,
              child: SafeArea(
                child: Text(
                  'Pokédex',
                  style: pokeNixApplicationTitleTextStyle,
                ),
              )),
          Positioned(
              top: titleTopMargin + 40,
              left: 20,
              right: 20,
              child: SafeArea(
                child: Opacity(
                    opacity: (1 - (percent * 3.0)).clamp(0.0, 1),
                    child: Text(
                      'Search for Pokémon by name or using the National Pokédex number.',
                      style: pokeNixDescriptionTextStlye,
                    )),
              )),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                  color: pokeNixBackgroundDefaultInput,
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/svg/icons/Search.svg',
                    color: pokeNixTextGrey,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'What Pokémon are you lookin for?',
                    style: pokeNixDescriptionTextStlye.copyWith(
                        color: pokeNixTextGrey),
                  )
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
