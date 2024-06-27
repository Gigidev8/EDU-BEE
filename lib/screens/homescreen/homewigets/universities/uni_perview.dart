import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_bee/components/textcard.dart';
import 'package:edu_bee/screens/homescreen/results_screen/results.dart';
import 'package:flutter/material.dart';

class UniPreviewResults extends StatelessWidget {
  final String universityName;

  const UniPreviewResults({Key? key, required this.universityName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('courses')
              .where('university', isEqualTo: universityName) // Filter by universityName
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No courses found.'));
            }

            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                final courseData = document.data() as Map<String, dynamic>;
                final courseName = courseData['courseName'];
                final courseType = courseData['courseType'];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomtextCardWidget(
                    belowtext: courseType,
                    text: courseName,
                    icon: Icons.arrow_forward,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Resultsscreen(
                            universityName: universityName,
                            courseName: courseName,
                            courseType: courseType,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
