import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rideshare_users/global/global.dart';
import 'package:rideshare_users/mainScreens/about_screen.dart';
import 'package:rideshare_users/mainScreens/profile_screen.dart';
import 'package:rideshare_users/mainScreens/trips_history_screen.dart';
import 'package:rideshare_users/splashScreen/splash_screen.dart';

class MyDrawer extends StatefulWidget {

  String? name;
  String? email;

  MyDrawer({this.email, this.name});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [

          // Drawer Header
          Container(
            height: 165,
            color: Color(0xFF263238),//0xFF263238
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF2D2727)),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_pin_sharp,
                    size: 80,
                    color: Colors.white38, //0xFFff725e
                  ),

                  const SizedBox(width: 16,),
                  
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Name
                      Text(
                        widget.name.toString(),
                        style: const TextStyle(
                          fontSize: 19,
                          fontFamily: 'PTSerif',
                          color: Color(0xFFECEFF1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10,),

                      //Email
                      Text(
                        widget.email.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'PTSerif',
                          color: Color(0xFFECEFF1),
                        ),
                      ),

                    ],
                  ),
                ],
              )
            ),
          ),

          const SizedBox(height: 12,),

          //Drawer Body
          //History Button
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (c)=> TripsHistoryScreen())
              );
            },
            child: const ListTile(
              leading: Icon(Icons.history, color: Colors.white38,size: 30,), //0xFFff725e
              title: Text(
                "History",
                style: TextStyle(
                  color: Color(0xFFff725e),
                  fontSize: 20,
                  fontFamily: 'PTSerif',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          //Profile Button
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (c)=> ProfileScreen())
              );
            },
            child: const ListTile(
              leading: Icon(Icons.person_2_rounded, color: Colors.white38,size: 30,), //0xFFff725e
              title: Text(
                "Visit Profile",
                style: TextStyle(
                  color: Color(0xFFff725e),
                  fontSize: 20,
                  fontFamily: 'PTSerif',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // About Page
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (c)=> AboutScreen())
              );
            },
            child: const ListTile(
              leading: Icon(Icons.info, color: Colors.white38,size: 30,), //0xFFff725e
              title: Text(
                "About me",
                style: TextStyle(
                  color: Color(0xFFff725e),
                  fontSize: 20,
                  fontFamily: 'PTSerif',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Logout Button
          GestureDetector(
            onTap: (){
              Fluttertoast.showToast(msg: "Logout Successful");
              fAuth.signOut();
              Navigator.push(
                  context, MaterialPageRoute(builder: (c)=> const MySplashScreen())
              );
            },
            child: const ListTile(
              leading: Icon(Icons.logout, color: Colors.white38,size: 30,), //0xFFff725e
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Color(0xFFff725e),
                  fontSize: 20,
                  fontFamily: 'PTSerif',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20,),

          //Share Button
          GestureDetector(
            onTap: (){
            },
            child: const ListTile(
              leading: Icon(Icons.share, color: Colors.white38,size: 30,), //0xFFff725e
              title: Text(
                "Share",
                style: TextStyle(
                  color: Color(0xFFff725e),
                  fontSize: 20,
                  fontFamily: 'PTSerif',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
