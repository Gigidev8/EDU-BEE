import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_bee/auth_user/user_model.dart';
import 'package:edu_bee/screens/homescreen/profilescreen/profilescxreen.dart';
import 'package:edu_bee/screens/loginscreen/login_or_signup/lg_entry.dart';
import 'package:edu_bee/screens/user_screens/applied_courses/applaid_course.dart';
import 'package:edu_bee/screens/user_screens/fav_screen/fav_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CustomDrawer extends StatefulWidget {
  final UserModel userModel;

  CustomDrawer({Key? key, required this.userModel}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? whatsappLink;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    _fetchContactInfo();
  }

  Future<void> _fetchContactInfo() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('contact_info')
          .doc('contact_info')
          .get();
      if (snapshot.exists) {
        setState(() {
          whatsappLink = snapshot['Whatsapplink'];
          phoneNumber = snapshot['phonecallnumber'];
        });
      }
    } catch (e) {
      print("Error fetching contact info: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String _capitalizedUserName = widget.userModel.userName != null
        ? _capitalizeFirstLetter(widget.userModel.userName!)
        : "User";

    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(_capitalizedUserName),
            accountEmail: null,
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 50.0,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: const Icon(
                    Icons.person_3_rounded,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.favorite_border_outlined,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Favorite Courses',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.done_all_rounded,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Applied Courses',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppliedcourseScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _logout(context);
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: const Divider(
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Contact Us',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _launchInBrowser(whatsappLink);
                  },
                  child: Image.asset(
                    "assets/logo/whatsapp.png",
                    height: 45,
                  ),
                ),
                const SizedBox(width: 50),
                GestureDetector(
                  onTap: () {
                    _makePhoneCall();
                  },
                  child: Image.asset(
                    "assets/logo/telephone-call.png",
                    height: 45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _capitalizeFirstLetter(String text) {
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();
      // Navigate to login screen after successful logout
      Navigator.pop(context); // Close the drawer
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Loginorsignup(),
        ),
      ); // Replace current screen with login screen
    } catch (e) {
      print("Error logging out: $e");
      // Handle logout error
    }
  }

  Future<void> _launchInBrowser(String? whatsappLink) async {
    print('Trying to launch $whatsappLink'); // Debugging print
    if (whatsappLink != null && whatsappLink.isNotEmpty) {
      final completeUrl = 'https://wa.me/$whatsappLink'; // Add this line
      try {
        bool canLaunch = await canLaunchUrlString(completeUrl); // Update this line
        if (canLaunch) {
          bool launched = await launchUrlString(completeUrl, mode: LaunchMode.externalApplication); // Update this line
          if (!launched) {
            print('Could not launch $completeUrl');
          }
        } else {
          print('No application can handle the URL: $completeUrl');
        }
      } catch (e) {
        print('Error launching $completeUrl: $e');
      }
    } else {
      print('Invalid URL');
    }
  }

  void _makePhoneCall() async {
    if (phoneNumber != null) {
      final phoneCallUrl = "tel:$phoneNumber";
      print("Trying to launch $phoneCallUrl"); // Print for debugging
      if (await launchUrlString(phoneCallUrl)) {
        await launchUrlString(phoneCallUrl);
      } else {
        print('Could not launch $phoneCallUrl');
      }
    } else {
      print('No phone number available');
    }
  }
}
