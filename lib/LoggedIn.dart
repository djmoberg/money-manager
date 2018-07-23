import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:money_manager/LoggedInWidgets/EditBalance.dart';
import 'package:money_manager/LoggedInWidgets/AddExpense.dart';
import 'package:money_manager/LoggedInWidgets/EditExpense.dart';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:cloud_firestore/cloud_firestore.dart';

class LoggedIn extends StatelessWidget {
  final String _uid;

  LoggedIn(this._uid);

  final currencyFormater = NumberFormat.currency(locale: "NO");

  Widget _builder(BuildContext context, DocumentSnapshot document) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: FlatButton(
            child: Text(
              "Balance: " + currencyFormater.format(document['balance']),
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditBalance(_uid, document)));
            },
          ),
        ),
        Expanded(
          child: _expensesList(context, document),
        )
      ],
    );
  }

  Widget _expensesList(BuildContext context, DocumentSnapshot document) {
    return ListView.builder(
      itemExtent: 80.0,
      itemCount: document['expenses'].length,
      itemBuilder: (context, index) => ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditExpense(_uid, document, index)));
            },
            leading: Icon(Icons.money_off),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    Map<String, dynamic>.from(
                        List.from(document['expenses'])[index])['name'],
                    style: Theme.of(context).textTheme.headline,
                  ),
                ),
                Container(
                  // decoration: const BoxDecoration(color: Color(0xffddddff)),
                  // padding: EdgeInsets.all(10.0),
                  child: Text(
                    Map<String, dynamic>.from(
                            List.from(document['expenses'])[index])['value']
                        .toString(),
                    style: Theme.of(context).textTheme.display1,
                  ),
                )
              ],
            ),
          ),
    );
  }

  Widget _page(BuildContext context, DocumentSnapshot document) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Money Manager"),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
          )
        ],
      ),
      body: _builder(context, document),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddExpense(_uid, document)));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('users').document(_uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text("Loading...");
        // return Text(snapshot.data['balance'].toString());
        return _page(context, snapshot.data);
      },
    );
  }
}
