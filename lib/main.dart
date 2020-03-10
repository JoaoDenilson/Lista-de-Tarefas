import 'package:flutter/material.dart';

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

  _toDoAdd(){
    setState(() {
       _toDoList.add(_toDoController.text);
    _toDoController.text= "";
    });
  }

  Widget _buildItem(context, index){
    return CheckboxListTile(
      value: false,
      title: Text(_toDoList[index]), 
      secondary: Icon(Icons.account_box),
      onChanged: (var value) {
        
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          Row(
              children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _toDoController,
                  decoration: InputDecoration(
                    labelText: "Nova tarefa",
                    labelStyle: TextStyle(color: Colors.blueAccent)
                ),
              ),
              ),
            RaisedButton(
              color: Colors.blueAccent,
              child: Text("Add"),
              textColor: Colors.white,
              onPressed: (){
                _toDoAdd();
              },
            ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _toDoList.length,
              itemBuilder:_buildItem,
            ),
          ),
        ],
        ),
      ),
    );
  }
}