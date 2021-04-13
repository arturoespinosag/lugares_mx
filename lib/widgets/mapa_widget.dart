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

class _MapaWidgetState extends State<MapaWidget> with AutomaticKeepAliveClientMixin{
  
    GoogleMapController mapController;
    Set<Marker> _markers = {};
    BitmapDescriptor mapMarker;
    Lugar lugar;
    bool isAlive = false;


    
    
    void _onMapCreated(GoogleMapController controller) async{   
      
      LugaresBloc lugaresBloc = Provider.of<LugaresBloc>(context, listen: false);
      Position _currentPosition = lugaresBloc.currentPosition;
      lugar = lugaresBloc.currentPlace;
      mapController = controller;
      List<Lugar> lugares = lugaresBloc.lugares;
      
      
      setState(() {
        if(lugar.id != 'zocalo'){
          for(int i = 0; i < lugares.length; i++){
              _markers.add(
                Marker(
                  icon: (lugares[i].id != lugar.id) 
                  ? BitmapDescriptor.defaultMarker 
                  : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                  markerId: MarkerId('id-${lugares[i].id}'), 
                  position: LatLng(double.parse(lugares[i].latitud), double.parse(lugares[i].longitud)),
                  infoWindow: InfoWindow(
                    onTap: () {
                      Navigator.pushNamed(context, 'detalles');
                    },
                    title: '${lugares[i].nombre}\n${lugares[i].telefono}',
                    snippet: 'A ${Geolocator.distanceBetween(_currentPosition.latitude, _currentPosition.longitude, double.parse(lugares[i].latitud), double.parse(lugares[i].longitud)).round().toString()} metros'

                  ),
                  onTap: (){
                    lugaresBloc.currentPlace = lugares[i];
                  }
               ),
          
              );
          }
        }else{
          _markers.add(Marker(
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            markerId: MarkerId(lugar.id),
            position: LatLng(double.parse(lugar.latitud), double.parse(lugar.longitud)),
            infoWindow: InfoWindow(
              title: 'Plaza de la Constitución (Zócalo)',
            )
          ));
        }
        
      }
      );
      
    }



    @override
    void dispose() { 
      mapController.dispose();
      super.dispose();
    }

    
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    LugaresBloc lugaresBloc = Provider.of<LugaresBloc>(context);
    return Scaffold(
      body: Container(
              height: double.infinity,
              child: GoogleMap(
                key: PageStorageKey<String>('map'),
                myLocationEnabled: true,
                trafficEnabled: true,
                mapType: MapType.normal,
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

  @override
  bool get wantKeepAlive => isAlive;

  

}