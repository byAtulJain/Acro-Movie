import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_movie_app/UserRequestList.dart';
import 'package:final_movie_app/add_series.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'ToastHelper.dart';
import 'home_screen.dart';

class AddMovies extends StatefulWidget {
  const AddMovies({super.key});

  @override
  State<AddMovies> createState() => _AddMoviesState();
}

class _AddMoviesState extends State<AddMovies> {
  TextEditingController movieNameController = TextEditingController();
  TextEditingController movieYearController = TextEditingController();
  TextEditingController movieDescriptionController = TextEditingController();
  TextEditingController movieDownloadButton720Controller =
      TextEditingController();
  TextEditingController movieDownloadButton1080Controller =
      TextEditingController();
  TextEditingController movieSize720Controller = TextEditingController();
  TextEditingController movieSize1080Controller = TextEditingController();
  File? moviePoster;
  bool isHindi = false;
  bool isEnglish = false;
  String? movieQuality;

  void logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void uploadMovie() async {
    final systemDate = DateTime.now();
    String movieName = movieNameController.text.trim();
    String movieYear = movieYearController.text.trim();
    String movieDescription = movieDescriptionController.text.trim();
    String movieDownloadButton720 =
        movieDownloadButton720Controller.text.trim();
    String movieDownloadButton1080 =
        movieDownloadButton1080Controller.text.trim();
    String movieSize720 = movieSize720Controller.text.trim();
    String movieSize1080 = movieSize1080Controller.text.trim();

    if (moviePoster != null &&
        movieName != null &&
        movieYear != null &&
        movieDescription != null &&
        movieDownloadButton720 != null &&
        movieDownloadButton1080 != null &&
        movieSize720 != null &&
        movieSize1080 != null) {
      movieNameController.clear();
      movieYearController.clear();
      movieDescriptionController.clear();
      movieDownloadButton720Controller.clear();
      movieDownloadButton1080Controller.clear();
      movieSize720Controller.clear();
      movieSize1080Controller.clear();

      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("moviePoster")
          .child(Uuid().v1())
          .putFile(moviePoster!);

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      Map<String, dynamic> MovieData = {
        "moviePoster": downloadUrl,
        "movieName": movieName,
        "movieYear": movieYear,
        "movieDescription": movieDescription,
        "movieDownloadButton720": movieDownloadButton720,
        "movieDownloadButton1080": movieDownloadButton1080,
        "Type": "Movies",
        "movieSize720": movieSize720,
        "movieSize1080": movieSize1080,
        'TodayDate': systemDate,
        "Language": {
          "Hindi": isHindi,
          "English": isEnglish,
        },
        "quality": movieQuality,
      };
      FirebaseFirestore.instance
          .collection("MovieDetails")
          .doc(movieName)
          .set(MovieData);
      print("Movie Uploaded");
      ToastHelper.showToast('Movie Uploaded');
    } else {
      ToastHelper.showToast('Fill all details!');
      print("Fill all details!");
    }
    setState(() {
      moviePoster = null;
      isEnglish = false;
      isHindi = false;
      movieQuality = null;
    });
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: CupertinoButton(
                    onPressed: () async {
                      XFile? selectedImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (selectedImage != null) {
                        File convertedFile = File(selectedImage.path);
                        setState(() {
                          moviePoster = convertedFile;
                        });
                        print("Image Selected");
                        ToastHelper.showToast('Image Selected');
                      } else {
                        ToastHelper.showToast('No Image Selected');
                        print("No Image Selected");
                      }
                    },
                    padding: EdgeInsets.zero,
                    child: CircleAvatar(
                      radius: 60.0,
                      backgroundImage: (moviePoster != null)
                          ? FileImage(moviePoster!)
                          : null,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Movie Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: movieNameController,
                  decoration: InputDecoration(
                    hintText: 'Movie Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Movie Year',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: movieYearController,
                  decoration: InputDecoration(
                    hintText: 'Movie Year',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Movie Description',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: movieDescriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Movie Description',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '720 Movie Download Button',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: movieDownloadButton720Controller,
                  decoration: InputDecoration(
                    hintText: '720 Movie Download Button',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '720 Movie Size',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: movieSize720Controller,
                  decoration: InputDecoration(
                    hintText: '720 Movie Size',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '1080 Movie Download Button',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: movieDownloadButton1080Controller,
                  decoration: InputDecoration(
                    hintText: '1080 Movie Download Button',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '1080 Movie Size',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: movieSize1080Controller,
                  decoration: InputDecoration(
                    hintText: '1080 Movie Size',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Select Languages',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                CheckboxListTile(
                  title: Text("Hindi"),
                  // activeColor: Colors.white,
                  tileColor: Colors.white,
                  value: isHindi,
                  onChanged: (newValue) {
                    setState(() {
                      isHindi = newValue!;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                SizedBox(height: 16.0),
                CheckboxListTile(
                  title: Text("English"),
                  tileColor: Colors.white,
                  value: isEnglish,
                  onChanged: (newValue) {
                    setState(() {
                      isEnglish = newValue!;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                SizedBox(height: 16.0),
                Text(
                  'Select Quality',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text(
                          'CAM',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        value: 'CAM',
                        tileColor: Colors.white,
                        groupValue: movieQuality,
                        onChanged: (String? value) {
                          setState(() {
                            movieQuality = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text(
                          'HD',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        value: 'HD',
                        tileColor: Colors.white,
                        groupValue: movieQuality,
                        onChanged: (String? value) {
                          setState(() {
                            movieQuality = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text(
                          'WEB',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        value: 'WEB',
                        tileColor: Colors.white,
                        groupValue: movieQuality,
                        onChanged: (String? value) {
                          setState(() {
                            movieQuality = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      uploadMovie();
                    },
                    child: Text('Add Movie'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              gap: 4,
              color: Colors.yellow.shade200,
              selectedIndex: 0,
              activeColor: Colors.yellow.shade200,
              tabBackgroundColor: Colors.grey.shade800,
              padding: EdgeInsets.all(16.0),
              tabs: [
                GButton(
                  icon: Icons.play_arrow,
                  text: 'Movies',
                  onPressed: () {},
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            UserRequestList(),
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
      ),
    );
  }
}
