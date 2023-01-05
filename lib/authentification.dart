import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_planb/acceuil/acceuil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_planb/k_constant.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';


class Authentification extends StatefulWidget {
  static const String id = "idAuthentification";
  const Authentification({Key? key}) : super(key: key); 

  @override
  _AuthentificationState createState() => _AuthentificationState();
}


class _AuthentificationState extends State<Authentification> {
  late String? username;
  late String? password;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(0),
              child: Image.asset("images/logo.png", width: 460, height:120 ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Username"
                ),
                onSaved: (String? value) {
                  username = value;
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "please enter your username";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "ID"),
                onSaved: (String? value) {
                  password = value;
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "please enter your ID";
                  } else if (value.length < 4) {
                    return "Password must be at least 4 caracters long";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                    _formkey.currentState!.save();
                    print("données valide ");
                    Map<String, String> headers = {
                      "Content-Type": "application/json; charset=utf-8"
                    };
                    Map<String, dynamic> body = {
                      "username": username!,
                      "identifier": password!
                    };
                    http.post(
                        Uri.parse(baseUrl+ "/api/users/login/id"),
                        headers: headers,
                        body: json.encode(body)
                    ).then((response) async {
                      print(response.statusCode);
                      if (response.statusCode == 200) {
                        Map<String, dynamic> userData = json.decode(response.body);
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString("userName", userData["username"]);
                        print(userData["username"]);

                        Database database = await openDatabase(
                            join(await getDatabasesPath(), "data.db"),
                            onCreate: (Database db, int index) {
                              db.transaction((txn) async {
                                await txn.execute(
                                    "CREATE TABLE menu(id INTEGER PRIMARY KEY, title TEXT,"
                                        " prix DOUBLE, image TEXT, description TEXT)");
                              });
                            }, version: 1);

                        Navigator.pushReplacementNamed(context, Acceuil.id);
                        print("success login");
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                title: Text("Informations"),
                                content: Text(
                                    "Username or ID are incorrect"),
                              );
                            });
                      }
                    });
                  }
              },
              child: const Text("Submit"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.black45),
                  //padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                  // textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 10))
                )
              )
          ],
        ),
      ),
    );
  }






}

