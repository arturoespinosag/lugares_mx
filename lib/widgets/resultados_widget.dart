import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lugares_nav_bar/bloc/lugares_bloc.dart';
import 'package:lugares_nav_bar/models/lugares_model.dart';
import 'package:lugares_nav_bar/providers/lugares_provider.dart';
import 'package:provider/provider.dart';


final lugaresProvider = LugaresProvider();


class ResultadosWidget extends StatefulWidget {
  @override
  _ResultadosWidgetState createState() => _ResultadosWidgetState();
}

class _ResultadosWidgetState extends State<ResultadosWidget> {

  


  @override
  Widget build(BuildContext context) {
    
    LugaresBloc lugaresBloc = Provider.of<LugaresBloc>(context);
    Position _currentPosition = lugaresBloc.currentPosition; 
    // super.build(context);
    return Container(
      color: Colors.purpleAccent,
      child: (_currentPosition == null) ? 
      Center(child: Text(
        'No hay resultados',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0
        ),
      )): 
      _listaLugares(_currentPosition),
      );
    
  }

  Widget _listaLugares(Position currentPosition){
    return Container(

      child: FutureBuilder(
        future: lugaresProvider.getLugares('restaurante', '${currentPosition.latitude.toString()},${currentPosition.longitude.toString()}', '1000'),
        // future: lugaresProvider.getLugares('restaurante', '19.286314,-99.167673', '1000'),
        builder: (BuildContext context, AsyncSnapshot<List<Lugar>> snapshot) {
          final lugares = snapshot.data;
          if(snapshot.hasData){
            return Container(
              child: Center(
                child: ListView.builder(
                  itemCount: lugares.length,
                  itemBuilder: (context, index){
                    return _lugarCard(lugares[index], index, context); 
                  }
                )
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),


    );
  }

  Widget _lugarCard(Lugar lugar, int index, BuildContext context){
    LugaresBloc _lugaresBloc = Provider.of<LugaresBloc>(context);
    Color color = (index%2 == 0) ? Color.fromRGBO(186, 223, 251, 1.0) : Color.fromRGBO(100, 181, 246, 1.0);

    return GestureDetector(
      onTap: (){
        _lugaresBloc.currentPlace = lugar;
        _lugaresBloc.pageController.jumpToPage(2);

      },
      child: Card(
        color: color,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), bottomRight: Radius.elliptical(30.0, 30.0)),
        ),
        child: ListTile(
          leading: Icon(Icons.map),
          title: Text(lugar.nombre),
          subtitle: Text("${lugar.tipoVialidad} ${lugar.calle} ${lugar.numExterior} ${lugar.numInterior}, ${lugar.colonia}"),
          
        )

      ),

    );


  }

  // @override
  // bool get wantKeepAlive => true;
}