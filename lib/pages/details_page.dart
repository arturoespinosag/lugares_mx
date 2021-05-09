import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:lugares_nav_bar/bloc/places_bloc.dart';

class DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final placesBloc = Provider.of<PlacesBloc>(context);
    final place = placesBloc.currentPlace;
    return Scaffold(
      appBar: AppBar(
        title: Text(place.nombre),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '${place.calle}  ${place.numExterior} int. ${place.numInterior}, Col. ${place.colonia}'),
          Text('Correo electrónico: ${place.correoE}'),
          Text('Centro Comercial: ${place.centroComercial}'),
          Text('Clase de Actividad: ${place.claseActividad}'),
          Text('Estrato: ${place.estrato}'),
          Text('Razón Social: ${place.razonSocial}'),
          Text('Sitio Web: ${place.sitioInternet}'),
          Text('Teléfono: ${place.telefono}'),
          Text('Tipo: ${place.tipo}'),
          Text('Tipo de Centro Comercial: ${place.tipoCentroComercial}'),
          Text('Ubicación: ${place.ubicacion}'),
        ],
      ),
    );
  }
}
