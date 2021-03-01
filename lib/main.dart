import 'dart:convert';

import 'package:flutter/material.dart';
import'package:http/http.dart'as http;

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
  String searchApiUrl = '/api/location/search/?query=';
  String locationApiUrl='https://www.metaweather.com/api/location/';
  int woeid = 2487956;

  void fetchSearch(String input) async {
    var searchResut = await http.get( searchApiUrl + input );
    var result = json.decode( searchApiUrl.substring( 0 ) );
    setState( () {
      location = result["title"];
      woeid = result["woeid"];
    } );
  }
Future<void> fetchLocation() async {
    var LocationResult= await http.get(locationApiUrl+woeid.toString());
}
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false ,
        home: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage( 'images/clear.png' ) ,
              fit: BoxFit.cover ,
            ) ,
          ) ,
          child: Scaffold(

            backgroundColor: Colors.transparent ,
            body: SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Column(

                    children: [
                      Container(
                        padding: EdgeInsets.only( top: 250 ) ,
                        child: Center(

                          child: Text(
                            temperature.toString( ) + ' °C' ,
                            style: TextStyle(
                                color: Colors.white , fontSize: 60.0 ) ,
                          ) ,
                        ) ,
                      ) ,
                      Center(
                        child: Text(
                          location ,
                          style: TextStyle(
                              color: Colors.white , fontSize: 30.0 ) ,
                        ) ,
                      ) ,
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all( 25 ) ,
                            child: TextField(
                              cursorColor: Colors.white ,
                              style: TextStyle(
                                  color: Colors.white , fontSize: 25 ) ,
                              decoration: InputDecoration(
                                  hintText: 'Search another location' ,
                                  hintStyle:
                                  TextStyle(
                                      color: Colors.white , fontSize: 18 ) ,
                                  prefixIcon: Icon(
                                    Icons.search , color: Colors.white , )
                              ) ,
                            ) ,
                          )
                        ] ,
                      )
                    ] ,

                  ) ,
                ) ,
              ) ,
            ) ,
          ) ,
        ) ,
      ); // This trailing comma makes auto-formatting nicer for build methods.
    }
  }
