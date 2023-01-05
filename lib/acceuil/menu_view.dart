import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_planb/k_constant.dart';
import 'package:flutter_planb/detail.dart';


class MenuView extends StatelessWidget {

  late String image;
  late double unitPrice;
  late String name;
  late String code;
  late String description;

  MenuView(this.image, this.name,this.unitPrice, this.code, this.description);






  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Card(
        child: InkWell(
          onTap: () async {
            print(name);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Detail(image, name, unitPrice, code, description);
            }));
          },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(0),
              child: Image.network(image, height: 320),
            ),
            Text(name, textScaleFactor: 2, style: TextStyle(color: Colors.blue)),
            const SizedBox(
              height: 10,
            ),
           
            Text(unitPrice.toString() , textScaleFactor: 1) // prix
            
          ],
        ),
        ),
      ),
    );
  }
}