import 'package:flutter/material.dart';
import 'package:pokedex/src/views/home/pokedex_page.dart';

final Map<String, Widget Function( BuildContext )> appRoutes = {
  'home'        : ( _ ) => HomePage(),

};