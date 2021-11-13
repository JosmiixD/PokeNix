import 'package:flutter/material.dart';
import 'package:pokedex/src/views/home/pokedex_page.dart';
import 'package:pokedex/src/widgets/components/pokedex/pokemon_item.dart';

final Map<String, Widget Function( BuildContext )> appRoutes = {
  'home'        : ( _ ) => HomePage(),

};