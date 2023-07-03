import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rideshare_users/assistants/assistant_methods.dart';
import 'package:rideshare_users/assistants/geofire_assistant.dart';
import 'package:rideshare_users/authentication/login_screen.dart';
import 'package:rideshare_users/global/global.dart';
import 'package:rideshare_users/infoHandler/app_info.dart';
import 'package:rideshare_users/mainScreens/search_places_screen.dart';
import 'package:rideshare_users/models/active_nearby_available_drivers.dart';
import 'package:rideshare_users/widgets/my_drawer.dart';
import 'package:rideshare_users/widgets/progress_dialog.dart';

class MainScreen extends StatefulWidget {

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final Completer<GoogleMapController> _controllerGoogleMap = Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 220.0;

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoordinateList = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String userName = "Your Name";
  String userEmail = "Your Email";

  bool activeNearbyDriverKeyLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  //Black Theme Google Maps
  blackThemeGoogleMap(){
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  //Check if user current Location permission is allowed or not
  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied){
      _locationPermission = await Geolocator.requestPermission();
    }

  }

  //Get user current position latitude and longitude
  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition,zoom: 16);
    
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinated(userCurrentPosition!, context);
    print("*************\nAddress: " + humanReadableAddress);
    
    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    initializeGeoFireListner();
  }

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {

    createActiveNearbyIconMarker();

    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 265,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Color(0xFF2D2727),
          ),
          child: MyDrawer(
            name: userName,
            email: userEmail,
          ),
        ),
      ),
      body: Stack(
        children: [

          //Google Map Screen
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: polylineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              //for google map black theme
              blackThemeGoogleMap();

              setState(() {
                bottomPaddingOfMap = 217;
              });

              locateUserPosition();

            },
          ),

          // Custom hamburger Button for Drawer
          Positioned(
            top: 35,
            left: 15,
            child: GestureDetector(
              onTap: (){
                sKey.currentState!.openDrawer();
              },
              child: const CircleAvatar(
                backgroundColor: Colors.black54,
                radius: 25,
                child: CircleAvatar(
                  backgroundColor: Color(0xFFff725e),
                  radius: 20,
                  child: Icon(
                    Icons.menu,
                    color: Colors.black87,
                    size: 25,
                  ),
                ),

              ),
            ),
          ),

          // UI for searching, FROM Location, To Location and Request a Ride button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(microseconds: 120),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  )
                ),

                child: Padding(

                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    children: [

                      //from Location
                      Row(
                        children: [
                          const Icon(Icons.add_location_alt_rounded, color: Color(0xFFff725e), size: 35,),
                          const SizedBox(width: 12,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "From",
                                style: TextStyle(color: Color(0xFFff725e), fontSize: 12,),
                              ),
                              Text(
                                Provider.of<AppInfo>(context).userPickupLocation != null
                                    ? (Provider.of<AppInfo>(context).userPickupLocation!.locationName!).substring(0, 35) + "..."
                                    : "Your Current Location",
                                style: const TextStyle(color: Colors.white, fontSize: 15,),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10,),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFff725e),
                      ),

                      const SizedBox(height: 16,),

                      //To Location
                      GestureDetector(
                        onTap: () async {
                          // go to search places screen
                          var responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (c)=> SearchPlacesScreen()));

                          if(responseFromSearchScreen == "obtainedDropoff") {
                            // Draw Routes - Polyline
                            await drawPolylineFromOriginToDestination();
                          }

                        },
                        child: Row(
                          children: [
                            const Icon(Icons.add_location_alt_rounded, color: Color(0xFFff725e), size: 35,),
                            const SizedBox(width: 12,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "To",
                                  style: TextStyle(color: Color(0xFFff725e), fontSize: 12,),
                                ),
                                Text(
                                  Provider.of<AppInfo>(context).userDropOffLocation != null
                                      ? Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                      : "User Drop off location",
                                  style: const TextStyle(color: Colors.white, fontSize: 15,),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10,),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFff725e),
                      ),

                      const SizedBox(height: 16,),

                      // Request a Ride button
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          child: const Text(
                            "Request a Ride",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: (){

                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFff725e),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )


                    ],
                  ),
                ),

              ),
            ),
          ),

        ],
      ),
    );
  }

  Future<void> drawPolylineFromOriginToDestination() async {
    var sourcePosition = Provider.of<AppInfo>(context, listen: false).userPickupLocation;
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var sourceLatLng = LatLng(sourcePosition!.locationLatitude!, sourcePosition!.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!, destinationPosition!.locationLongitude!);

    showDialog(
        context: context,
        builder: (BuildContext context)=> ProgressDialog(message: "Please wait...",),
    );
    
    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDetails(sourceLatLng, destinationLatLng);

    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyPointList = pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    pLineCoordinateList.clear();

    if(decodedPolyPointList.isNotEmpty) {
      decodedPolyPointList.forEach((PointLatLng pointLatLng) {
        pLineCoordinateList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: const Color(0xFFff725e),
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinateList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if(sourceLatLng.latitude > destinationLatLng.latitude
        && sourceLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(southwest: destinationLatLng, northeast: sourceLatLng);
    } else if(sourceLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(sourceLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, sourceLatLng.longitude),
      );
    } else if(sourceLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, sourceLatLng.longitude),
        northeast: LatLng(sourceLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng = LatLngBounds(southwest: sourceLatLng, northeast: destinationLatLng);
    }
    
    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));
    
    Marker originMarker = Marker(
      markerId: MarkerId("originID"),
      infoWindow: InfoWindow(title: sourcePosition.locationName, snippet: "Origin"),
      position: sourceLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId("destinationID"),
      infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: CircleId("originID"),
      fillColor: const Color(0xFFff725e),
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: sourceLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId("destinationID"),
      fillColor: const Color(0xFFff725e),
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
    
  }

  initializeGeoFireListner() {

    Geofire.initialize("activeDrivers");

    Geofire.queryAtLocation(userCurrentPosition!.latitude, userCurrentPosition!.longitude, 1000)!
        .listen((map) {
          print(map);
          if (map != null) {
            var callBack = map['callBack'];

            //latitude will be retrieved from map['latitude']
            // longitude will be retrieved from map['longitude']

            switch (callBack) {

              // Whenever any driver becomes active or online
              case Geofire.onKeyEntered:
                ActiveNearbyAvailableDrivers activeNearbyAvailableDriver = ActiveNearbyAvailableDrivers();
                activeNearbyAvailableDriver.locationLatitude = map['latitude'];
                activeNearbyAvailableDriver.locationLongitude = map['longitude'];
                activeNearbyAvailableDriver.driverId = map['key'];
                GeofireAssistant.activeNearbyAvailableDriversList.add(activeNearbyAvailableDriver);

                if(activeNearbyDriverKeyLoaded == true) {
                  displayActiveDriversOnUserMap();
                }

                break;

              // Whenever any driver becomes inactive or offline
              case Geofire.onKeyExited:
                GeofireAssistant.deleteOfflineDriverFromList(map['key']);
                displayActiveDriversOnUserMap();
                break;

              // Whenever Driver moves - update driver location
              case Geofire.onKeyMoved:
                ActiveNearbyAvailableDrivers activeNearbyAvailableDriver = ActiveNearbyAvailableDrivers();
                activeNearbyAvailableDriver.locationLatitude = map['latitude'];
                activeNearbyAvailableDriver.locationLongitude = map['longitude'];
                activeNearbyAvailableDriver.driverId = map['key'];
                GeofireAssistant.updateActiveNearbyAvailableDriverLocation(activeNearbyAvailableDriver);
                displayActiveDriversOnUserMap();
                break;

              // Display Online/active Drivers on Users MAP (UI)
              case Geofire.onGeoQueryReady:
                activeNearbyDriverKeyLoaded = true;
                displayActiveDriversOnUserMap();
                break;
            }
          }

          setState(() {});
        });
  }

  displayActiveDriversOnUserMap() {

    setState(() {
      markersSet.clear();
      circlesSet.clear();

      Set<Marker> driversMarkerSet = Set<Marker>();

      for(ActiveNearbyAvailableDrivers eachDriver in GeofireAssistant.activeNearbyAvailableDriversList) {
        LatLng eachDriverActivePosition = LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driversMarkerSet.add(marker);

      }

      setState(() {
        markersSet = driversMarkerSet;
      });

    });
  }

  createActiveNearbyIconMarker() {
    if(activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car.png").then((value){
        activeNearbyIcon = value;
      });
    }
  }

}
