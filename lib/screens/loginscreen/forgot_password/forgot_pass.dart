import 'package:edu_bee/components/borderbutton.dart';
import 'package:edu_bee/components/textformfeild.dart';
import 'package:edu_bee/screens/loginscreen/forgot_password/sent_confirmation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgotpasswordscreen extends StatefulWidget {
  const Forgotpasswordscreen({Key? key}) : super(key: key);

  @override
  _ForgotpasswordscreenState createState() => _ForgotpasswordscreenState();
}

class _ForgotpasswordscreenState extends State<Forgotpasswordscreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset email sent. Please check your email.'),
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate to the next screen after 3 seconds
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Confrimationscreen(), // Replace NextScreen with your desired screen
            ),
          );
        });
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'No user found with this email.';
        } else {
          message = 'Failed to send reset email. Please try again later.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 3),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6e5ce0),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 200,),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                      child: Text(
                        "Reset",
                        style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                      child: Text(
                        "Password",
                        style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      child: Text(
                        """Please enter your Registered email address
to get password reset link.""",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: CustomTextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Email id",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 15,),
                    Align(
                      alignment: Alignment.center,
                      child: Borderbutton(
                        inputtext: "Continue",
                        bcolor: Colors.white,
                        tcolor: Colors.black,
                        function: () => _resetPassword(), // Call _resetPassword function
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Loading indicator and modal barrier
          if (_isLoading)
            Stack(
              children: [
                ModalBarrier(
                  color: Colors.black.withOpacity(0.5),
                  dismissible: false,
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
