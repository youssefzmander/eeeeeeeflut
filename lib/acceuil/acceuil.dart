import 'package:flutter_planb/authentification.dart';
import 'package:flutter_planb/k_constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_planb/acceuil/menu_view.dart';
import 'package:flutter_planb/panier.dart';

class Acceuil extends StatefulWidget {
  static const String id = "idAcceuil";
  const Acceuil({Key? key}) : super(key: key);

  @override
  _AcceuilState createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {

  late String username;

  final List<Menu> menu = [];

  late Future<bool> fetchedUserAndMenu;


Future<bool> fetchUserAndMenu() async{
     http.Response response = await http.get(Uri.parse(baseUrl+"/api/currencies"));
    List<dynamic> menusfromServer = json.decode(response.body);
    for (int i = 0; i < menusfromServer.length; i++) {
      menu.add(Menu(
          menusfromServer[i]["code"],
          menusfromServer[i]["name"],
          double.parse(menusfromServer[i]["unitPrice"].toString()),
          "http://10.0.2.2:9090/" +menusfromServer[i]["image"],
          menusfromServer[i]["description"])
      );
    } 

    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("userName")!;
    return true;
  }
  @override
  void initState() {
    // TODO: implement initState
    fetchedUserAndMenu = fetchUserAndMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchedUserAndMenu,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.transparent),
              actions: <Widget> [
                Padding(padding: EdgeInsets.only(right: 20.0), child: GestureDetector(child: Icon(Icons.shopping_cart), onTap: () {
                  print("my caaaart");
                  Navigator.pushNamed(context, Panier.id);
                  // push to detail view
                },),)
              ],
              backgroundColor: Colors.blue,
              title: const Text("Crypto Wallet", style: TextStyle(color: Colors.white)),
              centerTitle: true,
            ),


            drawer: Drawer(
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.blue,
                    title: Text("Welcome Mr. "+username),
                  ),
                  ListTile(
                    title: Row(
                      children: const [
                        Icon(Icons.shopping_cart,color: Colors.blue,),
                        SizedBox(width: 30),
                        Text("My crypt-currencies")
                      ],
                    ),
                    onTap: () {
                      print("panier");
                      Navigator.pushNamed(context, Panier.id);
                    },
                  ),
                  ListTile(
                    title: Row(
                      children:const [
                        Icon(Icons.power_settings_new, color: Colors.blue),
                        SizedBox( width: 30,),
                        Text("Disconnect")
                      ],
                    ),
                    onTap: () async {
                      SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove("userName");
                        Database database = await openDatabase(
                            join(await getDatabasesPath(), "data.db"));
                        database.delete("menu");
                        Navigator.pushReplacementNamed(context, Authentification.id);
                    },
                  )
                ],
              )
            ),
            body: ListView.builder(
              itemCount: menu.length,
              itemBuilder: (context, index) {
                return MenuView(menu[index].image, menu[index].name,menu[index].unitPrice,
                        menu[index].code, menu[index].description);
              },
            ),
          );
        } else { 
          return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
}



class Menu{
  late String image;
  late double unitPrice;
  late String name;
  late String code;
  late String description;

  Menu(this.image, this.name,this.unitPrice, this.code, this.description);


}