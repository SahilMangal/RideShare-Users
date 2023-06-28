import 'package:flutter/material.dart';
import 'package:rideshare_users/assistants/request_assistant.dart';
import 'package:rideshare_users/global/map_key.dart';
import 'package:rideshare_users/mainScreens/main_screen.dart';
import 'package:rideshare_users/models/predicted_places.dart';
import 'package:rideshare_users/widgets/place_prediction_tile.dart';

class SearchPlacesScreen extends StatefulWidget {

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {

  List<PredictedPlaces> placesPredictedList = [];

  Future<void> findPlaceAutoCompleteSearch(String inputText) async {

    if(inputText.length > 1){
      String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:CA";
      var responseAutoCompleteSearch = await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      if(responseAutoCompleteSearch == "Error Occurred, No Response."){
        return;
      }
      
      if(responseAutoCompleteSearch["status"] == "OK"){
        var placesPredictions = responseAutoCompleteSearch["predictions"];

        var placesPredictionsList = (placesPredictions as List).map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();

        setState(() {
          placesPredictedList = placesPredictionsList;
        });
      }

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D2727),
      body: Column(
        children: [
          //search place UI
          Container(
            height: 160,
            decoration: const BoxDecoration(
              color: Colors.black54,
              boxShadow: [
                BoxShadow(
                  color: Colors.white38,
                  blurRadius: 8,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [

                  const SizedBox(height: 25.0,),

                  Stack(
                    children: [

                      GestureDetector(
                        onTap:(){
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                      ),

                      const Center(
                        child: Text(
                          "Search & Set DropOff Location",
                          style: TextStyle(
                            color: Color(0xFFff725e),
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 20.0,),

                  Row(
                    children: [

                      const Icon(
                        Icons.adjust_sharp,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 20.0,),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (valueTyped){
                              findPlaceAutoCompleteSearch(valueTyped);
                            },
                            decoration: const InputDecoration(
                              hintText: "Search here...",
                              fillColor: Colors.white24,
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                left: 11.0,
                                top: 8.0,
                                bottom: 8.0,
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ),

          //display placeAPI predictions results
          (placesPredictedList.length > 0)
              ? Expanded(
                  child: ListView.separated(
                    itemCount: placesPredictedList.length,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PlacePredictionTileDesign(
                        predictedPlaces: placesPredictedList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 1,
                        color: Color(0xFFff725e),
                        thickness: 2,
                      );
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
