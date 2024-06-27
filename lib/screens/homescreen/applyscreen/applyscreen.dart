import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_bee/auth_user/user_model.dart';
import 'package:edu_bee/components/borderbutton.dart';
import 'package:edu_bee/screens/homescreen/home_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Applyscreen extends StatefulWidget {
  final String universityName;
  final String courseName;
  final String courseType;
  final String detailsText;

  const Applyscreen({
    Key? key,
    required this.universityName,
    required this.courseName,
    required this.courseType,
    required this.detailsText,
  }) : super(key: key);

  @override
  _ApplyscreenState createState() => _ApplyscreenState();
}

class _ApplyscreenState extends State<Applyscreen> {
  File? _selectedFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        // Handle denied permission
      }
      setState(() {}); // Trigger a rebuild after permission is granted
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        // Add allowed file extensions
        );

    if (result != null) {
      File file = File(result.files.single.path!);
      if (file.lengthSync() > 5 * 1024 * 1024) {
        // File size exceeds 5 MB
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('File Size Exceeded'),
            content: Text('Please select a file under 5 MB.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
        return;
      }
      setState(() {
        _selectedFile = file;
      });
    } else {
      // User canceled the picker
    }
  }

Future<void> _submitApplication() async {
  final UserModel userModel = Provider.of<UserModel>(context, listen: false);

  // Get current user's data from UserModel
  final String? email = userModel.userEmail;
  final String? phoneNumber = userModel.phoneNumber;
  final String? fullName = userModel.userName;

  if (_selectedFile != null && email != null && phoneNumber != null && fullName != null) {
    setState(() {
      _isUploading = true;
    });

    // Upload file to Firebase Storage
    String fileName = _selectedFile!.path.split('/').last;
    try {
      await FirebaseStorage.instance
          .ref('applied_courses/$fileName')
          .putFile(_selectedFile!);
      String downloadURL = await FirebaseStorage.instance
          .ref('applied_courses/$fileName')
          .getDownloadURL();

      // Get the current server timestamp
      Timestamp serverTimestamp = Timestamp.now();

      // New application data
      Map<String, dynamic> newApplication = {
        'university_name': widget.universityName,
        'course_name': widget.courseName,
        'course_type': widget.courseType,
        'details_text': widget.detailsText,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'file_url': downloadURL,
        'timestamp': serverTimestamp,
      };

      // Add application data to Firestore
      DocumentReference docRef = _firestore.collection('applied_courses').doc(email);
      await docRef.set({
        'applications': FieldValue.arrayUnion([newApplication])
      }, SetOptions(merge: true));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Application submitted successfully!')),
      );
    } catch (e) {
      print('Error uploading file: $e');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting application. Please try again later.')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Homescreen()),
      );
    });
  } else {
    // Show error message if any field is missing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please complete all fields and upload your CV.')),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF6e5ce0),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Card(
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.universityName,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.courseName,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  widget.courseType,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(height: 5),
                                Text(
                                  widget.detailsText,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(
                                    height:
                                        100), // Add more space to avoid overlap with the button
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Upload Your CV",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: IconButton(
                                    onPressed: _pickFile,
                                    icon: Icon(
                                      Icons.upload_file_rounded,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: _selectedFile != null
                                  ? Image.file(
                                      _selectedFile!,
                                      height: 100,
                                      width: 100,
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      height: 100,
                                      width: 100,
                                      child: const Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 80,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Card(
                      child: Borderbutton(
                        inputtext: "Submit",
                        bcolor: Colors.white,
                        tcolor: Colors.blue,
                        function: _submitApplication,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isUploading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
