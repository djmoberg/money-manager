import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EditBalance extends StatelessWidget {
  final String _uid;
  final DocumentSnapshot _document;

  EditBalance(this._uid, this._document);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Balance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: MyEditBalance(_uid, _document),
      ),
    );
  }
}

class MyEditBalance extends StatefulWidget {
  final String _uid;
  final DocumentSnapshot _document;

  MyEditBalance(this._uid, this._document);

  @override
  MyEditBalanceState createState() {
    return MyEditBalanceState(_uid, _document);
  }
}

class MyEditBalanceState extends State<MyEditBalance> {
  final String _uid;
  final DocumentSnapshot _document;

  MyEditBalanceState(this._uid, this._document);

  int _newBalance;
  TextEditingController _controller;
  String _errorText;
  bool _buttonDisabled;

  @override
  void initState() {
    super.initState();
    _newBalance = _document['balance'];
    _controller =
        new TextEditingController(text: _document['balance'].toString());
    _buttonDisabled = false;
  }

  void _updateBalance() {
    if (_newBalance != null) {
      setState(() {
        _buttonDisabled = true;
      });
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(_document.reference);
        await transaction.update(freshSnap.reference, {"balance": _newBalance});
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
          controller: _controller,
          decoration: InputDecoration(
              labelText: "New balance",
              errorText: _errorText,
              border: OutlineInputBorder()),
          autofocus: true,
          keyboardType: TextInputType.number,
          onChanged: (String value) {
            setState(() {
              _newBalance = value.length == 0 || int.parse(value) < 0
                  ? null
                  : int.parse(value);
              _errorText = null;
            });
          },
        ),
        // Text("$_newBalance"),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Row(
            children: <Widget>[
              RaisedButton(
                child: Text("Clear"),
                color: Colors.red,
                onPressed: () {
                  _controller.clear();
                  setState(() {
                    _newBalance = null;
                  });
                },
              ),
              Expanded(
                child: Text(""),
              ),
              RaisedButton(
                  child: Text("Save"),
                  color: Colors.green,
                  onPressed: _buttonDisabled ? null : _updateBalance)
            ],
          ),
        ),
      ],
    );
  }
}
