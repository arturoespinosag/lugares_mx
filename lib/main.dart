import 'package:flutter/material.dart';
import 'package:lugares_nav_bar/bloc/places_bloc.dart';
import 'package:lugares_nav_bar/pages/details_page.dart';
import 'package:lugares_nav_bar/pages/home_page.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlacesBloc>.value(
      value: PlacesBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lugares',
        initialRoute: '/',
        routes: {
          '/'        : (BuildContext context) => HomePage(),
          'detalles' : (BuildContext context) => DetailsPage(),
        },
      ),
    );
  }
}