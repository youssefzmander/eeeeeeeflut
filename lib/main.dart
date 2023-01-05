import 'package:flutter/material.dart';
import 'package:flutter_planb/splash_screen.dart';
import 'authentification.dart';
import 'package:flutter_planb/acceuil/acceuil.dart';
import 'package:flutter_planb/acceuil/menu_view.dart';
import 'package:flutter_planb/panier.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EVAX",
      theme: ThemeData(
   
        primarySwatch: Colors.red,
      ),
      home: const SplashScreen(),
        routes: {
          Authentification.id: (context) {
          return const Authentification();
        },
          Acceuil.id: (context) {
          return const Acceuil();
        },
        Panier.id: (context) {
          return const Panier();
        },
        },
    );
  }
}
