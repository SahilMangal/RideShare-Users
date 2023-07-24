import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rideshare_users/models/trips_history_model.dart';

class HistoryDesignUIWidget extends StatefulWidget {

  TripsHistoryModel? tripsHistoryModel;

  HistoryDesignUIWidget({this.tripsHistoryModel});

  @override
  State<HistoryDesignUIWidget> createState() => _HistoryDesignUIWidgetState();
}



class _HistoryDesignUIWidgetState extends State<HistoryDesignUIWidget> {

  String formatDateAndTime(String dateTimeFromDB){
    DateTime dateTime = DateTime.parse(dateTimeFromDB);
    return "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2D2727),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Driver Name + Fare amont
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 6.0),
                  child: Text(
                    "Driver: " + widget.tripsHistoryModel!.driverName!,
                    style: const TextStyle(
                      fontSize: 17,
                      fontFamily: "Ubuntu",
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ),

                const SizedBox(width: 12,),

                Text(
                  "\$ " + widget.tripsHistoryModel!.fareAmount!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "Ubuntu",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 2,),

            // Driver Car Details
            Row(
              children: [
                const Icon(
                  Icons.emoji_transportation,
                  color: Color(0xFFff725e),
                  size: 30,
                ),

                const SizedBox(width: 12,),

                Text(
                  widget.tripsHistoryModel!.car_details!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: "Ubuntu",
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFff725e),
                  ),
                ),
              ],
            ),

            const Center(
              child: SizedBox(
                height: 20,
                width: 150,
                child: Divider(
                  color: Color(0xFFff725e),
                  height: 3,
                  thickness: 3,
                ),
              ),
            ),

            // Icon and Pickup address
            Row(
              children: [

                Image.asset(
                  "images/origin.png",
                  height: 30,
                  width: 30,
                ),

                const SizedBox(width: 12,),

                Expanded(
                  child: Container(
                    child: Text(
                      widget.tripsHistoryModel!.originAddress!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFff725e),
                      ),
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 5,),

            // Icon and DropOff address
            Row(
              children: [

                Image.asset(
                  "images/destination.png",
                  height: 30,
                  width: 30,
                ),

                const SizedBox(width: 12,),

                Expanded(
                  child: Container(
                    child: Text(
                      widget.tripsHistoryModel!.destinationAddress!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFff725e),
                      ),
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(""),
                Text(
                  formatDateAndTime(widget.tripsHistoryModel!.time!),
                  style: const TextStyle(
                    fontSize: 17,
                    fontFamily: "Ubuntu",
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 2,),

          ],
        ),
      ),
    );
  }
}
