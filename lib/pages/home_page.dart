import 'package:flutter/material.dart';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:lugares_nav_bar/bloc/lugares_bloc.dart';
import 'package:lugares_nav_bar/widgets/home_widget.dart';
import 'package:lugares_nav_bar/widgets/mapa_widget.dart';
import 'package:lugares_nav_bar/widgets/resultados_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController _pageController;
  List<Widget> _body = [HomeWidget(), ResultadosWidget(),MapaWidget()];
  int _currentIndex = 0;

  void _onPageChanged(int index){//index es la página actual en pageview
    setState(() {
      _currentIndex = index; //_currentindex es el elemento coloreado en el bottom navy bar
    });
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();

  }

  void _onItemSelected(int selectedIndex){ // selectedIndex es el elementro presionado en bottom navy bar
    // _pageController.jumpToPage(selectedIndex);
    _pageController.animateToPage(selectedIndex, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }
  @override
  Widget build(BuildContext context) {
    LugaresBloc lugaresBloc = Provider.of<LugaresBloc>(context);
    _pageController = new PageController();
    lugaresBloc.pageController = _pageController;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Lugares'),
      // ),
      body: PageView(
        controller: _pageController,
        children: _body,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
        // physics: RangeMaintainingScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.fastLinearToSlowEaseIn,
        animationDuration: Duration(seconds: 2),
        onItemSelected: _onItemSelected,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home), 
            title: Text('Principal',
              style: TextStyle(
                fontSize: size.height*0.02
              ),
            ),
            activeColor: Colors.red
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.list), 
            title: Text('Resultados',
              style: TextStyle(
                fontSize: size.height*0.02
              ),
            ),
            activeColor: Colors.purple
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.map), 
            title: Text('Mapa',
              style: TextStyle(
                fontSize: size.height*0.02
              ),
            ),
            activeColor: Colors.teal
          ),
        ],
      ),
      
    );
  }
}