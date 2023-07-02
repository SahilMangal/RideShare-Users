import 'package:rideshare_users/models/active_nearby_available_drivers.dart';

class GeofireAssistant {

  static List<ActiveNearbyAvailableDrivers> activeNearbyAvailableDriversList = [];

  static void deleteOfflineDriverFromList(String driverId) {
    int indexNumber = activeNearbyAvailableDriversList.indexWhere((element) => element.driverId == driverId);
    activeNearbyAvailableDriversList.removeAt(indexNumber);
  }

  static void updateActiveNearbyAvailableDriverLocation (ActiveNearbyAvailableDrivers driverWhoMoves) {
    int indexNumber = activeNearbyAvailableDriversList.indexWhere((element) => element.driverId == driverWhoMoves.driverId);
    activeNearbyAvailableDriversList[indexNumber].locationLatitude = driverWhoMoves.locationLatitude;
    activeNearbyAvailableDriversList[indexNumber].locationLongitude = driverWhoMoves.locationLongitude;
  }

}