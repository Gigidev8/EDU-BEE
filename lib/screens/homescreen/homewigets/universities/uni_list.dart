import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_bee/components/cardwiget.dart';
import 'package:edu_bee/screens/homescreen/homewigets/universities/uni_perview.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UniListScreen extends StatelessWidget {
  const UniListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('universities').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerList();
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No universities found.'));
            }

            final universities = snapshot.data!.docs;

            return ListView.builder(
              itemCount: universities.length,
              itemBuilder: (context, index) {
                final university = universities[index];
                final universityName = university['name'];
                final imageUrl = university['image_url'];

                return UniversityWidget(
                  universityName: universityName,
                  imageUrl: imageUrl,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5, // Placeholder for shimmer effect
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 60.0,
                  height: 60.0,
                  color: Colors.white,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 16.0,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        width: double.infinity,
                        height: 16.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class UniversityWidget extends StatelessWidget {
  final String universityName;
  final String imageUrl;

  const UniversityWidget({
    Key? key,
    required this.universityName,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: CardWidget(
        imageUrl: imageUrl,
        Name: universityName,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UniPreviewResults(universityName: universityName),
            ),
          );
        },
      ),
    );
  }
}
