import 'package:flutter/material.dart';

class ChangeCity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.red,
          title: new Text('Change City'),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/white_snow.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: <Widget>[
              new ListView(
                children: <Widget>[
                  new ListTile(
                    title: new TextField(
                      decoration: new InputDecoration(hintText: "Enter City"),
                      controller: _cityFieldController,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  new ListTile(
                      title: new FlatButton(
                    onPressed: () {
                      Navigator.pop(
                          context, {'enter': _cityFieldController.text});
                    },
                    child: new Text("Get Weather"),
                    color: Colors.redAccent,
                    textColor: Colors.white,
                  )),
                ],
              ),
            ],
          ),
        ));
  }
}
