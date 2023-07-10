import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideshare_users/assistants/request_assistant.dart';
import 'package:rideshare_users/global/map_key.dart';
import 'package:rideshare_users/infoHandler/app_info.dart';
import 'package:rideshare_users/models/directions.dart';
import 'package:rideshare_users/models/predicted_places.dart';
import 'package:rideshare_users/widgets/progress_dialog.dart';

class PlacePredictionTileDesign extends StatelessWidget {

  final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({
    this.predictedPlaces
  });

  getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          message: "Setting up, Please Wait...",
        ),
    );

    String placeDirectionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var responseApi = await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

    Navigator.pop(context);
    
    if(responseApi == "Error Occurred, No Response."){
      return;
    }

    if(responseApi["status"] == "OK") {
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude = responseApi["result"]["geometry"]["location"]["lng"];

      Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);

      Navigator.pop(context, "obtainedDropoff");

    }

  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        getPlaceDirectionDetails(predictedPlaces!.place_id, context);
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF2D2727),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            const Icon(
              Icons.add_location,
              color: Color(0xFFff725e),
            ),

            const SizedBox(width: 14.0,),

            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 8.0,),

                    Text(
                      predictedPlaces!.main_text!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17.0,
                        color: Color(0xFFff725e),
                        fontWeight: FontWeight.bold,
                        fontFamily: "PTSerif"
                      ),
                    ),

                    const SizedBox(height: 2.0,),

                    Text(
                      predictedPlaces!.secondary_text!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.white54,
                        fontFamily: "PTSerif",
                      ),
                    ),

                    const SizedBox(height: 8.0,),

                  ],

                ),
            ),
          ],
        ),
      ),
    );
  }
}
