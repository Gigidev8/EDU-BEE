import 'package:edu_bee/components/borderbutton.dart';
import 'package:edu_bee/screens/loginscreen/login_or_signup/lg_entry.dart';
import 'package:flutter/material.dart';


class Confrimationscreen extends StatelessWidget {
  const Confrimationscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6e5ce0),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
            children: [
              Image.asset(
                "assets/images/email.png",
                scale: 5,
              ),
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    "Reset password mail sent successfully, check your mail and create a new password",
                    textAlign: TextAlign.center, // Align the text in the center
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Borderbutton(
                inputtext: "Continue",
                bcolor: Colors.white,
                tcolor: Colors.black,
                function: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const Loginorsignup(), // Replace LoginScreen with your actual login screen widget
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
