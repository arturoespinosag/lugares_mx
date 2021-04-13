import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:lugares_nav_bar/bloc/lugares_bloc.dart';

class DetallesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lugaresBloc = Provider.of<LugaresBloc>(context);
    final lugar = lugaresBloc.currentPlace;
    return Scaffold(
      appBar: AppBar(
        title: Text(lugar.nombre),
      ),
      body: Column(
        children: [
          Center(
            child: Text('${lugar.calle}  ${lugar.numExterior} int. ${lugar.numInterior}, Col. ${lugar.colonia}'), 
          ),
          Text('Correo electrónico: ${lugar.correoE}'),
          Text('Centro Comercial: ${lugar.centroComercial}'),
          Text('Clase de Actividad: ${lugar.claseActividad}'),
          Text('Estrato: ${lugar.estrato}'),
          Text('Razón Social: ${lugar.razonSocial}'),
          Text('Sitio Web: ${lugar.sitioInternet}'),
          Text('Teléfono: ${lugar.telefono}'),
          Text('Tipo: ${lugar.tipo}'),
          Text('Tipo de Centro Comercial: ${lugar.tipoCentroComercial}'),
          Text('Ubicación: ${lugar.ubicacion}'),
        ],
      ),
      
    );
  }
}