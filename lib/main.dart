import 'package:flutter/material.dart';
import 'package:lugares_nav_bar/bloc/lugares_bloc.dart';
import 'package:lugares_nav_bar/pages/home_page.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LugaresBloc>.value(
      value: LugaresBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lugares',
        initialRoute: '/',
        routes: {
          '/' : (BuildContext context) => HomePage(),
        },
      ),
    );
  }
}