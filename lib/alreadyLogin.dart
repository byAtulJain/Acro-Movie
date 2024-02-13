import 'package:final_movie_app/add_movies.dart';
import 'package:final_movie_app/admin_login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AlreadyLogin extends StatelessWidget {
  AlreadyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null)
          ? AddMovies()
          : AdminLoginPage(),
    );
  }
}
