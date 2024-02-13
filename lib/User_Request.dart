import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_movie_app/series_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'ToastHelper.dart';
import 'home_screen.dart';
import 'movie_screen.dart';

class UserRequest extends StatefulWidget {
  const UserRequest({super.key});

  @override
  State<UserRequest> createState() => _UserRequestState();
}

class _UserRequestState extends State<UserRequest> {
  TextEditingController RequestMovieNameController = TextEditingController();
  TextEditingController YearOrSeasonController = TextEditingController();

  void uploadRequest() async {
    final systemDate = DateTime.now();
    String RequestMovieName = RequestMovieNameController.text.trim();
    String YearOrSeason = YearOrSeasonController.text.trim();

    if (RequestMovieName.isNotEmpty && YearOrSeason.isNotEmpty) {
      RequestMovieNameController.clear();
      YearOrSeasonController.clear();

      Map<String, dynamic> RequestData = {
        "RequestMovieName": RequestMovieName,
        "YearOrSeason": YearOrSeason,
        'TodayDate': systemDate,
      };
      FirebaseFirestore.instance
          .collection("UserRequest")
          .doc(RequestMovieName)
          .set(RequestData);
      print("Movie Uploaded");
      ToastHelper.showToast('Request Submitted');
    } else {
      ToastHelper.showToast('Fill all details!');
      print("Fill all details!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black38,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black38,
          title: Image.asset(
            'images/app_logo.png',
            width: 150.0,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 16.0),
                Text(
                  'Movie/TV Show Name:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: RequestMovieNameController,
                  decoration: InputDecoration(
                    hintText: 'Movie/TV Show Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Year/Season',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: YearOrSeasonController,
                  decoration: InputDecoration(
                    hintText: 'Year for Movie or Season for TV Show',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        uploadRequest();
                      },
                      child: Text('Send Request'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.black38,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: GNav(
              backgroundColor: Colors.black38,
              gap: 4,
              color: Colors.yellow.shade200,
              activeColor: Colors.yellow.shade200,
              selectedIndex: 3,
              tabBackgroundColor: Colors.grey.shade800,
              padding: EdgeInsets.all(16.0),
              haptic: true,
              tabs: [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                  onPressed: () {
                    Navigator.push(
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
                    Navigator.push(
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
                  icon: Icons.tv,
                  text: 'TV Show',
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            SeriesScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Setting',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
