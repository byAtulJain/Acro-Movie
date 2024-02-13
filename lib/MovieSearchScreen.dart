import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'MovieDetailScreen.dart';

class MovieSearchScreen extends StatefulWidget {
  @override
  _MovieSearchScreenState createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Stream<QuerySnapshot> _searchStream;

  @override
  void initState() {
    super.initState();
    _searchStream = FirebaseFirestore.instance
        .collection('MovieDetails')
        .orderBy('TodayDate', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        automaticallyImplyLeading: false,
        title: Container(
          // padding: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search..',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _searchStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final querySnapshot = snapshot.data;

          final List<Map<String, dynamic>> searchResults =
              querySnapshot!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'docId': doc.id,
              'moviePoster': data['moviePoster'],
              'movieName': data['movieName'],
            };
          }).toList();

          final filteredResults = searchResults.where((result) {
            final query = _searchController.text.toLowerCase();
            final movieName = result['movieName'].toLowerCase();
            return movieName.contains(query);
          }).toList();

          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.6,
            ),
            itemCount: filteredResults.length,
            itemBuilder: (context, index) {
              final result = filteredResults[index];
              return buildImage(
                context,
                result['docId'],
                result['moviePoster'],
                result['movieName'],
              );
            },
          );
        },
      ),
    );
  }

  Widget buildImage(
    BuildContext context,
    String docId,
    String imageURL,
    String movieName,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                MovieDetailScreen(docId: docId, imageUrl: imageURL),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: CachedNetworkImage(
          imageUrl: imageURL,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.yellow.shade200,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Center(
            child: Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
