import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rideshare_users/assistants/assistant_methods.dart';
import 'package:rideshare_users/authentication/login_screen.dart';
import 'package:rideshare_users/global/global.dart';
import 'package:rideshare_users/infoHandler/app_info.dart';
import 'package:rideshare_users/mainScreens/search_places_screen.dart';
import 'package:rideshare_users/widgets/my_drawer.dart';

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
    print("this is your address = " + humanReadableAddress);
  }

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 265,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Color(0xFF2D2727),
          ),
          child: MyDrawer(
            name: userModelCurrentInfo?.name,
            email: userModelCurrentInfo?.email,
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
                        onTap: (){
                          // go to search places screen
                          var responseFromSearchScreen = Navigator.push(context, MaterialPageRoute(builder: (c)=> SearchPlacesScreen()));

                          if(responseFromSearchScreen == "obtainedDropoff") {
                            // Draw Routes - Polyline
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
}
