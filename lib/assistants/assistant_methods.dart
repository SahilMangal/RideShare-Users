import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rideshare_users/assistants/request_assistant.dart';
import 'package:rideshare_users/global/global.dart';
import 'package:rideshare_users/global/map_key.dart';
import 'package:rideshare_users/infoHandler/app_info.dart';
import 'package:rideshare_users/models/direction_details_info.dart';
import 'package:rideshare_users/models/directions.dart';
import 'package:rideshare_users/models/user_model.dart';
import 'package:http/http.dart' as http;

class AssistantMethods{

  static Future<String> searchAddressForGeographicCoordinated(Position position, context) async {

    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress="";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);
    if(requestResponse != "Error Occurred, No Response."){
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickupAddress = Directions();
      userPickupAddress.locationLatitude = position.latitude;
      userPickupAddress.locationLongitude = position.longitude;
      userPickupAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickupLocationAddress(userPickupAddress);


    }
    return humanReadableAddress;
  }

  static void readCurrentOnlineUserInfo() async{
    currentFirebaseUser = fAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap){
      if(snap.snapshot.value != null){
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<DirectionDetailsInfo?> obtainOriginToDestinationDetails(LatLng originPosition, LatLng destinationPosition) async {
    String urlObtainOriginToDestinationDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionsApi =  await RequestAssistant.receiveRequest(urlObtainOriginToDestinationDetails);

    if (responseDirectionsApi == "Error Occurred, No Response.") {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points = responseDirectionsApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionsApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionsApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.durarion_text = responseDirectionsApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionsApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static double calculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo) {
    double timeTravelFareAmountPerMinute = (directionDetailsInfo.duration_value! / 60) * 0.9;
    double distanceTraveledFareAmountPerKilometer = (directionDetailsInfo.distance_value! / 1000) * 0.9;

    double totalFareAmount = timeTravelFareAmountPerMinute + distanceTraveledFareAmountPerKilometer;

    return double.parse(totalFareAmount.toStringAsFixed(1)) ;
  }

  static sendNotificationToDriverNow(String deviceRegistrationToken, String userRideRequestId, context) async {

    String destinationAddress = userDropOffAddress;

    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
    };

    Map bodyNotification = {
      "body":"Destination Address: \n$destinationAddress.",
      "title":"New Ride Request"
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "rideRequestId": userRideRequestId
    };

    Map officialNotificationFormat = {
      "notification": bodyNotification,
      "data": dataMap,
      "priority":"high",
      "to": deviceRegistrationToken
    };

    var responseNotification = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );

  }

}