import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

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

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied: $text')),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _speedKmh = _speed * 3.6;

    return Scaffold(
      appBar: AppBar(
        title: Text('Speedometer & Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Geschwindigkeit in m/s
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Speed (m/s)',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        SelectableText(
                          '${_speed.toStringAsFixed(2)} m/s',
                          style: TextStyle(fontSize: 48, color: Colors.blue),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () => _copyToClipboard('${_speed.toStringAsFixed(2)} m/s'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Geschwindigkeit in km/h
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Speed (km/h)',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        SelectableText(
                          '${_speedKmh.toStringAsFixed(2)} km/h',
                          style: TextStyle(fontSize: 48, color: Colors.green),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () => _copyToClipboard('${_speedKmh.toStringAsFixed(2)} km/h'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Latitude und Longitude in einer Card
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        SelectableText(
                          'Latitude: $_latitude\nLongitude: $_longitude',
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () => _copyToClipboard('$_latitude, $_longitude'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // TextField below the last card
            TextField(
              decoration: InputDecoration(
              labelText: 'Made with ❤️, under MIT-license',
              border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
