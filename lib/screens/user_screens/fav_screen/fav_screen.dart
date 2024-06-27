import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_bee/components/textcard.dart';
import 'package:edu_bee/screens/homescreen/results_screen/results.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavScreen extends StatelessWidget {
  const FavScreen({Key? key});

 Future<List<Map<String, String>>> fetchUserData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User not logged in");
  }

  // Fetch user data from Firestore
  final docSnapshot = await FirebaseFirestore.instance
      .collection('users_data')
      .doc(user.email)
      .get();

  if (!docSnapshot.exists) {
    throw Exception("User data not found");
  }

  // Extract favorites array from user document
  final favoritesList = docSnapshot.data()?['favorites'] ?? [];

  // Convert favorites array to List<Map<String, String>>
  return List<Map<String, String>>.from(favoritesList.map((item) {
    return {
      'university': item['university']?.toString() ?? '',
      'courseName': item['courseName']?.toString() ?? '',
      'courseType': item['courseType']?.toString() ?? '',
    };
  }));
}

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: FutureBuilder<List<Map<String, String>>>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite courses found.'));
          }

          final favoriteCourses = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Favorites ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.favorite, color: Colors.red),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: favoriteCourses.length,
                    itemBuilder: (context, index) {
                      final course = favoriteCourses[index];
                      return CustomtextCardWidget(
                        text: course['university']!,
                        icon: Icons.navigate_next_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Resultsscreen(
                                universityName: course['university']!,
                                courseName: course['courseName']!,
                                courseType: course['courseType']!,
                              ),
                            ),
                          );
                        },
                        belowtext: course['courseName']!,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
}