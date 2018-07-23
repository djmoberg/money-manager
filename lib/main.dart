import 'package:flutter/material.dart';
import 'package:money_manager/Login.dart';
import 'package:money_manager/LoggedIn.dart';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Money Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Money Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isAuthenticated = false;
  String _uid;

  void _listener() {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      setState(() {
        _isAuthenticated = user != null;
        _uid = user != null ? user.uid : "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _listener();
    return _isAuthenticated ? LoggedIn(_uid) : Login();
  }
}
