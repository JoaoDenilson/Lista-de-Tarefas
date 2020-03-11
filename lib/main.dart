import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var _toDoController = TextEditingController();
  var _toDoList = [];
  var _lastRemoved = {};
  var _lastRemovedPos = 0;

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/lista.json");
  }

  Future<File> _saveData() async {
    var data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch(e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  _toDoAdd(){
    setState(() {
      _toDoList.add({
        'title': _toDoController.text,
        'ok': false
      });
      _toDoController.text = "";
      _saveData();
    });
  }

  Widget _buildItem(context, index){
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 10),
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList[index]['title']),
        value: _toDoList[index]['ok'],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]['ok'] ? Icons.check : Icons.error),
        ),
        onChanged: (ok){
          setState(() {
            _toDoList[index]['ok'] = ok;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        _lastRemoved = Map.from(_toDoList[index]);
        _lastRemovedPos = index;

        _toDoList.removeAt(index);
        _saveData();

        final snack = SnackBar(
          content: Text("Tarefa \"${_lastRemoved['title']}\" removida!"),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: "Desfazer",
            onPressed: (){
              setState(() {
                _toDoList.insert(_lastRemovedPos, _lastRemoved);
                _saveData();
              });
            },
          ),
        );
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(snack);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _toDoController,
                    decoration: InputDecoration(
                      labelText: "Nova tarefa",
                      labelStyle: TextStyle(color: Colors.blueAccent)
                    ),
                  )
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: _toDoAdd,
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _toDoList.length,
                itemBuilder: _buildItem,
              ),
            )
          ],
        ),
      ),
    );
  }
}