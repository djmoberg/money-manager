import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EditExpense extends StatelessWidget {
  final String _uid;
  final DocumentSnapshot _document;
  final int _index;

  EditExpense(this._uid, this._document, this._index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit expense"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32.0),
        children: <Widget>[
          MyEditExpense(_uid, _document, _index),
        ],
      ),
    );
  }
}

class MyEditExpense extends StatefulWidget {
  final String _uid;
  final DocumentSnapshot _document;
  final int _index;

  MyEditExpense(this._uid, this._document, this._index);

  @override
  State<StatefulWidget> createState() {
    return MyEditExpenseState(_uid, _document, _index);
  }
}

class MyEditExpenseState extends State<MyEditExpense> {
  final String _uid;
  final DocumentSnapshot _document;
  final int _index;

  MyEditExpenseState(this._uid, this._document, this._index);

  List<dynamic> _list;

  String _name;
  int _value;
  String _errorText;
  bool _buttonDisabled;
  TextEditingController _nameController;
  TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _buttonDisabled = false;
    _list = List.from(_document['expenses']);
    _nameController = new TextEditingController(
        text: Map<String, dynamic>.from(_list[_index])['name']);
    _valueController = new TextEditingController(
        text: Map<String, dynamic>.from(_list[_index])['value'].toString());
    _name = Map<String, dynamic>.from(_list[_index])['name'];
    _value = Map<String, dynamic>.from(_list[_index])['value'];
  }

  void _editExpense() {
    if (_name != null && _value != null) {
      setState(() {
        _buttonDisabled = true;
      });
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(_document.reference);
        List<dynamic> newList = List.from(freshSnap['expenses']);
        newList.removeAt(_index);
        newList.insert(_index, {'name': _name, 'value': _value});
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
          controller: _nameController,
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
          controller: _valueController,
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
                  onPressed: _buttonDisabled ? null : _editExpense)
            ],
          ),
        ),
      ],
    );
  }
}
