import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speedometer & Location',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpeedLocationScreen(),
    );
  }
}

class SpeedLocationScreen extends StatefulWidget {
  @override
  _SpeedLocationScreenState createState() => _SpeedLocationScreenState();
}

class _SpeedLocationScreenState extends State<SpeedLocationScreen> {
  Location _location = Location();
  double _speed = 0.0;
  double _latitude = 0.0;
  double _longitude = 0.0;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _speed = currentLocation.speed ?? 0.0;
        _latitude = currentLocation.latitude ?? 0.0;
        _longitude = currentLocation.longitude ?? 0.0;
      });
    });
  }

  Future<void> _checkLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speed & Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Speed: ${_speed.toStringAsFixed(2)} m/s',
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 20),
            Text(
              'Latitude: $_latitude',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Longitude: $_longitude',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
