// ignore_for_file: prefer_collection_literals, prefer_const_constructors, deprecated_member_use

import 'dart:convert';
import 'dart:math' as math;
import 'package:ev_stations/stationdetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<String> cities = [];
  // List<String> types = [];
  // List<String> access = [];
  // List<String> stationName = [];
  // List<String> zips = [];
  // List<String> address = [];
  // List<List<String>> connectorType = [];
  // List<String> ownerType = [];
  // List<String> accessTime = [];
  bool isLoaded = false;
  var map = Map();
  Set<int> setOfInts = Set();
  var jsonResult;

  Future<void> loadJson() async {
    String data = await rootBundle.loadString('assets/dataset.json');
    jsonResult = json.decode(data);
    jsonResult = jsonResult['fuel_stations'];
    for (var i = 0; i < jsonResult.length; i++) {
      cities.add(jsonResult[i]['city']);
      // types.add(jsonResult[i]['station_type'] ?? 'N/A');
      // access.add(jsonResult[i]['access_days_time'] ?? 'N/A');
      // stationName.add(jsonResult[i]['station_name'] ?? 'N/A');
      // zips.add(jsonResult[i]['zip'] ?? 'N/A');
      // address.add(jsonResult[i]['street_address'] ?? 'N/A');
      // connectorType.add(jsonResult[i]['connector_type'] ?? ['N/A']);
      // ownerType.add(jsonResult[i]['owner_type'] ?? 'N/A');
      // accessTime.add(jsonResult[i]['access_time'] ?? 'N/A');
    }

    for (var element in cities) {
      if(!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] +=1;
      }
    }

    setState(() {
      jsonResult = jsonResult;
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await loadJson();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          'Charging Stations',
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: ListView.builder(
                itemCount: isLoaded ? map.keys.length + 1 : 0,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if(index == 0){
                    return SizedBox(
                      height: 1,
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            isThreeLine: true,
                            leading: Icon(Icons.album),
                            title: Text(
                              map.keys.elementAt(index - 1).toString(),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "No of Stations Available:\t"+map.values.elementAt(index - 1).toString()+"\n",
                              style: TextStyle(
                                // fontSize: 13,
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                                child: GestureDetector(
                                  child: const Text(
                                    'VIEW STATIONS',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StationDetails(
                                              stationName: map.keys.elementAt(index - 1).toString(), noOfStations: map.values.elementAt(index - 1), stationDetails: jsonResult, 
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}