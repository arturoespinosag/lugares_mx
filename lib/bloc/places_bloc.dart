import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lugares_nav_bar/models/place_model.dart';

class PlacesBloc extends ChangeNotifier{
  Position _currentPosition;
  Place _currentPlace = Place(id: 'zocalo',latitud: '19.432366683023716', longitud: '-99.13323364074559'); 
  PageController pageController;
  List<Place> _places = [];
  bool isAlive = true;
  String _query = 'restaurante';
  int _distance = 650;
  

  Position get currentPosition => _currentPosition;

  Place get currentPlace => _currentPlace;

  List get places => _places;

  String get query => _query;

  int get distance => _distance;


  set currentPosition (Position value){
    _currentPosition = value;
    notifyListeners();
  }

  set currentPlace (Place  value){
    _currentPlace = value;
    notifyListeners();
  }

  set places (List  value){
    _places = value;
    notifyListeners();
  }

  set query (String  value){
    _query = value;
    notifyListeners();
  }

  set distance (int  value){
    _distance = value;
    notifyListeners();
  }

  

}