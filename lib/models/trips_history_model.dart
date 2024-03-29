import 'package:firebase_database/firebase_database.dart';

class TripsHistoryModel{

  String? time;
  String? originAddress;
  String? destinationAddress;
  String? status;
  String? fareAmount;
  String? driverName;
  String? car_details;

  TripsHistoryModel({
    this.time,
    this.originAddress,
    this.destinationAddress,
    this.status,
    this.fareAmount,
    this.driverName,
    this.car_details
  });

  TripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot){
    time = (dataSnapshot.value as Map)["time"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    status = (dataSnapshot.value as Map)["status"];
    fareAmount = (dataSnapshot.value as Map)["fareAmount"];
    driverName = (dataSnapshot.value as Map)["driverName"];
    car_details = (dataSnapshot.value as Map)["car_details"];
  }

}