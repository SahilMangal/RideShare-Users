import 'package:flutter/cupertino.dart';
import 'package:rideshare_users/models/directions.dart';

class AppInfo extends ChangeNotifier {

  Directions? userPickupLocation;

  void updatePickupLocationAddress(Directions userPickupAddress) {
    userPickupLocation = userPickupAddress;
    notifyListeners();
  }

}