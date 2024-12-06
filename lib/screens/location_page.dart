// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late GoogleMapController mapController;
  LatLng _currentPosition = LatLng(0, 0);
  LatLng _selectedPosition = LatLng(0, 0);
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Location location = Location();
    LocationData currentLocation;

    try {
      currentLocation = await location.getLocation();
      setState(() {
        _currentPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _selectedPosition = _currentPosition;
      });
    } catch (e) {
      print("Error retrieving location: $e");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _selectedPosition = position.target;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Location'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 14.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('selectedLocation'),
                  position: _selectedPosition,
                  draggable: true,
                  onDragEnd: (newPosition) {
                    setState(() {
                      _selectedPosition = newPosition;
                    });
                  },
                ),
              },
              onCameraMove: _onCameraMove,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selected Location:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                    'Latitude: ${_selectedPosition.latitude.toStringAsFixed(6)}'),
                Text(
                    'Longitude: ${_selectedPosition.longitude.toStringAsFixed(6)}'),
                SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Additional Notes',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'location': _selectedPosition,
                          'notes': _notesController.text,
                        });
                      },
                      child: Text('Confirm Location'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back to Cart'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
