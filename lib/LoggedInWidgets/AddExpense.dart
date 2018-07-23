import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AddExpense extends StatelessWidget {
  final String _uid;
  final DocumentSnapshot _document;

  AddExpense(this._uid, this._document);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add expense"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32.0),
        children: <Widget>[
          MyAddExpense(_uid, _document),
        ],
      ),
    );
  }
}

class MyAddExpense extends StatefulWidget {
  final String _uid;
  final DocumentSnapshot _document;

  MyAddExpense(this._uid, this._document);

  @override
  State<StatefulWidget> createState() {
    return MyAddExpenseState(_uid, _document);
  }
}

class MyAddExpenseState extends State<MyAddExpense> {
  final String _uid;
  final DocumentSnapshot _document;

  MyAddExpenseState(this._uid, this._document);

  String _name;
  int _value;
  String _errorText;
  bool _buttonDisabled;

  @override
  void initState() {
    super.initState();
    _buttonDisabled = false;
  }

  void _addExpense() {
    // Firestore.instance
    //     .collection('users')
    //     .document(_uid)
    //     .updateData({"balance": 100, "expenses": [{'name': 'title', 'value': 2}]});
    if (_name != null && _value != null) {
      setState(() {
        _buttonDisabled = true;
      });
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(_document.reference);
        List<dynamic> newList = List.from(freshSnap['expenses']);
        newList.add({'name': _name, 'value': _value});
        await transaction.update(freshSnap.reference, {"expenses": newList});
        Navigator.pop(context);
      });
    } else {
      setState(() {
        _errorText = "Invalid balance";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
              labelText: "Name",
              errorText: _errorText,
              border: OutlineInputBorder()),
          autofocus: true,
          onChanged: (String value) {
            setState(() {
              _name = value;
              _errorText = null;
            });
          },
        ),
        SizedBox(height: 24.0),
        TextField(
          decoration: InputDecoration(
              labelText: "Expense",
              errorText: _errorText,
              border: OutlineInputBorder()),
          autofocus: true,
          keyboardType: TextInputType.number,
          onChanged: (String value) {
            setState(() {
              _value = value.length == 0 || int.parse(value) < 0
                  ? null
                  : int.parse(value);
              _errorText = null;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(""),
              ),
              RaisedButton(
                  child: Text("Save"),
                  color: Colors.green,
                  onPressed: _buttonDisabled ? null : _addExpense)
            ],
          ),
        ),
      ],
    );
  }
}
