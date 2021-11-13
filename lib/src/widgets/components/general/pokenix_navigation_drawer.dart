import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pokedex/src/theme/constants.dart';

class ClientNavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

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
            onTap: (){}
          ),
          SizedBox( height: 10,),
          buildPokeNixMenuTile(
            label: 'Movements',
            svgName: 'Movements',
            onTap: (){}
          ),
          SizedBox( height: 10,),
          buildPokeNixMenuTile(
            label: 'Habilities',
            svgName: 'Habilities',
            onTap: (){}
          ),
          SizedBox( height: 10,),
          buildPokeNixMenuTile(
            label: 'Items',
            svgName: 'Items',
            onTap: (){}
          ),
          SizedBox( height: 10,),
          buildPokeNixMenuTile(
            label: 'Locations',
            svgName: 'Locations',
            onTap: (){}
          ),
        ],
      ))),
    );
  }

  ListTile buildPokeNixMenuTile({
    @required String label,
    @required String svgName,
    @required VoidCallback onTap,
  }) {
    return ListTile(
          contentPadding: EdgeInsets.symmetric( horizontal: 20),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgPicture.asset(
                'assets/images/svg/icons/$svgName.svg',
                color: pokeNixTextBlack,
              ),
              SizedBox(
                width: 10,
              ),
              Text( '$label',
                  style:pokeNixDescriptionTextStlye),
            ],
          ),
          onTap: (){},
        );
  }


  Widget buildMenuItem( {
    @required String title,
    @required IconData icon,
    @required VoidCallback onTap,
    double iconSize = 20,
  }) {

    return ListTile(
      contentPadding: EdgeInsets.symmetric( horizontal: 20),
      title: Row(
        children: [
          FaIcon(
            icon,
            size: iconSize,
          ),
          SizedBox(
            width: 10,
          ),
          Text( title,
              style:
                  TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
        ],
      ),
      onTap: onTap,
    );
  }

  void selectedItem( BuildContext context, int index ) {

    Navigator.of(context).pop();

    switch ( index ) {
      case 0:
        // Navigator.of(context).push(CupertinoPageRoute(
        //   builder: ( context ) => ClientOrdersPage()
        // ));
        break;
      case 1:
        // Navigator.of(context).push(CupertinoPageRoute(
        //   builder: ( context ) => ClientWalletPage()
        // ));
        break;
      case 2:
        // Navigator.of(context).push(CupertinoPageRoute(
        //   builder: ( context ) => ClientMessagesPage()
        // ));
        break;
      case 3:
        // Navigator.of(context).push(CupertinoPageRoute(
        //   builder: ( context ) => AccountSettingsPage()
        // ));
        break;
      case 4:
        // Navigator.of(context).push(CupertinoPageRoute(
        //   builder: ( context ) => RegisterMyRestaurant()
        // ));
        break;
      case 5:
        // Navigator.of(context).pushNamedAndRemoveUntil('roles', (route) => false);
        break;

    }

  }
}
