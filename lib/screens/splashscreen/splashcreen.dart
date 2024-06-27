import 'dart:async';

import 'package:edu_bee/screens/homescreen/home_screen.dart';
import 'package:edu_bee/screens/loginscreen/login_or_signup/lg_entry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  late String whatsappLink; // Variable to store WhatsApp link

  @override
  void initState() {
    super.initState();
    // Fetch contact info when splash screen initializes

    // Schedule navigation after 3 seconds
    Timer(Duration(seconds: 3), () {
      _navigateToNextScreen();
    });
  }

 

  Future<void> _navigateToNextScreen() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is signed in, navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homescreen()),
      );
    } else {
      // User is not signed in, navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginorsignup()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6e5ce0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo/download.png"),
            Lottie.asset("assets/lottie/loading.json"),
          ],
        ),
      ),
    );
  }
}
