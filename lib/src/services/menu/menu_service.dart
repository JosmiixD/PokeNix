import 'package:flutter/material.dart';

class MenuService with ChangeNotifier {

  int _currentDrawerIndex = 0;

  int get currentDrawerIndex => this._currentDrawerIndex;
  
  set currentDrawerIndex( int index ) {
    this._currentDrawerIndex = index;
    notifyListeners();
  }
  

}