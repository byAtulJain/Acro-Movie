import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_movie_app/app_setting.dart';
import 'package:final_movie_app/movie_screen.dart';
import 'package:final_movie_app/notification_sevices.dart';
import 'package:final_movie_app/series_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'MovieDetailScreen.dart';
import 'MovieSearchScreen.dart';
import 'alreadyLogin.dart';
import 'home_screen.dart';

class SeriesScreen extends StatefulWidget {
  @override
  _SeriesScreenState createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _imageStream; // Declare a stream variable
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    _imageStream = _firestore
        .collection('MovieDetails')
        .where("Type", isEqualTo: "Series")
        // .orderBy('TodayDate', descending: true)
        .snapshots(); // Create a stream of snapshots
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black38,
        title: Image.asset(
          'images/app_logo.png',
          width: 150.0,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 11.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        MovieSearchScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              child: Icon(
                Icons.search,
                size: 30,
                // color: Colors.orange.shade300,
                color: Colors.yellow.shade200,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _imageStream, // Pass the stream to the StreamBuilder
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            ); // Show a loading indicator while data is loading
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
              'quality': data['quality'] ?? 'HD', // Add null check for quality
            };
          }).toList();

          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.6,
            ),
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final result = searchResults[index];
              return buildImage(
                context,
                result['docId'],
                result['moviePoster'],
                result['movieName'],
                result['quality'],
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.black38,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: GNav(
            backgroundColor: Colors.black38,
            gap: 4,
            color: Colors.yellow.shade200,
            activeColor: Colors.yellow.shade200,
            selectedIndex: 2,
            tabBackgroundColor: Colors.grey.shade800,
            padding: EdgeInsets.all(16.0),
            haptic: true,
            tabs: [
              GButton(
                icon: Icons.home_outlined,
                text: 'Home',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          HomeScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              GButton(
                icon: Icons.movie_creation_outlined,
                text: 'Movies',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          MovieScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              GButton(
                icon: Icons.tv_off_outlined,
                text: 'TV Show',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Setting',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          AppSetting(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage(
    BuildContext context,
    String docId,
    String imageURL,
    String movieName,
    String movieQuality,
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
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imageURL,
              height: 200.0,
              width: 150.0,
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
            Positioned(
              top: 5.0,
              right: 5.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  movieQuality,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
