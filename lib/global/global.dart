import 'package:firebase_auth/firebase_auth.dart';
import 'package:rideshare_users/models/direction_details_info.dart';
import 'package:rideshare_users/models/user_model.dart';


final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; // Online-Active Drivers Information
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId="";
String cloudMessagingServerToken = "key=AAAA9dMOUmk:APA91bHD6WUQJdLkZ-rLfLTcUr3KIqDazjnWWQx9bXS59mnaOma5hzvhZeu-n-babqQmPld-EBCgCGZ3Vd8u56HhFUndWTDuQu_OqzAzGT3HcWYhKGCq4ngOu77kOOxnAx_q8i7cYy18";
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
double countRatingStars = 0.0;
String titleStarsRating = "";