import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lugares_nav_bar/models/lugares_model.dart';

class LugaresBloc extends ChangeNotifier{
  Position _currentPosition;
  Lugar _currentPlace = Lugar(id: 'zocalo',latitud: '19.432366683023716', longitud: '-99.13323364074559'); 
  PageController pageController;
  List<Lugar> _lugares = [];
  bool isAlive = true;
  String _query = 'restaurante';
  int _distancia = 650;

  Position get currentPosition => _currentPosition;

  Lugar get currentPlace => _currentPlace;

  List get lugares => _lugares;

  String get query => _query;

  int get distancia => _distancia;


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

  set query (String  value){
    _query = value;
    notifyListeners();
  }

  set distancia (int  value){
    _distancia = value;
    notifyListeners();
  }

  

}