import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lugares_nav_bar/bloc/lugares_bloc.dart';
import 'package:provider/provider.dart';



class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with AutomaticKeepAliveClientMixin{
  String information = '';
  Position _currentPosition;
  int _distance;
  String _selected = 'restaurante';

  @override
  Widget build(BuildContext context) {
    final LugaresBloc lugaresBloc = Provider.of<LugaresBloc>(context);
    super.build(context);
    return Container(
      color: Colors.redAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _listaOpciones(context),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  animationDuration: Duration(milliseconds: 300),
                  elevation: 5,
                  shadowColor: Colors.blue,
                ),
                child: Text('Buscar', style: TextStyle(color: Colors.white)),
                onLongPress: (){},
                onPressed: () async{
                  lugaresBloc.isAlive = false;
                  updateKeepAlive();
                  await Future.delayed(Duration(milliseconds: 500));
                  await getLoc()?.then((value) {
                    setState(() {
                      lugaresBloc.currentPosition = value;
                      _currentPosition = lugaresBloc.currentPosition;
                      _distance = Geolocator.distanceBetween(_currentPosition.latitude, _currentPosition.longitude, 19.29467384875519, -99.1655652327068).round();
                      information = 'Latitud: ${_currentPosition.latitude}\nLongitud: ${_currentPosition.longitude}\n\nDistancia: $_distance';
                      lugaresBloc.pageController.jumpToPage(1);
                    });
                  });
                }
              ),
              Container(
                child: Text(information)
              ),
              _sliderDistance(context),
              Text(lugaresBloc.distancia.toString())
            ],
          ),          
        ),
    );
  }

  Widget _sliderDistance(BuildContext context){
    final lugaresBloc = Provider.of<LugaresBloc>(context);
    double value = lugaresBloc.distancia.toDouble();
    return Slider(
      divisions: 100,

      value: value,
      min: 100,
      max: 1000,
      onChanged: (distance){
        lugaresBloc.distancia = distance.floor();
        setState(() {
          value = distance;
        });
      }
    );
  }

  Future<Position> getLoc() async{

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){ // Si la ubicación no está habilitada
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){//si no hay permisos de ubicación, se solicitan
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.deniedForever){//Si se niegan por siempre, no se puede ejecutar y se regreesa error
        return Future.error('Location Permitions have been denied permanently');
      }
      if(permission == LocationPermission.denied){
        return Future.error('Location Permitions are denied');
      }

      
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  bool get wantKeepAlive => true;

  Widget _listaOpciones(BuildContext context) {
    final lugaresBloc = Provider.of<LugaresBloc>(context);
    List<String> _options = ['restaurante', 'gasolineria', 'hospital', 'hotel', 'escuela', 'papeleria', 'mercado'];
    List<DropdownMenuItem<String>> _lista = [];
    _options.forEach((queryOp) { 
      _lista.add(DropdownMenuItem(
        child: Text(queryOp),
        value: queryOp,
      ));
    });
    return DropdownButton(
      value: _selected,
      items: _lista,
      onChanged: (newQuery){
        lugaresBloc.query = newQuery;
        setState(() {
          _selected = newQuery;
        });
      },
    );
  }
}

