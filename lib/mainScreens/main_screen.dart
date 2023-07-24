import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rideshare_users/assistants/assistant_methods.dart';
import 'package:rideshare_users/assistants/geofire_assistant.dart';
import 'package:rideshare_users/authentication/login_screen.dart';
import 'package:rideshare_users/global/global.dart';
import 'package:rideshare_users/infoHandler/app_info.dart';
import 'package:rideshare_users/main.dart';
import 'package:rideshare_users/mainScreens/rate_driver_screen.dart';
import 'package:rideshare_users/mainScreens/search_places_screen.dart';
import 'package:rideshare_users/mainScreens/select_nearest_active_driver_screen.dart';
import 'package:rideshare_users/models/active_nearby_available_drivers.dart';
import 'package:rideshare_users/models/direction_details_info.dart';
import 'package:rideshare_users/widgets/my_drawer.dart';
import 'package:rideshare_users/widgets/pay_fare_amount_dialog.dart';
import 'package:rideshare_users/widgets/progress_dialog.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
  double waitingResponseFromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

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

  List<ActiveNearbyAvailableDrivers> onlineNearbyAvaibaleDriversList = [];

  DatabaseReference? referenceRideRequest;
  String driverRideStatus = "Driver is Coming...";
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;

  String userRideRequestStatus = "";
  bool requestPositionInfo = true;

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

    AssistantMethods.readTripsKeysForOnlineUser(context);

  }

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowed();
  }

  // Save the ride request information
  saveRideRequestInformation() {

    referenceRideRequest = FirebaseDatabase.instance.ref().child("All Ride Requests").push();

    var originLocation = Provider.of<AppInfo>(context, listen: false).userPickupLocation;
    var destinationLocation = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    Map originLocationMap = {
      "latitude": originLocation!.locationLatitude.toString(),
      "longitude": originLocation!.locationLongitude.toString(),
    };

    Map destinationLocationMap = {
      "latitude": destinationLocation!.locationLatitude.toString(),
      "longitude": destinationLocation!.locationLongitude.toString(),
    };

    Map userInformationMap = {
      "origin": originLocationMap,
      "destination": destinationLocationMap,
      "time": DateTime.now().toString(),
      "userName": userModelCurrentInfo!.name,
      "userPhone": userModelCurrentInfo!.phone,
      "originAddress": originLocation.locationName,
      "destinationAddress": destinationLocation.locationName,
      "driverId": "waiting",
    };

    //save information in database
    referenceRideRequest!.set(userInformationMap);

    tripRideRequestInfoStreamSubscription = referenceRideRequest!.onValue.listen((eventSnap) async {
      if(eventSnap.snapshot.value == null){
        return;
      }

      if((eventSnap.snapshot.value as Map)["car_details"] != null){
        setState(() {
          driverCarDetails = (eventSnap.snapshot.value as Map)["car_details"].toString();
        });
      }

      if((eventSnap.snapshot.value as Map)["driverPhone"] != null){
        setState(() {
          driverPhone = (eventSnap.snapshot.value as Map)["driverPhone"].toString();
        });
      }

      if((eventSnap.snapshot.value as Map)["driverName"] != null){
        setState(() {
          driverName = (eventSnap.snapshot.value as Map)["driverName"].toString();
        });
      }

      if((eventSnap.snapshot.value as Map)["status"] != null){
        userRideRequestStatus = (eventSnap.snapshot.value as Map)["status"].toString();
      }

      if((eventSnap.snapshot.value as Map)["driverLocation"] != null){
        double driverCurrentPositionLat = double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["latitude"].toString());
        double driverCurrentPositionLng = double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["longitude"].toString());

        LatLng driverCurrentPositionLatLng = LatLng(driverCurrentPositionLat, driverCurrentPositionLng);

        // When the status is accepted
        if(userRideRequestStatus == "accepted"){
          updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng);
        }

        // When the status is arrived
        if(userRideRequestStatus == "arrived"){
          setState(() {
            driverRideStatus = "Driver has Arrived";
          });
        }

        // When the status is ontrip
        if(userRideRequestStatus == "ontrip"){
          updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng);
        }

        // When the status is ended
        if(userRideRequestStatus == "ended"){
          if((eventSnap.snapshot.value as Map)["fareAmount"] != null){
            double fareAmount  = double.parse((eventSnap.snapshot.value as Map)["fareAmount"].toString());
            var response = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext c) => PayFareAmountDialog(
                    fareAmount:fareAmount
                ),
            );

            if(response == "cashPayed"){
              // user can rate the driver now
              if((eventSnap.snapshot.value as Map)["driverId"] != null){
                String assignedDriverId = (eventSnap.snapshot.value as Map)["driverId"].toString();
                Navigator.push(context, MaterialPageRoute(builder: (c)=> RateDriverScreen(
                    assignedDriverId: assignedDriverId
                )));

                referenceRideRequest!.onDisconnect();
                tripRideRequestInfoStreamSubscription!.cancel();

              }

            }

          }
        }

      }


    });

    onlineNearbyAvaibaleDriversList = GeofireAssistant.activeNearbyAvailableDriversList;
    searchNearestOnlineDrivers();
  }

  updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng) async {

    if(requestPositionInfo == true){

      requestPositionInfo = false;
      LatLng userPickupPosition = LatLng(
          userCurrentPosition!.latitude,
          userCurrentPosition!.longitude
      );

      var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDetails(
          driverCurrentPositionLatLng,
          userPickupPosition
      );

      if(directionDetailsInfo == null) {
        return;
      }

      setState(() {
        driverRideStatus = "Driver is Coming in :: " + directionDetailsInfo.durarion_text.toString();
      });

      requestPositionInfo = true;
    }
  }

  updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng) async {

    if(requestPositionInfo == true){
      requestPositionInfo = false;

      var dropOffLocation = Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

      LatLng userDestinationPosition = LatLng(
          dropOffLocation!.locationLatitude!,
          dropOffLocation!.locationLongitude!
      );

      var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDetails(
          driverCurrentPositionLatLng,
          userDestinationPosition
      );

      if(directionDetailsInfo == null) {
        return;
      }

      setState(() {
        driverRideStatus = "Reaching in :: " + directionDetailsInfo.durarion_text.toString();
      });

      requestPositionInfo = true;
    }
  }

  searchNearestOnlineDrivers() async {

    // if no driver is online
    if(onlineNearbyAvaibaleDriversList.length == 0) {
      // We have to cancel/delete the ride request

      referenceRideRequest!.remove();

      setState(() {
        polylineSet.clear();
        markersSet.clear();
        circlesSet.clear();
        pLineCoordinateList.clear();
      });

      Fluttertoast.showToast(msg: "No online driver is available, Search again after some time");

      Future.delayed(const Duration(milliseconds: 3000), (){
        //MyApp.restartApp(context);
        SystemNavigator.pop();
      });

      return;
    }

    // if driver is available
    await retrieveOnlineDriversInfo(onlineNearbyAvaibaleDriversList);

    var response = await Navigator.push(context, MaterialPageRoute(builder: (c) => SelectNearestActiveDriverScreen(referenceRideRequest: referenceRideRequest)));

    if(response == "driverChoosed"){
      FirebaseDatabase.instance.ref()
          .child("drivers")
          .child(chosenDriverId!)
          .once().then((snap){
            if(snap.snapshot.value != null) {

              // Send Notification to that specific Driver
              sendNotificationToDriverNow(chosenDriverId!);

              // Display Waiting Response UI from a driver
              showWaitingResponseFromDriverUI();

              // We are waiting for a response from that specific driver
              FirebaseDatabase.instance.ref()
                  .child("drivers")
                  .child(chosenDriverId!)
                  .child("newRideStatus")
                  .onValue.listen((eventSnapshot) {

                // Driver has cancelled the ride Request:: push notification
                if(eventSnapshot.snapshot.value == "idle"){
                  Fluttertoast.showToast(msg: "The driver has cancelled you request, \nPlease choose another driver.");
                  Future.delayed(const Duration(milliseconds: 2000), (){
                    Fluttertoast.showToast(msg: "Please restart the app now");
                    SystemNavigator.pop();
                  });
                }

                // Driver has Accepted the ride request:: push notification
                if(eventSnapshot.snapshot.value == "accepted"){
                  // Design and display UI - driver information

                  showUIForAssignedDriverInfo();

                }
              });
            } else {
              Fluttertoast.showToast(msg: "This Driver don't exist.");
            }
      });
    }
  }

  showUIForAssignedDriverInfo() {
    setState(() {
      searchLocationContainerHeight = 0;
      waitingResponseFromDriverContainerHeight = 0;
      assignedDriverInfoContainerHeight = 250;
    });
  }

  showWaitingResponseFromDriverUI() {

    setState(() {
      searchLocationContainerHeight = 0;
      waitingResponseFromDriverContainerHeight = 220;
    });

  }

  sendNotificationToDriverNow(String chosenDriverId) {

    // Assign ride request ID to  newRideStatus for the specific chosen driver
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("newRideStatus")
        .set(referenceRideRequest!.key);

    // Automate the push notification service
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("token")
        .once()
        .then((snap) {
          if(snap.snapshot.value != null) {
            String deviceRegistrationToken = snap.snapshot.value.toString();
            
            AssistantMethods.sendNotificationToDriverNow(
                deviceRegistrationToken,
                referenceRideRequest!.key.toString(),
                context
            );

            Fluttertoast.showToast(msg: "Notification Sent to Driver Successfully");
            
          } else {
            Fluttertoast.showToast(msg: "Please choose another driver");
            return;
          }
    });

  }

  retrieveOnlineDriversInfo(List onlineNearestDriversList) async {

    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");

    for(int i=0 ; i<onlineNearestDriversList.length ; i++) {
      await ref.child(onlineNearestDriversList[i].driverId.toString())
          .once()
          .then((dataSnapshot){
            var driverKeyInfo = dataSnapshot.snapshot.value;
            dList.add(driverKeyInfo);
      });
    }
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
                  color: Colors.black87,
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
                                style: TextStyle(
                                  color: Color(0xFFff725e),
                                  fontSize: 12,
                                  fontFamily: "Ubuntu",
                                ),
                              ),
                              Text(
                                Provider.of<AppInfo>(context).userPickupLocation != null
                                    ? (Provider.of<AppInfo>(context).userPickupLocation!.locationName!).substring(0, 35) + "..."
                                    : "Your Current Location",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: "Ubuntu",
                                ),
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
                                  style: TextStyle(
                                    color: Color(0xFFff725e),
                                    fontSize: 12,
                                    fontFamily: "Ubuntu",
                                  ),
                                ),
                                Text(
                                  Provider.of<AppInfo>(context).userDropOffLocation != null
                                      ? Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                      : "User Drop off location",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: "Ubuntu",
                                  ),
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
                              fontFamily: "Ubuntu",
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          onPressed: (){
                            if(Provider.of<AppInfo>(context, listen: false).userDropOffLocation != null) {

                              saveRideRequestInformation();

                            } else {
                              Fluttertoast.showToast(msg: "Please select drop off location");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFff725e),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,fontFamily: "Ubuntu"),
                          ),
                        ),
                      )


                    ],
                  ),
                ),

              ),
            ),
          ),

          // UI for Waiting Response from Driver
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: waitingResponseFromDriverContainerHeight,
              decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  )
              ),

              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText(
                        'Waiting for Response \nfrom Driver',
                        duration: const Duration(seconds: 6),
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(
                            fontSize: 30.0,
                            color: Color(0xFFff725e),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Ubuntu"
                        ),
                      ),
                      ScaleAnimatedText(
                        'Please wait...',
                        textAlign: TextAlign.center,
                        duration: const Duration(seconds: 10),
                        textStyle: const TextStyle(
                            fontSize: 32.0,
                            color: Color(0xFFff725e),
                            fontFamily: "Ubuntu"
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ),
          ),

          // UI for Displaying Driver Info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: assignedDriverInfoContainerHeight,
              decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status of the ride
                    Center(
                      child: Text(
                        driverRideStatus,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: "Ubuntu",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFff725e),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10,),

                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Color(0xFFff725e),
                    ),

                    const SizedBox(height: 18,),

                    // Driver Vehicle Details
                    Row(
                      children: [
                        const Icon(Icons.emoji_transportation, color: Color(0xFFff725e), size: 30,),
                        const SizedBox(width: 10,),
                        Text(
                          driverCarDetails,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Ubuntu",
                            color: Color(0xFFff725e),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 2,),

                    // Driver Name
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.white70, size: 30,),
                        const SizedBox(width: 10,),
                        Text(
                          driverName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: "Ubuntu",
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18,),

                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Color(0xFFff725e),
                    ),

                    const SizedBox(height: 20,),

                    // Call Driver Button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: (){

                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFff725e)
                        ),
                        icon: const Icon(
                          Icons.phone_android,
                          color: Colors.white,
                          size: 22,
                        ),
                        label: const Text(
                          "Call Driver",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Ubuntu",
                          ),
                        ),
                      ),
                    ),

                  ],
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

    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });
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
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/carLogo.png").then((value){
        activeNearbyIcon = value;
      });
    }
  }

}
