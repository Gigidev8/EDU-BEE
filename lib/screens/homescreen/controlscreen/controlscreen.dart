
import 'package:edu_bee/screens/loginscreen/login_or_signup/lg_entry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child:  SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: IconButton(
                onPressed: () {
                  _signOut(context); // Call sign-out function
                },
                icon: Icon(Icons.logout_rounded),
              ),
            )
          ],
        ),
      ),
      
    );
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out the current user
      // Navigate to the login or welcome screen after sign-out
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginorsignup()));
    } catch (e) {
      // Show error dialog if sign-out fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to sign out. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
