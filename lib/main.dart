import 'package:flutter/material.dart';
import 'package:pokedex/src/routes/routes.dart';
import 'package:pokedex/src/services/pokemon_service.dart';
import 'package:pokedex/src/theme/constants.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => PokemonService(), ),
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
            )
        ),
      ),
    );
  }
}