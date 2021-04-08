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
              ElevatedButton(
                child: Text('Obtener ubicación', style: TextStyle(color: Colors.white)),
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
              )
            ],
          ),          
        ),
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


  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if(!_serviceEnabled){
  //     _serviceEnabled = await location.requestService();
  //     if(!_serviceEnabled){
  //      return 1;
  //     }
  //    }

  //   _permissionGranted = await location.hasPermission();
  //   if(_permissionGranted == PermissionStatus.denied){
  //     _permissionGranted = await location.requestPermission();
  //     if(_permissionGranted != PermissionStatus.granted){
  //       return 1;
  //     }
  //   }

  // _currentPosition = await location.getLocation();
  
  // return 1;
  }

  @override
  bool get wantKeepAlive => true;
}