import 'package:Assignment/screens/form.dart';
import 'package:Assignment/screens/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black),
      home: AnimatedSplashScreen(
        duration: 1200,
        splashIconSize: 250,
        backgroundColor: Colors.white,
        splash: Image.asset("assets/icon.jpg"),
        animationDuration: Duration(seconds: 1),
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: HomeScreen(),
      ),
      routes: {FormScreen.routeName: (ctx) => FormScreen()},
    );
  }
}
