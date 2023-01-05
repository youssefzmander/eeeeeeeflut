import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Detail extends StatefulWidget {
  static const String id = "idDetail";
  late String idm;
  late String title;
  late double prix;
  late String image;
  late String description;

  Detail(this.idm, this.title, this.prix, this.image, this.description);
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue),
        backgroundColor: Colors.white,
        title: const Text("Details", style: TextStyle(color: Colors.blue),),
        centerTitle: true,
      ),
      body: Card(
        child: Column(children: [
          Container(
              margin: EdgeInsets.all(0),
              child: Image.network( widget.image, height: 420),
            ),
            Text(widget.title, textScaleFactor: 2,style: TextStyle(color: Colors.orange)),
            const SizedBox(
              height: 10,
            ),
            Text(widget.prix.toString() + " DT", textScaleFactor: 1),
             SizedBox(
              height: 10,
            ),
            Text(widget.description, textScaleFactor: 1)
        ],),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.shopping_basket_rounded),
        label: Text("Add to Cart", textScaleFactor: 1.5),
        backgroundColor: Colors.orange,
        onPressed: () async{
          Map<String, dynamic> menu = {
            "id": widget.idm,
            "title": widget.title,
            "prix": widget.prix,
            "image": widget.image,
            "description": widget.description
          };
          Database database = await openDatabase(
              join(await getDatabasesPath(), "data.db")
          );
          database.insert("menu", menu, conflictAlgorithm: ConflictAlgorithm.replace);
          showDialog(context: context, builder: (context) {
            return const AlertDialog(
              title: Text("Confirmation"),
              content: Text(
                  "Item added to cart"));
          });
          //Navigator.pushNamed(context, ChoixPays.id);
        },

      )
    );
  }
}

