import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lugares_nav_bar/bloc/places_bloc.dart';
import 'package:provider/provider.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with AutomaticKeepAliveClientMixin {
  String information = '';
  Position _currentPosition;
  int _distance;
  String _selected = 'restaurante';

  @override
  Widget build(BuildContext context) {
    final PlacesBloc placesBloc = Provider.of<PlacesBloc>(context);
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.7, 1],
          colors: [
            Colors.red.withOpacity(0.7),
            Colors.deepPurple.withOpacity(0.6),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _optionsList(context),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shadowColor: Colors.blue,
              ),
              child: Text(
                'Buscar',
                style: TextStyle(color: Colors.white),
              ),
              onLongPress: () {},
              onPressed: () async {
                await getLoc()?.then(
                  (value) {
                    // setState(() {
                    placesBloc.currentPosition = value;
                    _currentPosition = placesBloc.currentPosition;
                    _distance = Geolocator.distanceBetween(
                            _currentPosition.latitude,
                            _currentPosition.longitude,
                            19.29467384875519,
                            -99.1655652327068)
                        .round();
                    information =
                        'Latitud: ${_currentPosition.latitude}\nLongitud: ${_currentPosition.longitude}\n\nDistancia: $_distance';
                    placesBloc.pageController.jumpToPage(1);
                    // });
                  },
                );
              },
            ),
            Container(
              child: Text(information),
            ),
            _sliderDistance(context),
            Text(
              placesBloc.distance.toString(),
            )
          ],
        ),
      ),
    );
  }

  Widget _sliderDistance(BuildContext context) {
    final placesBloc = Provider.of<PlacesBloc>(context);
    double value = placesBloc.distance.toDouble();
    return Slider(
      divisions: 100,
      value: value,
      min: 100,
      max: 1000,
      onChanged: (distance) {
        placesBloc.distance = distance.floor();
        setState(
          () {
            value = distance;
          },
        );
      },
    );
  }

  Future<Position> getLoc() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Si la ubicación no está habilitada
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //si no hay permisos de ubicación, se solicitan
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        //Si se niegan por siempre, no se puede ejecutar y se regreesa error
        return Future.error('Location Permitions have been denied permanently');
      }
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permitions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  bool get wantKeepAlive => true;

  Widget _optionsList(BuildContext context) {
    final placesBloc = Provider.of<PlacesBloc>(context);
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
    return DropdownButton(
      value: _selected,
      items: _list,
      onChanged: (newQuery) {
        placesBloc.query = newQuery;
        setState(() {
            _selected = newQuery;
          },
        );
      },
    );
  }
}
