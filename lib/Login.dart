import 'package:flutter/material.dart';
import 'package:validate/validate.dart';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;

// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Money Manager"),
        ),
        body: MyCustomForm());
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            Image.network(
                "https://cdn-images-1.medium.com/max/800/1*7QzITNnpHIBot7-wpo0iJA.png"),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                } else {
                  try {
                    Validate.isEmail(value);
                  } catch (e) {
                    return 'The E-mail Address must be a valid email address.';
                  }
                }
              },
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
              onSaved: (String value) {
                setState(() {
                  _username = value;
                });
              },
            ),
            SizedBox(height: 8.0),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
              },
              decoration: InputDecoration(labelText: "Passord"),
              obscureText: true,
              onSaved: (String value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            SizedBox(height: 24.0),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Colors.red,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Logging in...')));
                      _formKey.currentState.save();
                      try {
                        final firebaseUser = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: _username, password: _password);
                      } catch (e) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Something went wrong')));
                      }
                    }
                  },
                  child: Text('Login'),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Text("Create Account"),
                  onPressed: () {},
                ),
                FlatButton(
                  child: Text("Forgot password?"),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
