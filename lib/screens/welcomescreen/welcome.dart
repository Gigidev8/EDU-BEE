import 'package:edu_bee/components/roundbutton.dart';
import 'package:edu_bee/screens/loginscreen/login_or_signup/lg_entry.dart';
import 'package:flutter/material.dart';

class Welcomescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6e5ce0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4, // Adjust the flex value to control the size of the image
            child: Center(
              child: Image.asset(
                "assets/images/studywlc.png", scale: 8,
                alignment: Alignment.bottomCenter,
                height: 600, // Increased height of the image
              ),
            ),
          ),
          Expanded(
            flex:
                3, // Adjust the flex value to control the size of the white container
            child: Container(
              width: double.infinity,
              // ignore: prefer_const_constructors
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    "EDU BEE",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  const Text(
                    "Fly Your Way to Education",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Roundbutton(
                    size: 100.0,
                    backgroundcolor: const Color(0xFF6e5ce0),
                    color: const Color(0xFF6e5ce0),
                    tap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Loginorsignup()));
                    },
                    icon: Icons.navigate_next_rounded,
                    iconColor: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
