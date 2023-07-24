import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rideshare_users/assistants/assistant_methods.dart';
import 'package:rideshare_users/global/global.dart';
import 'package:rideshare_users/main.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class SelectNearestActiveDriverScreen extends StatefulWidget {

  DatabaseReference? referenceRideRequest;

  SelectNearestActiveDriverScreen({this.referenceRideRequest});

  @override
  State<SelectNearestActiveDriverScreen> createState() => _SelectNearestActiveDriverScreenState();
}

class _SelectNearestActiveDriverScreenState extends State<SelectNearestActiveDriverScreen> {

  String fareAmount = "";
  getFareAmountAccordingToVehicleType(int index) {
    if(tripDirectionDetailsInfo != null) {
      if(dList[index]["car_details"]["type"].toString() == "bike") {
        fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) / 2).toStringAsFixed(1);
      } if(dList[index]["car_details"]["type"].toString() == "Car") {
        fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!)).toString();
      } if(dList[index]["car_details"]["type"].toString() == "Car-XL") {
        fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) * 2).toStringAsFixed(1);
      }
    }
    return fareAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2727),
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text(
          "Nearest Active Drivers",
          style: TextStyle(
            fontSize: 18,

          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: (){
            // Delete/remove the ride request from database
            widget.referenceRideRequest!.remove();
            Fluttertoast.showToast(msg: "You have cancelled the ride request");

            //MyApp.restartApp(context);
            SystemNavigator.pop();

          },
        ),
      ),
      body: ListView.builder(
        itemCount: dList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              setState(() {
                chosenDriverId = dList[index]["id"].toString();
              });

              Navigator.pop(context, "driverChoosed");

            },
            child: Card(
              color: Color(0xFFff725e),
              elevation: 3,
              shadowColor: Colors.green,
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Image.asset(
                    "images/" + dList[index]["car_details"]["type"].toString() + ".png",
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      dList[index]["name"],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dList[index]["car_details"]["car_model"],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),
                    SmoothStarRating(
                      rating: dList[index]["ratings"] == null ? 0.0 : double.parse(dList[index]["ratings"]),
                      color: Colors.black,
                      borderColor: Colors.black,
                      allowHalfRating: true,
                      starCount: 5,
                      size: 15,
                    )
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "\$ " + getFareAmountAccordingToVehicleType(index),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2,),
                    Text(
                      tripDirectionDetailsInfo != null
                          ? tripDirectionDetailsInfo!.durarion_text!
                          : "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2,),
                    Text(
                      tripDirectionDetailsInfo != null
                          ? tripDirectionDetailsInfo!.distance_text!
                          : "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
