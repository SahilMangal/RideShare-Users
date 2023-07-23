import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rideshare_users/global/global.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class RateDriverScreen extends StatefulWidget {

  String? assignedDriverId;

  RateDriverScreen({this.assignedDriverId});

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFF2D2727),
            border: Border.all(color: Color(0xFFff725e), width: 3),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFff725e),
                blurRadius: 4,
                offset: Offset(2, 2), // Shadow position
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const SizedBox(height: 20,),

              const Text(
                "Rate Trip Experience",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 2,
                    color: Color(0xFFff725e),
                    fontFamily: "PTSerif"
                ),
              ),

              const SizedBox(height: 20,),

              const Divider(
                height: 3,
                thickness: 3,
                color: Color(0xFFff725e),
              ),

              const SizedBox(height: 20,),

              SmoothStarRating(
                rating: countRatingStars,
                allowHalfRating: false,
                starCount: 5,
                size: 46,
                color: const Color(0xFFff725e),
                borderColor: Colors.white30,
                onRatingChanged: (valueOfStarsChoosed){
                  countRatingStars = valueOfStarsChoosed;

                  if(countRatingStars == 1){
                    setState(() {
                      titleStarsRating = "Very Bad";
                    });
                  }

                  if(countRatingStars == 2){
                    setState(() {
                      titleStarsRating = "Bad";
                    });
                  }

                  if(countRatingStars == 3){
                    setState(() {
                      titleStarsRating = "Good";
                    });
                  }

                  if(countRatingStars == 4){
                    setState(() {
                      titleStarsRating = "Very Good";
                    });
                  }

                  if(countRatingStars == 5){
                    setState(() {
                      titleStarsRating = "Excellent";
                    });
                  }

                },
              ),

              const SizedBox(height: 15,),

              Text(
                titleStarsRating,
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontFamily: "PTSerif"
                ),
              ),

              const SizedBox(height: 18,),

              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFff725e),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 90,
                      vertical: 8,
                    ),
                  ),
                  onPressed: (){
                    DatabaseReference rateDriverRef = FirebaseDatabase.instance.ref()
                        .child("drivers")
                        .child(widget.assignedDriverId!)
                        .child("ratings");

                    rateDriverRef.once().then((snap) {
                      //for New Driver // First Trip
                      if(snap.snapshot.value == null) {
                        rateDriverRef.set(countRatingStars.toString());
                        SystemNavigator.pop();
                      } else {
                        double pastRatings = double.parse(snap.snapshot.value.toString());
                        double newAverageRating =  (pastRatings + countRatingStars) / 2;
                        rateDriverRef.set(newAverageRating.toString());
                        SystemNavigator.pop();
                      }
                      Fluttertoast.showToast(msg: "Please restart the app now");
                    });


                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "PTSerif"
                    ),
                  ),
              ),

              const SizedBox(height: 15,),

            ],
          ),
        ),
      ),
    );
  }
}
