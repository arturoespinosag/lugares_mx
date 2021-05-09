import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lugares_nav_bar/bloc/places_bloc.dart';
import 'package:lugares_nav_bar/models/place_model.dart';
import 'package:lugares_nav_bar/providers/lugares_provider.dart';
import 'package:provider/provider.dart';

final placesProvider = PlacesProvider();

class ResultadosWidget extends StatefulWidget {
  @override
  _ResultadosWidgetState createState() => _ResultadosWidgetState();
}

class _ResultadosWidgetState extends State<ResultadosWidget>
    with AutomaticKeepAliveClientMixin {
  List<Place> places1;
  String _selected = 'restaurante';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    PlacesBloc placesBloc = Provider.of<PlacesBloc>(context);
    Position _currentPosition = placesBloc.currentPosition;
    String _query = placesBloc.query;
    int _distance = placesBloc.distance;
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _optionsList(context),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.purpleAccent.withOpacity(0.7),
                  Colors.deepPurple.withOpacity(0.7),
                ],
              ),
            ),
            height: size.height * 0.815,
            width: size.width,   
            child: (_currentPosition == null)
                ? Center(
                    child: Text(
                    'No hay resultados',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ))
                : _placesList(_currentPosition, _query, _distance, context),
          ),
        ],
      ),
    );
  }

  Widget _placesList(Position currentPosition, String query, int distance,
      BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: placesProvider.getLugares(
            query,
            '${currentPosition.latitude.toString()},${currentPosition.longitude.toString()}',
            '$distance'),
        // future: lugaresProvider.getLugares('restaurante', '19.286314,-99.167673', '1000'),
        builder: (BuildContext context, AsyncSnapshot<List<Place>> snapshot) {
          List<Place> places = snapshot.data;
          places1 = places;
          if (snapshot.hasData) {
            if (snapshot.data[0].id == "No hay resultados.") {
              return Center(
                child: Text(
                  'No hay resultados',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              );
            } else
              return Container(
                child: Center(
                    child: ListView.builder(
                        itemCount: places.length,
                        itemBuilder: (context, index) {
                          return _placeCard(
                              places[index], index, context, currentPosition);
                        })),
              );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _placeCard(
      Place place, int index, BuildContext context, Position currentPosition) {
    PlacesBloc _placesBloc = Provider.of<PlacesBloc>(context);
    Color color = (index % 2 == 0)
        // ? Color.fromRGBO(186, 223, 251, 1.0)
        // : Color.fromRGBO(100, 181, 246, 1.0);
        ? Colors.white38
        : Colors.white70;
    return Card(
        color: color,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomRight: Radius.elliptical(30.0, 30.0)),
        ),
        child: ExpansionTile(
          leading: Icon(Icons.map),
          title: Text(' ${place.nombre}'),
          subtitle: Text(
              '${place.colonia}\n A ${Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, double.parse(place.latitud), double.parse(place.longitud)).round().toString()} metros'),
          children: [
            Text(
                "${place.tipoVialidad} ${place.calle} ${place.numExterior} ${place.numInterior}, ${place.colonia}, ${place.ubicacion}"),
            Text("${place.telefono}"),
            TextButton(
                onPressed: () async {
                  _placesBloc.isAlive = false;
                  updateKeepAlive();
                  await Future.delayed(Duration(milliseconds: 1000));
                  _placesBloc.places = places1;
                  _placesBloc.currentPlace = place;
                  _placesBloc.pageController.jumpToPage(2);
                },
                child: Text("Ver en mapa"))
          ],
        ));
  }

  Widget _optionsList(BuildContext context) {
    final lugaresBloc = Provider.of<PlacesBloc>(context);
    List<String> _options = [
      'restaurante',
      'gasolineria',
      'hospital',
      'hotel',
      'escuela',
      'papeleria',
      'mercado',
      'autolavado'
    ];
    List<DropdownMenuItem<String>> _list = [];
    _options.forEach(
      (queryOp) {
        _list.add(
          DropdownMenuItem(
            child: Text(queryOp),
            value: queryOp,
          ),
        );
      },
    );
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.purpleAccent.withOpacity(0.7),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: _selected,
          items: _list,
          onChanged: (newQuery) {
            lugaresBloc.query = newQuery;
            setState(
              () {
                _selected = newQuery;
              },
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
