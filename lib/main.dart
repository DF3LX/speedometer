import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speedometer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpeedScreen(),
    );
  }
}

class SpeedScreen extends StatefulWidget {
  @override
  _SpeedScreenState createState() => _SpeedScreenState();
}

class _SpeedScreenState extends State<SpeedScreen> {
  Location _location = Location();
  double _speed = 0.0;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _speed = currentLocation.speed ?? 0.0;
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
        title: Text('Speedometer'),
      ),
      body: Center(
        child: Text(
          '${_speed.toStringAsFixed(2)} m/s',
          style: TextStyle(fontSize: 48),
        ),
      ),
    );
  }
}
