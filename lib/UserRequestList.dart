import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_movie_app/add_series.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'add_movies.dart';
import 'home_screen.dart';

class UserRequestList extends StatefulWidget {
  const UserRequestList({super.key});

  @override
  State<UserRequestList> createState() => _UserRequestListState();
}

class _UserRequestListState extends State<UserRequestList> {
  void logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black38,
        appBar: AppBar(
          backgroundColor: Colors.black38,
          automaticallyImplyLeading: false,
          title: Image.asset(
            'images/app_logo.png',
            width: 150.0,
          ),
          actions: [
            IconButton(
              onPressed: () {
                logOut(context);
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.yellow.shade200,
              ),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('UserRequest')
              .orderBy('TodayDate', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final requests = snapshot.data!.docs;
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index].data() as Map<String, dynamic>;
                return Dismissible(
                  background: Padding(
                    padding: const EdgeInsets.only(right: 300),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  secondaryBackground: Padding(
                    padding: const EdgeInsets.only(left: 300),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  key: Key(request['RequestMovieName']),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Delete'),
                          content: Text(
                              'Are you sure you want to delete this request?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('DELETE'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    FirebaseFirestore.instance
                        .collection('UserRequest')
                        .doc(requests[index].id)
                        .delete();
                  },
                  child: ListTile(
                    title: Text(
                      request['RequestMovieName'],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      request['YearOrSeason'],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: Icon(
                      Icons.delete_sweep,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: Container(
          color: Colors.black38,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: GNav(
              backgroundColor: Colors.black38,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              gap: 4,
              color: Colors.yellow.shade200,
              selectedIndex: 2,
              activeColor: Colors.yellow.shade200,
              tabBackgroundColor: Colors.grey.shade800,
              padding: EdgeInsets.all(16.0),
              tabs: [
                GButton(
                  icon: Icons.play_arrow,
                  text: 'Movies',
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            AddMovies(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),
                GButton(
                  icon: Icons.file_copy,
                  text: 'Series',
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            AddSeries(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),
                GButton(
                  icon: Icons.inbox,
                  text: 'Requests',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
