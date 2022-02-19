import 'package:flutter/material.dart';
import 'package:pokedex/src/routes/routes.dart';
import 'package:pokedex/src/services/history_service.dart';
import 'package:pokedex/src/services/menu/menu_service.dart';
import 'package:pokedex/src/services/pokemon_service.dart';
import 'package:pokedex/src/theme/constants.dart';
import 'package:provider/provider.dart';

void main() => runApp( MyApp() );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => MenuService(), ),
        ChangeNotifierProvider(create: (BuildContext context) => PokemonService(), ),
        ChangeNotifierProvider(create: (BuildContext context) => HistoryService(), ),
      ],
      child: MaterialApp(
        title: 'PokeNix - A Complete Pokedex',
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: appRoutes,
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: pokeNixBackgroundWhite,
          textTheme: ThemeData.light()
            .textTheme
            .apply(
              fontFamily: 'SFProDisplay'
            ),
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white
          )
        ),
      ),
    );
  }
}