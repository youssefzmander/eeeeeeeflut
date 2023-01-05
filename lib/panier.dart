import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_planb/acceuil/acceuil.dart';
import 'package:flutter_planb/acceuil/menu_view.dart';


class Panier extends StatefulWidget {
  static const String id = "idPanier";
  const Panier({Key? key}) : super(key: key);

  @override
  _PanierState createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  late double total = 0;
  final List<Menu> menu = [];
  late Future<bool> fetchedMenu;
  Future<bool> fetchMenu() async {
    total = 0;
    Database database =
        await openDatabase(join(await getDatabasesPath(), "data.db"));
    List<dynamic> mapMenu = await database.query("menu");
    for (int i = 0; i < mapMenu.length; i++) {
      menu.add(Menu(mapMenu[i]["id"], mapMenu[i]["title"], mapMenu[i]["prix"],
          mapMenu[i]["image"], mapMenu[i]["description"]));
      total = total + mapMenu[i]["prix"];
    }
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchedMenu = fetchMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchedMenu,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: const Text("My Cart"),
              ),
              body: ListView.builder(
                itemCount: menu.length,
                itemBuilder: (context, index) {
                  return MenuView(
                      menu[index].image,
                      menu[index].name,
                      menu[index].unitPrice,
                      menu[index].code,
                      menu[index].description);
                },
              ),
              floatingActionButton: FloatingActionButton.extended(
                icon: Icon(Icons.payment),
                label: Text("Checkout", textScaleFactor: 1.5),
                backgroundColor: Colors.blue,
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return  AlertDialog(
                          title: Text("Checkout"),
                          content: Text("Your total cart is "+total.toString()+" DT"),
                          actions: [
                             ElevatedButton(
                              child:  Text('Confirm'),
                        style: ElevatedButton.styleFrom( primary: Colors.red),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
              )
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
