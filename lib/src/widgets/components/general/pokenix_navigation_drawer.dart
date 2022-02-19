import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/src/services/menu/menu_service.dart';
import 'package:pokedex/src/theme/constants.dart';
import 'package:pokedex/src/views/habilities/habilities_page.dart';
import 'package:pokedex/src/views/home/pokedex_page.dart';
import 'package:pokedex/src/views/items/items_page.dart';
import 'package:pokedex/src/views/locations/locations_page.dart';
import 'package:pokedex/src/views/movements/movements_page.dart';
import 'package:provider/provider.dart';

class PokenixNavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    final menuService = Provider.of<MenuService>(context);

    return Container(
      width: size.width * 0.55,
      child: Drawer(
          child: Material(
              child: ListView(
        // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: <Widget>[
          SizedBox( height: 30,),
          Padding(
            padding: EdgeInsets.only( left: 20),
            child: Row(
              children: [
                Text('P', style: pokeNixApplicationTitleTextStyle,),
                SizedBox( width: 2,),
                Padding(
                  padding: const EdgeInsets.only( top: 3.0),
                  child: SvgPicture.asset(
                    'assets/images/svg/patterns/Pokeball.svg',
                    height: 20,
                    color: pokeNixTextBlack,
                  ),
                ),
                SizedBox( width: 2,),
                Text('kenix', style: pokeNixApplicationTitleTextStyle,)
              ],
            ),
          ),
          SizedBox( height: 20,),
          buildPokeNixMenuTile(
            label: 'Pokédex',
            svgName: 'Pokedex',
            isSelected: menuService.currentDrawerIndex == 0,
            onTap: () {
              if( menuService.currentDrawerIndex == 0  ) return;
              menuService.currentDrawerIndex = 0;
              selectedItem( context, 0);
            }
          ),
          SizedBox( height: 10,),
          buildPokeNixMenuTile(
            label: 'Movements',
            svgName: 'Movements',
            isSelected: menuService.currentDrawerIndex == 1,
            onTap: () {
              if( menuService.currentDrawerIndex == 1  ) return;
              menuService.currentDrawerIndex = 1;
              selectedItem( context, 1);
            }
          ),
          SizedBox( height: 10,),
          buildPokeNixMenuTile(
            label: 'Habilities',
            svgName: 'Habilities',
            isSelected: menuService.currentDrawerIndex == 2,
            onTap: () {
              if( menuService.currentDrawerIndex == 2  ) return;
              menuService.currentDrawerIndex = 2;
              selectedItem( context, 2);
            }
          ),
          SizedBox( height: 10,),
          buildPokeNixMenuTile(
            label: 'Items',
            svgName: 'Items',
            isSelected: menuService.currentDrawerIndex == 3,
            onTap: () {
              if( menuService.currentDrawerIndex == 3  ) return;
              menuService.currentDrawerIndex = 3;
              selectedItem( context, 3);
            }
          ),
          SizedBox( height: 10,),
          buildPokeNixMenuTile(
            label: 'Locations',
            svgName: 'Locations',
            isSelected: menuService.currentDrawerIndex == 4,
            onTap: () {
              if( menuService.currentDrawerIndex == 4  ) return;
              menuService.currentDrawerIndex = 4;
              selectedItem( context, 4);
            }
          ),
        ],
      ))),
    );
  }

  ListTile buildPokeNixMenuTile({
    @required String label,
    @required String svgName,
    @required bool isSelected,
    @required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric( horizontal: 20),
      selected: isSelected,
      selectedTileColor: pokeNixBackgroundDefaultInput,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SvgPicture.asset(
            'assets/images/svg/icons/$svgName.svg',
            color: isSelected ? pokeNixTypePsychicBackgroundColor : pokeNixTextBlack,
          ),
          SizedBox(
            width: 10,
          ),
          Text( '$label',
              style:pokeNixDescriptionTextStlye.copyWith(
                color: isSelected ? pokeNixTypePsychicBackgroundColor : pokeNixTextBlack
              )),
        ],
      ),
      onTap: onTap,
    );
  }


  void selectedItem( BuildContext context, int index ) {

    Navigator.of(context).pop();

    switch ( index ) {
      case 0:
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: ( context ) => HomePage()
        ));
        break;
      case 1:
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: ( context ) => MovementsPage()
        ));
        break;
      case 2:
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: ( context ) => HabilitiesPage()
        ));
        break;
      case 3:
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: ( context ) => ItemsPage()
        ));
        break;
      case 4:
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: ( context ) => LocationsPage()
        ));
        break;

    }

  }
}
