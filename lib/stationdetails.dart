// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StationDetails extends StatefulWidget {
  final String stationName;
  final int noOfStations;
  final List stationDetails;
  const StationDetails({ Key? key, required this.stationName, required this.noOfStations, required this.stationDetails }) : super(key: key);

  @override
  State<StationDetails> createState() => _StationDetailsState();
}

class _StationDetailsState extends State<StationDetails> {

  @override
  void initState(){
    super.initState();
    setDatas();
  }

  void setDatas(){
    for (var i = 0; i < widget.stationDetails.length; i++) {
      if(widget.stationDetails[i]['city'] == widget.stationName){
        stationName.add(widget.stationDetails[i]['station_name']);
        status.add(widget.stationDetails[i]['status_code']);
        access.add(widget.stationDetails[i]['access_code']);
        fuelType.add(widget.stationDetails[i]['fuel_type_code']);
        ownerType.add(widget.stationDetails[i]['owner_type_code']);
        address.add(widget.stationDetails[i]['street_address']);
        available.add(widget.stationDetails[i]['access_days_time'] ?? 'N/A');
        phone.add(widget.stationDetails[i]['station_phone'] ?? 'N/A');
        connectorTypes.add(widget.stationDetails[i]['ev_connector_types'] ?? ['N/A']);
        locations.add('https://maps.google.com/?q=${widget.stationDetails[i]['latitude']},${widget.stationDetails[i]['longitude']}');
      }
    }
    print(connectorTypes);
    setState(() {
      isLoaded = true;
    });
  }

  List<String> fuelType = [];
  List<String> ownerType = [];
  List<String> status = [];
  List<String> access = [];
  List<String> stationName = [];
  List<String> locations = [];
  List<String> address = [];
  List<String> available = [];
  List<List<dynamic>> connectorTypes = [];
  List<String> phone = [];
  bool isLoaded = false;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.stationName,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(10),
                  // border: Border.all(
                  //   color: Colors.grey.shade300,
                  //   width: 1,
                  // ),
                  image: DecorationImage(image: AssetImage('assets/evcharger.png'), fit: BoxFit.contain)
                ),
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: Text(
                "Stations in ${widget.stationName}",
                style: TextStyle(
                  fontSize: 20,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 100,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: isLoaded ? access.length : 0,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 15,),
                        Container(
                          width: 150,
                          height: 90,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: selectedIndex == index ? Colors.grey[300] : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                              width: 0.4,
                            ),
                          ),
                          child: Text(
                            stationName[index],
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        SizedBox(width: 15,)
                      ],
                    ),
                  );
                }
              ),
            ),
            SizedBox(height: 20,),
            Text(
              "Station Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 15,),
                      Text(
                        "Fuel Type",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                      Spacer(),
                      Text(
                        fuelType[selectedIndex],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        ),
                      ),
                      SizedBox(width: 15,),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      SizedBox(width: 15,),
                      Text(
                        "Owner Type",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                      Spacer(),
                      Text(
                        ownerType[selectedIndex] == 'P' ? 'Private' : ownerType[selectedIndex] == 'FG' ? 'Federal Government' : ownerType[selectedIndex] == 'J' ? 'Jointly Owned' : ownerType[selectedIndex] == 'LG' ? 'Local Government' : ownerType[selectedIndex] == 'SG' ? 'State Government' : ownerType[selectedIndex] == 'T' ? 'Utility Owned' : 'N/A',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        ),
                      ),
                      SizedBox(width: 15,),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      SizedBox(width: 15,),
                      Text(
                        "Status",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                      Spacer(),
                      Text(
                        status[selectedIndex] == 'E' ? 'Available' : status[selectedIndex] == 'P' ? 'Planned' : status[selectedIndex] == 'T' ? 'Temporarily Unavailable' : 'N/A',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        ),
                      ),
                      SizedBox(width: 15,),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      SizedBox(width: 15,),
                      Text(
                        "Access",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                      Spacer(),
                      Text(
                        access[selectedIndex] == 'public' ? 'Public' : access[selectedIndex] == 'private' ? 'Private' : 'N/A',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        ),
                      ),
                      SizedBox(width: 15,),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      SizedBox(width: 15,),
                      Text(
                        "Connectors",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                      SizedBox(width: 15,),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      SizedBox(width: 15,),
                      Text(
                        connectorTypes[selectedIndex].toString().replaceAll('[', '').replaceAll(']', ''),
                        style: TextStyle(
                          fontSize: 13,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                      SizedBox(width: 15,),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      SizedBox(width: 15,),
                      Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                      Spacer(),
                      Text(
                        address[selectedIndex],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        ),
                      ),
                      SizedBox(width: 15,),
                    ],
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: () async{
                      await launch(locations[selectedIndex]);
                    },
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        SizedBox(width: 15,),
                        Text(
                          "View location on Google Maps",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}