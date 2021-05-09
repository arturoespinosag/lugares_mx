import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lugares_nav_bar/bloc/places_bloc.dart';
import 'package:lugares_nav_bar/models/place_model.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class MapaWidget extends StatefulWidget {
  @override
  _MapaWidgetState createState() => _MapaWidgetState();
}

class _MapaWidgetState extends State<MapaWidget>
    with AutomaticKeepAliveClientMixin {
  GoogleMapController mapController;
  Set<Marker> _markers = {};
  BitmapDescriptor mapMarker;
  Place place;
  Position currentPosition;
  

  void _addMarkers() {
    PlacesBloc placesBloc = Provider.of<PlacesBloc>(context);
    Position _currentPosition = placesBloc.currentPosition;
    currentPosition = _currentPosition;
    place = placesBloc.currentPlace;
    List<Place> places = placesBloc.places;

    _markers.clear();
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
              double.parse(placesBloc.currentPlace.latitud),
              double.parse(placesBloc.currentPlace.longitud),
            ),
            zoom: 17.0),
      ),
    );
    print('prueba');
    if (place.id != 'zocalo') {
      //sucede cuando no hay ningún lugar seleccionado, ya que zócalo es el lugar por defecto.
      for (int i = 0; i < places.length; i++) {
        //si ya se hizo una búsqueda y se seleccionó un lugar, se agregan los markers.
        _markers.add(
          Marker(
              icon: (places[i].id !=
                      place.id) // verifica si el lugar es el seleccionado
                  ? BitmapDescriptor
                      .defaultMarker //si no es, el marcador es rojo.
                  : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor
                      .hueBlue), // si es el lugar seleccionado, el marcador es azul.
              markerId: MarkerId('id-${places[i].id}'),
              position: LatLng(double.parse(places[i].latitud),
                  double.parse(places[i].longitud)),
              infoWindow: InfoWindow(
                  onTap: () {
                    Navigator.pushNamed(context, 'detalles');
                  },
                  title: '${places[i].nombre}\n${places[i].telefono}',
                  snippet:
                      'A ${Geolocator.distanceBetween(_currentPosition.latitude, _currentPosition.longitude, double.parse(places[i].latitud), double.parse(places[i].longitud)).round().toString()} metros'),
              onTap: () {
                placesBloc.currentPlace = places[i];
              }),
        );
      }
    } else {
      // si el id es zocalo, no se ha seleccionado un elemento de la lista. Se usan los valores por default.
      _markers.add(
        Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          markerId: MarkerId(place.id),
          position:
              LatLng(double.parse(place.latitud), double.parse(place.longitud)),
          infoWindow: InfoWindow(
            title: 'Plaza de la Constitución (Zócalo)',
          ),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    PlacesBloc placesBloc = Provider.of<PlacesBloc>(context);
    print('prueba placesbloc');
    _addMarkers(); // se agregan los marcadores cada vez que se recarga el mapa.
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: GoogleMap(
          myLocationEnabled: true,
          trafficEnabled: true,
          mapType: MapType.normal,
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
              target: LatLng(double.parse(placesBloc.currentPlace.latitud),
                  double.parse(placesBloc.currentPlace.longitud)),
              zoom: 17),
          onMapCreated: _onMapCreated,
          markers: _markers,
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            child: Icon(Icons.share),
            onPressed: _share,
          ),
          FloatingActionButton(
            child: Icon(Icons.accessibility),
            onPressed: _gotocurrentPosition,
          ),
          FloatingActionButton(
            child: Icon(Icons.pin_drop),
            onPressed: _gotoPosition,
          ),
        ],
      ),
      // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _gotoPosition() async {
    final CameraPosition cameraPosition = CameraPosition(
        target: (place != null)
            ? LatLng(
                double.parse(place.latitud),
                double.parse(place.longitud),
              )
            : LatLng(19.432366683023716, -99.13323364074559),
        zoom: 17);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Future<void> _gotocurrentPosition() async {
    final CameraPosition cameraPosition = CameraPosition(
        target: (currentPosition != null)
            ? LatLng(
                currentPosition.latitude,
                currentPosition.longitude,
              )
            : LatLng(19.432366683023716, -99.13323364074559),
        zoom: 17);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void _share(){
    Share.share('Hola, quiero compartirte este gran lugar que te podría interesar\n${place.nombre}\n https://www.google.com/maps/search/?api=1&query=${place.latitud},${place.longitud}');
  }

  @override
  bool get wantKeepAlive => true;
}
