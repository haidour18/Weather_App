import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int temperature = 0;
  String location = 'San Francisco';
  String searchApiUrl = 'https://www.metaweather.com/api/location/search/?query=';
  String locationApiUrl = 'https://www.metaweather.com/api/location/';
  int woeid = 2487956;
  String weather = 'clear';
  String abbreviation ='';

  void fetchSearch(String input) async {
    var searchResut = await http.get(searchApiUrl + input);
    var result = json.decode(searchResut.body)[0];
    setState(() {
      location = result["title"];
      woeid = result["woeid"];
    });
  }

void fetchLocation() async {
    var LocationResult = await http.get(locationApiUrl + woeid.toString());
    var result = json.decode(LocationResult.body);
    var consolidated_weather = result["consolidated_weather"];
    var data = consolidated_weather[0];
    setState(() {
      temperature = data["the_temp"].round();
      weather = data["weather_state_name"].replaceAll('', '').toLowerCase();
      abbreviation = data["weather_state_abbr"];

    });
  }

void onTextFieldSubmitted(String input) async {
   await fetchSearch(input);
    await fetchLocation();
  }
  initState() {
    super.initState();
    fetchLocation();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(

        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Column(
                  children: [

                    Container(
                      padding: EdgeInsets.only(top: 150),
                      child:   Center(
                        child: Image.network( 'https://www.metaweather.com/static/img/weather/png/'+abbreviation+'.png',
                          width: 100,),

                      ),
                    ),
                    Container(


                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                        child: Text(
                          temperature.toString() + ' °C',
                          style: TextStyle(color: Colors.blueGrey, fontSize: 60.0),
                        ),
                      ),
                    ),


                    Center(
                      child: Text(
                        location,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 30.0),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(25),
                          child: TextField(
                            onSubmitted: (String input) {
                              onTextFieldSubmitted(input);
                            },
                            cursorColor: Colors.grey,
                            style: TextStyle(color: Colors.grey, fontSize: 25),
                            decoration: InputDecoration(
                                hintText: 'Search another location',
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 18),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.blueGrey,
                                )),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
