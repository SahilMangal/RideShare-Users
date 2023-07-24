import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/info_design_ui.dart';


class AboutScreen extends StatefulWidget {

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2727),
      body: ListView(
        children: [
          //Image
          Container(
            height: 230,
            child: Center(
              child: Image.asset(
                "images/userImage1.png",
                width: 320,
              ),
            ),
          ),
          Column(
            children: [
              //Name
              const Text(
                "Team Members",
                style: TextStyle(
                  color: Color(0xFFff725e),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: "PTSerif",
                  letterSpacing: 6,
                ),
              ),

              const SizedBox(
                height: 20,
                width: 250,
                child: Divider(
                  color: Color(0xFFff725e),
                  height: 3,
                  thickness: 3,
                ),
              ),

              const SizedBox(height: 10,),

              InfoDesignUIWidget(
                textInfo: "Sahil Mangal (C0854050)",
                iconData: Icons.person,
              ),

              InfoDesignUIWidget(
                textInfo: "Alen Dominic (C0854227)",
                iconData: Icons.person,
              ),

              InfoDesignUIWidget(
                textInfo: "Rahul Yadav (C0854005)",
                iconData: Icons.person,
              ),

              const SizedBox(height: 30,),

              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFff725e),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 8,
                    ),
                  ),
                  onPressed: (){
                    SystemNavigator.pop();
                  },
                  child: const Text(
                    "Close",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: "PTSerif"
                    ),
                  ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
