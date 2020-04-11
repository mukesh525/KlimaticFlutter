import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:klimatic/model/WeatherData.dart';

import '../util/utils.dart' as util;
import 'ChangeCity.dart';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  var _cityEntered = util.deafultCity;

  Future _gotoNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return new ChangeCity();
    }));

    if (results != null && results.containsKey('enter')) {
      _cityEntered = results['enter'];
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Klimatic"),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.menu),
              onPressed: () => _gotoNextScreen(context))
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/umbrella.png',
              width: 490,
              height: 1200,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0),
            child: new Text(_cityEntered, style: cityStyle()),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.png'),
          ),
          updateTempWidget(_cityEntered)
//          new Container(
//            margin: const EdgeInsets.fromLTRB(30.0, 400.0, 0.0, 0.0),
//            child: updateTempWidget(_cityEntered),
//          ),
        ],
      ),
    );
  }
}

TextStyle cityStyle() {
  return new TextStyle(
      color: Colors.white, fontSize: 22.9, fontStyle: FontStyle.italic);
}

TextStyle tempStyle() {
  return new TextStyle(
      color: Colors.white,
      fontSize: 49.9,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500);
}

Future<WeatherData> getWeather(String appId, String city) async {
  String url =
      "http://api.openweathermap.org/data/2.5/weather?q=$city&APPID=${appId}&units=metric";
  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var parsedJson = json.decode(response.body);
    return WeatherData.fromJson(parsedJson);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Widget updateTempWidget(String city) {
  return new FutureBuilder(
      future: getWeather(util.appId, city),
      builder: (BuildContext context, AsyncSnapshot<WeatherData> snapshot) {
        //where we get all of the jason data , we setup widget
        if (snapshot.hasData) {
          WeatherData content = snapshot.data;
          return new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 450.0, 0.0, 0.0),
            child: new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text(content.main.temp.toString() + " F",
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 49.9,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal)),
                  subtitle: new ListTile(
                    title: new Text(
                      "Humidity ${content.main.humidity.toString()}\n"
                      "Min ${content.main.tempMin.toString()}\n"
                      "Max ${content.main.tempMax.toString()}",
                      style: new TextStyle(
                          color: Colors.white60,
                          fontStyle: FontStyle.normal,
                          fontSize: 17.0),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return new Container();
        }
//        return new Text(
//          city,
//          style: tempStyle(),
//        );
      });
}
