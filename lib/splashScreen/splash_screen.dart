import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rideshare_users/authentication/login_screen.dart';
import 'package:rideshare_users/mainScreens/main_screen.dart';
import 'package:rideshare_users/global/global.dart';

import '../assistants/assistant_methods.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  startTimer(){

    fAuth.currentUser != null ? AssistantMethods.readCurrentOnlineUserInfo() : null;

    Timer(const Duration(seconds: 3), () async {

      //check if user already logged in or not
      if(await fAuth.currentUser != null){
        currentFirebaseUser = fAuth.currentUser;
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MainScreen()));
      } else {
        //Send user to Login screen
        Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
      }
    }); //Timer
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/userImage.png"),

              const SizedBox(height: 10,),

              const Text(
                "Ride Share!",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'PTSerif',
                  color: Color(0xFFff725e),
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
