import 'package:flutter/cupertino.dart';
import 'package:rideshare_users/models/directions.dart';
import 'package:rideshare_users/models/trips_history_model.dart';

class AppInfo extends ChangeNotifier {

  Directions? userPickupLocation, userDropOffLocation;
  int countTotalTrips = 0;
  List<String> historyTripsKeysList = [];
  List<TripsHistoryModel> allTripsHistoryInformationList = [];

  void updatePickupLocationAddress(Directions userPickupAddress) {
    userPickupLocation = userPickupAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress) {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  updateOverAllTripsCounter(int overAllTripsCounter){
    countTotalTrips = overAllTripsCounter;
    notifyListeners();
  }

  updateOverAllTripsKeys(List<String> tripsKeysList){
    historyTripsKeysList = tripsKeysList;
    notifyListeners();
  }

  updateOverAllTripHistoryInformation(TripsHistoryModel eachTripHistory){
    allTripsHistoryInformationList.add(eachTripHistory);
    notifyListeners();
  }

}