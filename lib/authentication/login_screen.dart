import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rideshare_users/authentication/signup_screen.dart';
import 'package:rideshare_users/splashScreen/splash_screen.dart';
import 'package:rideshare_users/global/global.dart';
import 'package:rideshare_users/widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if(!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email is not valid");
    } else if(passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is required");
    } else {
      loginUserNow();
    }
  }

  loginUserNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(message: "Please wait...",);
        }
    );

    final User? firebaseUser = (
        await fAuth.signInWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim()
        ).catchError((err){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: " + err.toString());
        })
    ).user;

    if(firebaseUser != null) {
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("users");
      driversRef.child(firebaseUser.uid).once().then((driverKey){
        final snap = driverKey.snapshot;
        if(snap.value != null){
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successful.");
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
        } else {
          Fluttertoast.showToast(msg: "No Record is present with this email.");
          fAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
        }
      });
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error occurred during sign in.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2727),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [

              const SizedBox(height: 40,),

              // Image
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset("images/userImage.png"),
              ),

              const SizedBox(height: 10,),

              //Login as a Driver Name
              const Text(
                "Login as a Customer",
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  fontFamily: "Ubuntu"
                ),
              ),

              //Email Field
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: Color(0xFFB0BEC5),
                  fontFamily: "Ubuntu"
                ),
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFff725e))
                  ),

                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: "Ubuntu"
                  ),
                  labelStyle: TextStyle(
                    color: Color(0xFFff725e),
                    fontSize: 15,
                    fontFamily: "Ubuntu"
                  ),


                ),
              ),

              //Password Field
              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(
                  color: Color(0xFFB0BEC5),
                  fontFamily: "Ubuntu"
                ),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFff725e))
                  ),

                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                  ),
                  hintStyle: TextStyle(
                    color: Color(0xFFB0BEC5),
                    fontSize: 10,
                    fontFamily: "Ubuntu"
                  ),
                  labelStyle: TextStyle(
                    color: Color(0xFFff725e),
                    fontSize: 15,
                    fontFamily: "Ubuntu"
                  ),


                ),
              ),

              const SizedBox(height: 40,),

              // Login Button
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    validateForm();
                    //Navigator.push(context, MaterialPageRoute(builder: (c)=> CarInfoScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFff725e),
                  ),
                  child: const Text(
                    "Login Now",
                    style: TextStyle(
                      color: Color(0xFF1a2e35),
                      fontSize: 18,
                      fontFamily: "Ubuntu",
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              //Already have an account? Login here
              TextButton(
                child: const Text(
                  "Don't have an account? Register Now!",
                  style: TextStyle(
                    color: Colors.white38,
                    fontStyle: FontStyle.italic,
                    fontFamily: "Ubuntu"
                  ),
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> SignUpScreen()));
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
