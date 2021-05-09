

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:lugares_nav_bar/models/place_model.dart';

class PlacesProvider{

  String _token   = 'dd7b6015-41f2-40e3-b97f-aa2b332edd16';
  Future<List<Place>> getLugares(String condition, String position, String meters) async{

    final url = 'https://www.inegi.org.mx/app/api/denue/v1/consulta/buscar'+'/$condition'+'/$position'+'/$meters'+'/$_token';
    // final url ='https://www.inegi.org.mx/app/api/denue/v1/consulta/buscar/restaurante/19.257463808899686,-99.17140684609475/400/dd7b6015-41f2-40e3-b97f-aa2b332edd16';
    final places = await _procesarRespuesta(url);
    return places;

  

  }

  Future<List<Place>> _procesarRespuesta(String url) async{

    // Response respuesta;

  //  try{
  //     final respuesta = await Dio().get(url);
  //  }catch(e){
  //    print(e);
  //  }
  
   final response = await http.get(Uri.parse(url));
   final decodedData = json.decode(response.body);
   Place _place = new Place(id: "No hay resultados.");
   List<Place> noResults = [_place];
   if(decodedData == "No hay resultados."){
     return noResults;
   }else{
     final places = new Places.fromJsonList(decodedData);
     return places.items;
   }

 }


}