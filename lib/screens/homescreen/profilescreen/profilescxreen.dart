import 'package:edu_bee/auth_user/user_model.dart';
import 'package:edu_bee/components/borderbutton.dart';
import 'package:edu_bee/screens/homescreen/profilescreen/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context); // Access the UserModel

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 50.0,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),

            SizedBox(height: 10),
            Center(
              child: Text(
                userModel.userEmail ?? '', // Display the user's email
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            _buildProfileItem('Name',
                userModel.userName ?? ''), // Update with user's username
            _buildProfileItem(
                'Email', userModel.userEmail ?? ''), // Update with user's email
            _buildProfileItem('Phone',
                userModel.phoneNumber ?? ""), // Placeholder for phone number
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Borderbutton(
                  inputtext: "EDIT PROFILE",
                  bcolor: Colors.white,
                  tcolor: Colors.black,
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfileScreen()));
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Divider(color: Colors.grey),
      ],
    );
  }
}

