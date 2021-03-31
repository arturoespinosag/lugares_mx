import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lugares_nav_bar/bloc/lugares_bloc.dart';
import 'package:lugares_nav_bar/models/lugares_model.dart';
import 'package:provider/provider.dart';

class MapaWidget extends StatefulWidget {
  @override
  _MapaWidgetState createState() => _MapaWidgetState();
}

class _MapaWidgetState extends State<MapaWidget>{
  
    GoogleMapController mapController;
    Set<Marker> _markers = {};
    BitmapDescriptor mapMarker;
    Lugar lugar;

    
    
    void _onMapCreated(GoogleMapController controller){
      

      LugaresBloc lugaresBloc = Provider.of<LugaresBloc>(context, listen: false);
      Position _currentPosition = lugaresBloc.currentPosition;
      lugar = lugaresBloc.currentPlace;
      mapController = controller;

      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('id-1'), 
            position: LatLng(double.parse(lugaresBloc.currentPlace.latitud), double.parse(lugaresBloc.currentPlace.longitud)),
            infoWindow: InfoWindow(
              title: '${lugaresBloc.currentPlace.nombre}\n${lugaresBloc.currentPlace.telefono}',
              snippet: 'A ${Geolocator.distanceBetween(_currentPosition.latitude, _currentPosition.longitude, double.parse(lugar.latitud), double.parse(lugar.longitud)).round().toString()} metros'

            )
          ),
          
        );
      }
      );
    }
  
  @override
  Widget build(BuildContext context) {
    LugaresBloc lugaresBloc = Provider.of<LugaresBloc>(context);
    return Scaffold(
      body: Container(
              height: double.infinity,
              child: GoogleMap(
                myLocationEnabled: true,
                trafficEnabled: true,
                mapType: MapType.hybrid,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(double.parse(lugaresBloc.currentPlace.latitud), double.parse(lugaresBloc.currentPlace.longitud)),
                  zoom: 17
                ),
                onMapCreated:  _onMapCreated,
                markers: _markers,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.pin_drop),
        onPressed: _gotoPosition,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );

   


  }

  Future<void> _gotoPosition() async{

    final CameraPosition cameraPosition = CameraPosition(
      target: (lugar != null ) ? LatLng(
        double.parse(lugar.latitud),
        double.parse(lugar.longitud),
      ):
      LatLng(
        19.432366683023716,
        -99.13323364074559
      ),
      zoom: 17
    );
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));




  }

  

}