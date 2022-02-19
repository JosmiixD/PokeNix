import 'package:flutter/material.dart';
import 'package:pokedex/src/widgets/components/general/hamburger_menu_button.dart';
import 'package:pokedex/src/widgets/components/general/pokenix_navigation_drawer.dart';


class MovementsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PokenixNavigationDrawer(),
      appBar: AppBar(
        leading: HamburgerMenuButton(),
      ),
      body: Center(
        child: Text('Hola movements'),
     ),
   );
  }
}