import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_bee/components/cardwiget.dart';
import 'package:edu_bee/screens/homescreen/homewigets/countries/preview_results/preview_results.dart';
import 'package:flutter/material.dart';

class CountryDetails extends StatelessWidget {
  final String country;

  const CountryDetails({
    Key? key,
    required this.country,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('universities')
            .where('country', isEqualTo: country)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No university found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final universityData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final universityName = universityData['name'];
              final universityImageUrl = universityData['image_url'];

              return CardWidget(
                imageUrl: universityImageUrl,
                Name: universityName,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreviewResults(universityName: universityName),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
