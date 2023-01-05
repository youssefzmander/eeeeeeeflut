import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'acceuil/acceuil.dart';
import 'package:flutter_planb/authentification.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  late String route;
  late Future<bool> fetchedUser;

  Future<bool> fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("userName")){
      route = Acceuil.id;
    }else{
      route = Authentification.id;
    }
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchedUser = fetchUser();
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchedUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if(route == Acceuil.id) {
            return const Acceuil();
          } else {
            return const Authentification();
          }
        }else{
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}