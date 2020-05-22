import 'dart:async';
import 'dart:typed_data';

import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'distance.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AMBU MAPS',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'AMBU MAPS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final latitudeambu = 18.560757;
  final longitudeambu = 73.918210;
  final latitudeambu1 = 18.561950;
  final longitudeambu1 = 73.922761;
  var userlocation;

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  List<Marker> marker = [];
  List<Circle> circle = [];
  GoogleMapController _controller;
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  //added
  Future<Uint8List> getMarkerambu() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/amb.jpg");
    return byteData.buffer.asUint8List();
  }

  //finish
  Future<Uint8List> getMarkerambu1() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/amb.jpg");
    return byteData.buffer.asUint8List();
  }

  Future<Uint8List> getMarkerambu2() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/amb.jpg");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker.add(Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData)));
      circle.add(Circle(
          circleId: CircleId("car"),
          radius: 80.0,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70)));
    });
  }

  //started
  void updateMarkerAndCircleambu(Uint8List imageDataambu) {
    LatLng latlng = LatLng(18.560757, 73.918210);
    this.setState(() {
      marker.add(Marker(
          markerId: MarkerId("ambu"),
          position: latlng,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageDataambu)));
      circle.add(Circle(
          circleId: CircleId("ambulance"),
          zIndex: 1,
          radius: 80.0,
          strokeColor: Colors.red,
          center: latlng,
          fillColor: Colors.red.withAlpha(70)));
    });
  }

  //finished
  void updateMarkerAndCircleambu1(Uint8List imageDataambu1) {
    LatLng latlng = LatLng(18.561998, 73.922761);
    this.setState(() {
      marker.add(Marker(
          markerId: MarkerId("ambu1"),
          position: latlng,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageDataambu1)));
      circle.add(Circle(
          circleId: CircleId("ambulance1"),
          zIndex: 1,
          radius: 79.0,
          strokeColor: Colors.red,
          center: latlng,
          fillColor: Colors.red.withAlpha(70)));
    });
  }

  void updateMarkerAndCircleambu2(Uint8List imageDataambu2) {
    LatLng latlng = LatLng(18.553867, 73.918286);
    this.setState(() {
      marker.add(Marker(
          markerId: MarkerId("ambu2"),
          position: latlng,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageDataambu2)));
      circle.add(Circle(
          circleId: CircleId("ambulance2"),
          zIndex: 1,
          radius: 80.0,
          strokeColor: Colors.red,
          center: latlng,
          fillColor: Colors.red.withAlpha(70)));
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
      userlocation = location;
      updateMarkerAndCircle(location, imageData);
      Uint8List imageDataambu = await getMarkerambu();
      Uint8List imageDataambu1 = await getMarkerambu1();
      Uint8List imageDataambu2 = await getMarkerambu1();

      updateMarkerAndCircleambu(imageDataambu);
      updateMarkerAndCircleambu1(imageDataambu1);
      updateMarkerAndCircleambu2(imageDataambu2);

      Calculatedistance calculatedistance = Calculatedistance();
      double distancebetween = calculatedistance.meteredistance(
          location.latitude, location.longitude);
      if (distancebetween < 2000.00) {
        EdgeAlert.show(
          context,
          title: 'Ambulance Near You',
          description:
              'Ambulance is within 2 km range please be aware and make way for them',
          gravity: EdgeAlert.TOP,
          backgroundColor: Colors.redAccent,
          duration: EdgeAlert.LENGTH_VERY_LONG,
        );
      }

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 15.60)));
          updateMarkerAndCircle(newLocalData, imageData);
          updateMarkerAndCircleambu(imageDataambu);
          updateMarkerAndCircleambu1(imageDataambu1);
          updateMarkerAndCircleambu2(imageDataambu2);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: initialLocation,
        markers: Set.from(marker),
        circles: Set.of(circle),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: () {
            getCurrentLocation();
          }),
    );
  }
}
