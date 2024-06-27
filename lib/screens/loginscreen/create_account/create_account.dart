import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_bee/components/borderbutton.dart';
import 'package:edu_bee/components/textformfeild.dart';
import 'package:edu_bee/screens/homescreen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  late String email;
  late String password;
  late String fullName;
  late String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6e5ce0),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset("assets/logo/download.png"),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Create New Account",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: CustomTextFormField(
                  onChanged: (value) {
                    setState(() {
                      fullName = value;
                    });
                  },
                  keyboardType: TextInputType.name,
                  hintTextColor: Colors.white,
                  hintText: "Full Name",
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: CustomTextFormField(
                  keyboardType: TextInputType.emailAddress,
                  hintText: "Email",
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: CustomTextFormField(
                  keyboardType: TextInputType.phone,
                  hintText: "Phone number",
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    if (value.length < 7) {
                      return 'Please check your phone number';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Phone number must contain only numbers';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: CustomPasswordFormField(
                  hintText: "Password",
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  validator: (value) {
                    return _defaultPasswordValidator(value);
                  },
                ),
              ),
              const SizedBox(height: 30),
              Borderbutton(
                function: () async {
                  if (_formKey.currentState!.validate()) {
                    await _createUserWithEmailAndPassword(context);
                  }
                },
                inputtext: "Create Account",
                bcolor: Colors.white,
                tcolor: const Color(0xFF6e5ce0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createUserWithEmailAndPassword(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Create a new user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Dismiss the loading indicator
      Navigator.pop(context);

      // Store additional user info in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
      });

      // Navigate to home screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homescreen()));
    } catch (e) {
      // Dismiss the loading indicator
      Navigator.pop(context);

      // Show error message using ScaffoldMessenger Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating account: ${e.toString()}'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  String? _defaultPasswordValidator(String? value) {
    // Ensure password is at least 6 characters long
    if (value == null || value.isEmpty || value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    // Ensure password contains at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Ensure password contains at least one symbol
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one symbol';
    }

    return null;
  }
}
