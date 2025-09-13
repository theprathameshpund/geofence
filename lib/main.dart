import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geofence_service/geofence_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geofence Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GeofenceHomePage(),
    );
  }
}

class GeofenceHomePage extends StatefulWidget {
  const GeofenceHomePage({super.key});

  @override
  State<GeofenceHomePage> createState() => _GeofenceHomePageState();
}

class _GeofenceHomePageState extends State<GeofenceHomePage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // ✅ accuracy expects int (meters), not enum
  final GeofenceService _geofenceService = GeofenceService.instance.setup(
    interval: 5000,
    accuracy: 100, // meters
    loiteringDelayMs: 1000,
    statusChangeDelayMs: 1000,
    useActivityRecognition: false,
    allowMockLocations: true,
  );

  geo.Position? _currentPosition;
  double _radius = 200;
  Geofence? _geofence;

  @override
  void initState() {
    super.initState();
    _initPermissions();
    _initNotifications();
  }

  Future<void> _initPermissions() async {
    await Permission.location.request();
    await Permission.locationAlways.request();
    await Permission.notification.request();
    return;
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);
    return;
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'geofence_channel',
      'Geofence',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      title,
      body,
      platformChannelSpecifics,
    );
    return;
  }

  Future<void> _getCurrentLocation() async {
    _currentPosition = await geo.Geolocator.getCurrentPosition(
      desiredAccuracy: geo.LocationAccuracy.high,
    );

    setState(() {
      _geofence = Geofence(
        id: 'myGeofence',
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        radius: [
          GeofenceRadius(id: 'radius_$_radius', length: _radius),
        ],
      );
    });
    return;
  }

  void _startGeofence() {
    final geofence = _geofence;
    if (geofence == null) return;

    _geofenceService.addGeofenceStatusChangeListener(
          (Geofence geofence, GeofenceRadius geofenceRadius,
          GeofenceStatus geofenceStatus, Location location) async {
        String event;

        switch (geofenceStatus) {
          case GeofenceStatus.ENTER:
            event = "Entered";
            break;
          case GeofenceStatus.EXIT:
            event = "Exited";
            break;
          case GeofenceStatus.DWELL:
            event = "Dwelling";
            break;
          default:
            event = "Unknown";
        }

        await _showNotification(
          "Geofence $event",
          "Time: ${DateTime.now()}\nLat: ${location.latitude}, "
              "Lng: ${location.longitude}",
        );
      },
    );

    _geofenceService.start([geofence]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Geofence App")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text("Set Current Location"),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Radius (meters)"),
              onChanged: (val) {
                setState(() {
                  _radius = double.tryParse(val) ?? 200;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startGeofence,
              child: const Text("Start Geofence"),
            ),
            if (_currentPosition != null)
              Text(
                "Current Location: ${_currentPosition!.latitude}, "
                    "${_currentPosition!.longitude}\nRadius: $_radius m",
              ),
          ],
        ),
      ),
    );
  }
}
