

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:lugares_nav_bar/models/lugares_model.dart';

class LugaresProvider{

  String _token   = 'dd7b6015-41f2-40e3-b97f-aa2b332edd16';
  Future<List<Lugar>> getLugares(String condicion, String ubicacion, String metros) async{

    final url = 'https://www.inegi.org.mx/app/api/denue/v1/consulta/buscar'+'/$condicion'+'/$ubicacion'+'/$metros'+'/$_token';
    // final url ='https://www.inegi.org.mx/app/api/denue/v1/consulta/buscar/restaurante/19.257463808899686,-99.17140684609475/400/dd7b6015-41f2-40e3-b97f-aa2b332edd16';
    final lugares = await _procesarRespuesta(url);
    return lugares;

  

  }

  Future<List<Lugar>> _procesarRespuesta(String url) async{

    // Response respuesta;

  //  try{
  //     final respuesta = await Dio().get(url);
  //  }catch(e){
  //    print(e);
  //  }
  
   final respuesta = await http.get(Uri.parse(url));
   final decodedData = json.decode(respuesta.body);
   final lugares = new Lugares.fromJsonList(decodedData);
   return lugares.items;

 }


}