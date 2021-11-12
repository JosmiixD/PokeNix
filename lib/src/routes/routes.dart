import 'package:flutter/material.dart';
import 'package:pokedex/src/views/home/home_page.dart';
import 'package:pokedex/src/widgets/components/pokemon_item.dart';

final Map<String, Widget Function( BuildContext )> appRoutes = {
  'home'        : ( _ ) => HomePage(),

};