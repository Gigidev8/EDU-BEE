import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_bee/auth_user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppliedcourseScreen extends StatelessWidget {
  const AppliedcourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserModel>(context);
    final String? email = userModel.userEmail;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Applied Courses",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('applied_courses')
                        .doc(email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('Error fetching data'));
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Center(
                            child: Text('No applied courses found'));
                      }

                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      List<dynamic> applications = data['applications'] ?? [];

                      return ListView.builder(
                        itemCount: applications.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> application =
                              applications[index];
                          String universityName =
                              application['university_name'] ?? 'N/A';
                          String courseName =
                              application['course_name'] ?? 'N/A';
                          String courseType =
                              application['course_type'] ?? 'N/A';
                          Timestamp timestamp = application['timestamp'];
                          DateTime appliedDate = timestamp.toDate();
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(appliedDate);

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              border: Border.fromBorderSide(BorderSide(color: Colors.white)),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black,
                            ),
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    universityName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    courseName,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    courseType,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
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
