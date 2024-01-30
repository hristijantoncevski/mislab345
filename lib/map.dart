import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mis3/exam.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mis3/locationPermissions.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final List<Exam> exams;
  final bool allowAddMarkers;
  final Function(double, double)? onLocationSelected;

  const MapScreen({Key? key, required this.exams, this.onLocationSelected, this.allowAddMarkers = false}): super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> markers = [];
  int markerIndex = 0;
  List<Marker> homeMarkers = [];
  Marker? currentLocation;
  MapController mapController = MapController();
  Future<void>? _launched;

  @override
  void initState() {
    super.initState();
    if(!widget.allowAddMarkers){
      addMarkers();

    }
  }

  void addMarkers() async {
    await Geolocator.requestPermission();
    Position currentPosition = await Geolocator.getCurrentPosition();
    double originLatitude = currentPosition.latitude;
    double originLongitude = currentPosition.longitude;

    setState(() {
      markers = markers;
    });

    for(Exam exam in widget.exams) {
      markers.add(
        Marker(
          width: 80,
          height: 80,
          point: LatLng(exam.location.latitude, exam.location.longitude),
          child: GestureDetector(
            onTap: () async {
              return showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: const Text('Open Google Maps to this location?'),
                    content: Text('Subject: ${exam.subject}, Date: ${exam.date}. Time: ${exam.time}'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            _launched = launchGoogleUrl(originLatitude,originLongitude,exam.location.latitude, exam.location.longitude);
                          },
                        child: const Text('Open')
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                }
              );
            },
            child: const Icon(Icons.location_on, color: Colors.red, size: 50),
          ),
        ),
      );
    }
  }

  Future<void> launchGoogleUrl(double originLatitude, double originLongitude ,double latitude, double longitude) async {
    var googleMapsUrl = Uri.parse("https://www.google.com/maps/dir/?api=1&origin=$originLatitude,$originLongitude&destination=$latitude,$longitude");
    if(await canLaunchUrl(googleMapsUrl)){
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(googleMapsUrl, mode: LaunchMode.inAppWebView);
    }
  }

  Future<Position> getCurrentLocation() async {
    await LocationPermissions().getPermissions();

    return LocationPermissions().getCurrentLocation();
  }

  void showNextMarkerLocation() {
    print('Clicked');
    if(markers.isNotEmpty) {
      markerIndex = (markerIndex + 1) % markers.length;
      LatLng latlng = markers[markerIndex].point;
      mapController.move(latlng, 16);
      print('${latlng.latitude}, ${latlng.longitude}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam Map')),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          onTap: widget.allowAddMarkers ?
              (tapPos,latlng) {
                setState(() {
                  markers.clear();
                  markers.add(
                    Marker(
                      width: 80,
                      height: 80,
                      point: latlng,
                      child: const Icon(Icons.location_on, color: Colors.red, size: 50),
                    )
                  );
                });
          } : null,
          initialCenter: const LatLng(42.004030121372125, 21.40941232974244),
          initialZoom: 17,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(markers: markers),
          MarkerLayer(markers: homeMarkers),
        ],
      ),
      floatingActionButton: widget.allowAddMarkers ?
      FloatingActionButton(
        onPressed: () {
          if(markers.isNotEmpty && widget.onLocationSelected != null) {
            widget.onLocationSelected!(
              markers.last.point.latitude,
              markers.last.point.longitude,
            );
          }
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ) : Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: showNextMarkerLocation,
            child: const Icon(Icons.navigate_next, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () async {
              getCurrentLocation().then((value) async {
                print("${value.latitude}, ${value.longitude}");

                LatLng center = LatLng(value.latitude, value.longitude);
                mapController.move(center, 16);

                setState(() {
                  homeMarkers.add(
                    Marker(
                      width: 80,
                      height: 80,
                      point: center,
                      child: const Icon(Icons.home_filled, color: Colors.yellowAccent, size: 50),
                    ),
                  );
                });
              });
            },
            child: const Icon(Icons.home_filled, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
