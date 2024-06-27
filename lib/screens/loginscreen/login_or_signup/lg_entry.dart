import 'package:edu_bee/components/borderbutton.dart';
import 'package:edu_bee/components/textformfeild.dart';
import 'package:edu_bee/screens/Homescreen/home_screen.dart';
import 'package:edu_bee/screens/loginscreen/create_account/create_account.dart';
import 'package:edu_bee/screens/loginscreen/forgot_password/forgot_pass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loginorsignup extends StatelessWidget {
  const Loginorsignup({Key? key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    Future<void> signInWithEmailAndPassword(BuildContext context) async {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homescreen()),
        );
      } catch (e) {
        print("Error signing in: $e");
        // Display error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing in. Please check your credentials.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }

    return WillPopScope(
      onWillPop: () async =>
          false, // Prevent back button from popping the route
      child: Scaffold(
        backgroundColor: const Color(0xFF6e5ce0),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/logo/download.png"),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    children: const [
                      Text(
                        "Sign in",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: CustomTextFormField(
                    controller: emailController,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: CustomPasswordFormField(
                    controller: passwordController,
                    hintText: "Password",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const Forgotpasswordscreen()));
                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 30),
                Borderbutton(
                  function: () => signInWithEmailAndPassword(context),
                  inputtext: 'Sign in',
                  bcolor: Colors.white,
                  tcolor: Colors.black,
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateAccount()),
                    );
                  },
                  child: const Text(
                    "Create New Account ?",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
