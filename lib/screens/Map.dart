import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';



class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Define a variable to store the current position
  LatLng currentLocation = LatLng(52.05884, -1.345583);

  // Create a timer that updates the current position every 10 seconds
  Timer? locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    // Start the timer when the widget is initialized
    locationUpdateTimer = Timer.periodic(Duration(seconds: 10), (Timer timer) async {
      // Update the current position
      Position newPosition = await getCurrentLocation();
      setState(() {
        currentLocation = LatLng(newPosition.latitude, newPosition.longitude);
      });
    });
  }
  final start = TextEditingController();
  final end = TextEditingController();
  bool isVisible = false;
  List<LatLng> routpoints = [LatLng(52.05884, -1.345583)];
  List<LatLng> routepoints1 = [LatLng(52.05884, -1.345583)];
  List<LatLng> routepoints2 = [LatLng(52.05884, -1.345583)];
  List<LatLng> routepoints3 = [LatLng(52.05884, -1.345583)];

  getCurrentLocation()async{
    LocationPermission permission = await Geolocator.checkPermission();
        if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever){
          LocationPermission ask = await Geolocator.requestPermission();
        }
        else{
          Position currentposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
          print("Lat: ${currentposition.latitude.toString()}");
          print("Lon: ${currentposition.longitude.toString()}");
          return currentposition;
        }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[500]),
                    onPressed: () async {
                      List<Location> start1 = await locationFromAddress("Sion West, Sion, Mumbai, Maharashtra");
                      List<Location> end1 = await locationFromAddress("Kurla West, Kurla, Mumbai, Maharashtra");

                      var v1_1 = start1[0].latitude;
                      var v2_1 = start1[0].longitude;
                      var v3_1 = end1[0].latitude;
                      var v4_1 = end1[0].longitude;

                      // Route 1
                      var url1 = Uri.parse('http://router.project-osrm.org/route/v1/driving/$v2_1,$v1_1;$v4_1,$v3_1?steps=true&annotations=true&geometries=geojson&overview=full');
                      var response1 = await http.get(url1);
                      print(response1.body);

                      setState(() {
                        routepoints1 = [];
                        var route1 = jsonDecode(response1.body)['routes'][0]['geometry']['coordinates'];
                        for (int i = 0; i < route1.length; i++) {
                          var point = route1[i].toString();
                          point = point.replaceAll("[", "");
                          point = point.replaceAll("]", "");
                          var lat1 = point.split(',');
                          var long1 = point.split(",");
                          routepoints1.add(LatLng(double.parse(lat1[1]), double.parse(long1[0])));
                        }
                      });

                      // Route 2
                      List<Location> start2 = await locationFromAddress("Kurla West, Kurla, Mumbai, Maharashtra");
                      List<Location> end2 = await locationFromAddress("Ghatkopar West, Ghatkopar, Mumbai, Maharashtra");

                      var v1_2 = start2[0].latitude;
                      var v2_2 = start2[0].longitude;
                      var v3_2 = end2[0].latitude;
                      var v4_2 = end2[0].longitude;

                      var url2 = Uri.parse('http://router.project-osrm.org/route/v1/driving/$v2_2,$v1_2;$v4_2,$v3_2?steps=true&annotations=true&geometries=geojson&overview=full');
                      var response2 = await http.get(url2);
                      print(response2.body);

                      setState(() {
                        routepoints2 = [];
                        var route2 = jsonDecode(response2.body)['routes'][0]['geometry']['coordinates'];
                        for (int i = 0; i < route2.length; i++) {
                          var point = route2[i].toString();
                          point = point.replaceAll("[", "");
                          point = point.replaceAll("]", "");
                          var lat2 = point.split(',');
                          var long2 = point.split(",");
                          routepoints2.add(LatLng(double.parse(lat2[1]), double.parse(long2[0])));
                        }
                      });

                      // Route 3
                      List<Location> start3 = await locationFromAddress("Ghatkopar West, Ghatkopar, Mumbai, Maharashtra");
                      List<Location> end3 = await locationFromAddress("Vikhroli West, Vikhroli, Mumbai, Maharashtra");

                      var v1_3 = start3[0].latitude;
                      var v2_3 = start3[0].longitude;
                      var v3_3 = end3[0].latitude;
                      var v4_3 = end3[0].longitude;

                      var url3 = Uri.parse('http://router.project-osrm.org/route/v1/driving/$v2_3,$v1_3;$v4_3,$v3_3?steps=true&annotations=true&geometries=geojson&overview=full');
                      var response3 = await http.get(url3);
                      print(response3.body);

                      setState(() {
                        routepoints3 = [];
                        var route3 = jsonDecode(response3.body)['routes'][0]['geometry']['coordinates'];
                        for (int i = 0; i < route3.length; i++) {
                          var point = route3[i].toString();
                          point = point.replaceAll("[", "");
                          point = point.replaceAll("]", "");
                          var lat3 = point.split(',');
                          var long3 = point.split(",");
                          routepoints3.add(LatLng(double.parse(lat3[1]), double.parse(long3[0])));
                        }
                      });

                      isVisible = !isVisible;
                    },

                    child: Text("Lets Start")),
                SizedBox(height: 10,),
                SizedBox(
                  height: 500,
                  width: 400,
                  child: Visibility(
                    visible: isVisible,
                    child: FlutterMap(options:
                    MapOptions(
                      center: routepoints1[0],
                      zoom: 17,
                    ),
                      nonRotatedChildren: [
                        AttributionWidget.defaultWidget(source: 'OpenStreetMap contributors',
                            onSourceTapped: null),
                      ],
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        PolylineLayer(
                          polylineCulling: false,
                          polylines: [
                            Polyline(points: routepoints1, color: Colors.blue, strokeWidth: 9),
                            Polyline(points: routepoints2, color: Colors.red, strokeWidth: 9),
                            Polyline(points: routepoints3, color: Colors.green, strokeWidth: 9)
                          ],
                        ),
                        CircleLayer(
                          circles: [
                            CircleMarker(
                              point: routepoints1[0],
                              color: Colors.blue.withOpacity(0.3),
                              radius: 100,
                              useRadiusInMeter: true,
                            ),
                            CircleMarker(
                              point: routepoints2[0],
                              color: Colors.red.withOpacity(0.3),
                              radius: 100,
                              useRadiusInMeter: true,
                            ),
                            CircleMarker(
                              point: routepoints3[0],
                              color: Colors.green.withOpacity(0.3),
                              radius: 100,
                              useRadiusInMeter: true,
                            ),
                            CircleMarker(
                              point: currentLocation,
                              color: Colors.black.withOpacity(0.8),
                              radius: 20,
                              useRadiusInMeter: true,
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

