import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rideshare_users/global/global.dart';
import 'package:rideshare_users/widgets/info_design_ui.dart';

class ProfileScreen extends StatefulWidget {

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2727),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //Name
            Text(
              userModelCurrentInfo!.name!,
              style: const TextStyle(
                fontSize: 50,
                fontFamily: "Ubuntu",
                fontWeight: FontWeight.bold,
                  color: Color(0xFFff725e),
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

            const SizedBox(height: 38,),

            //Phone
            InfoDesignUIWidget(
              textInfo: userModelCurrentInfo!.phone!,
              iconData: Icons.phone_iphone,
            ),

            //Email
            InfoDesignUIWidget(
              textInfo: userModelCurrentInfo!.email!,
              iconData: Icons.email,
            ),

            const SizedBox(height: 50,),

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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Ubuntu"
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
