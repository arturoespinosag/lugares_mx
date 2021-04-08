import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lugares_nav_bar/models/lugares_model.dart';

class LugaresBloc extends ChangeNotifier{
  Position _currentPosition;
  Lugar _currentPlace = Lugar(latitud: '19.432366683023716', longitud: '-99.13323364074559'); 
  PageController pageController;
  List<Lugar> _lugares = [];
  bool isAlive = true;

  Position get currentPosition => _currentPosition;

  Lugar get currentPlace => _currentPlace;

  List get lugares => _lugares;


  set currentPosition (Position value){
    _currentPosition = value;
    notifyListeners();
  }

  set currentPlace (Lugar  value){
    _currentPlace = value;
    notifyListeners();
  }

  set lugares (List  value){
    _lugares = value;
    notifyListeners();
  }

  

}