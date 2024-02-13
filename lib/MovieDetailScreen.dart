import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_share/flutter_share.dart';
import 'ToastHelper.dart';

class Event {
  final String moviePoster;
  final String movieName;
  final String movieYear;
  final String movieDescription;
  final String movieDownloadButton720;
  final String movieDownloadButton1080;
  final String movieSize720;
  final String movieSize1080;
  final Map<String, dynamic> languages;

  Event({
    required this.moviePoster,
    required this.movieName,
    required this.movieYear,
    required this.movieDescription,
    required this.movieDownloadButton720,
    required this.movieDownloadButton1080,
    required this.movieSize720,
    required this.movieSize1080,
    required this.languages,
  });
}

class MovieDetailScreen extends StatefulWidget {
  final String docId;
  final String imageUrl;

  MovieDetailScreen({required this.docId, required this.imageUrl});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

Future<void> shareApp() async {
  // Set the app link and the message to be shared
  final String appLink = 'https://acromovie.live';
  final String message =
      'Check out my new app for Movies and TV Show: $appLink';
  // Share the app link and message using the share dialog
  await FlutterShare.share(
      // title: 'Acro Movie', text: message, linkUrl: appLink);
      title: 'Acro Movie',
      text: message);
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  String? _taskId;
  bool isDownload720 = true;
  bool isCancel720 = false;
  bool isDownload1080 = true;
  bool isCancel1080 = false;

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
                shareApp();
              },
              child: Icon(
                Icons.share,
                size: 25,
                // color: Colors.orange.shade300,
                color: Colors.yellow.shade200,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('MovieDetails')
            .doc(widget.docId)
            .get(),
        builder: (context, eventSnapshot) {
          // Check if event data is still loading
          if (eventSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.yellow,
                ),
              ),
            );
          }

          // Check if event data is not available or is null
          if (!eventSnapshot.hasData || eventSnapshot.data == null) {
            return const Center(child: Text('Event not found'));
          }

          // Parse event data from the snapshot
          final eventData = eventSnapshot.data!.data() as Map<String, dynamic>?;

          // Create an Event object with event details
          final event = Event(
            moviePoster: eventData?['moviePoster'] ?? '',
            movieName: eventData?['movieName'] ?? '',
            movieYear: eventData?['movieYear'] ?? '',
            movieDescription: eventData?['movieDescription'] ?? '',
            movieDownloadButton720: eventData?['movieDownloadButton720'] ?? '',
            movieDownloadButton1080:
                eventData?['movieDownloadButton1080'] ?? '',
            movieSize720: eventData?['movieSize720'] ?? '',
            movieSize1080: eventData?['movieSize1080'] ?? '',
            languages: eventData?['Language'] as Map<String, dynamic>? ?? {},
          );
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.network(
                        event.moviePoster,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        opacity: const AlwaysStoppedAnimation(0.3),
                      ),
                    ),
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: event.moviePoster,
                        width: 150,
                        height: 250,
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
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 25),
                  child: Center(
                    child: Text(
                      '${event.movieName}  (${event.movieYear})'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 30),
                  child: Text(
                    '${event.movieDescription}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      // letterSpacing: 2,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 50),
                    child: Text(
                      'DOWNLOAD LINKS',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 18,
                        // fontStyle: FontStyle.italic,
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 50),
                    child: Text(
                      'Quality: 720p',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        // fontStyle: FontStyle.italic,
                        // fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 20),
                    child: Text(
                      'File Size: ${event.movieSize720}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        // fontStyle: FontStyle.italic,
                        // fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, bottom: 40, top: 20),
                    child: Text(
                      'Language: ${event.languages.entries.where((e) => e.value == true).map((e) => e.key).join(' & ')}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        // fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: Opacity(
                        opacity: isDownload720 ? 1 : 0.2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            // final status = await Permission.storage.request();
                            var status = await Permission.manageExternalStorage
                                .request();

                            if (status.isGranted) {
                              if (event.movieDownloadButton720 != "null") {
                                if (isDownload720) {
                                  setState(() {
                                    isDownload720 = false;
                                    isCancel720 = true;
                                  });
                                  final externalDir =
                                      await getExternalStorageDirectory();

                                  _taskId = await FlutterDownloader.enqueue(
                                    url: "${event.movieDownloadButton720}",
                                    savedDir: externalDir!.path,
                                    showNotification: true,
                                    requiresStorageNotLow: true,
                                    openFileFromNotification: true,
                                    saveInPublicStorage: true,
                                  );
                                  ToastHelper.showToast('Download Started');
                                }
                              } else {
                                ToastHelper.showToast(
                                    'This Quality is not available');
                              }
                            } else {
                              print("Permission Denied");
                              ToastHelper.showToast('Permission Denied');
                            }
                          },
                          child: Text('DOWNLOAD'),
                        ),
                      ),
                    ),
                    Center(
                      child: Opacity(
                        opacity: isCancel720 ? 1 : 0.3,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            if (_taskId != null) {
                              if (isCancel720) {
                                await FlutterDownloader.cancel(
                                    taskId: _taskId!);
                                ToastHelper.showToast('Download Canceled');
                                setState(() {
                                  isDownload720 = true;
                                  isCancel720 = false;
                                  _taskId = null;
                                });
                              }
                            }
                          },
                          child: Text('CANCEL'),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 60),
                    child: Text(
                      'Quality : 1080p',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        // fontStyle: FontStyle.italic,
                        // fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 20),
                    child: Text(
                      'File Size : ${event.movieSize1080}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        // fontStyle: FontStyle.italic,
                        // fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, bottom: 40, top: 20),
                    child: Text(
                      'Language: ${event.languages.entries.where((e) => e.value == true).map((e) => e.key).join(' & ')}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        // fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: Opacity(
                        opacity: isDownload1080 ? 1 : 0.2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            // final status = await Permission.storage.request();
                            var status = await Permission.manageExternalStorage
                                .request();

                            if (status.isGranted) {
                              if (event.movieDownloadButton1080 != "null") {
                                if (isDownload1080) {
                                  setState(() {
                                    isDownload1080 = false;
                                    isCancel1080 = true;
                                  });
                                  final externalDir =
                                      await getExternalStorageDirectory();

                                  _taskId = await FlutterDownloader.enqueue(
                                    url: "${event.movieDownloadButton1080}",
                                    savedDir: externalDir!.path,
                                    showNotification: true,
                                    requiresStorageNotLow: true,
                                    openFileFromNotification: true,
                                    saveInPublicStorage: true,
                                  );
                                  ToastHelper.showToast('Download Started');
                                }
                              } else {
                                ToastHelper.showToast(
                                    'This Quality is not available');
                              }
                            } else {
                              print("Permission Denied");
                              ToastHelper.showToast('Permission Denied');
                            }
                          },
                          child: Text('DOWNLOAD'),
                        ),
                      ),
                    ),
                    Center(
                      child: Opacity(
                        opacity: isCancel1080 ? 1 : 0.3,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            if (_taskId != null) {
                              if (isCancel1080) {
                                await FlutterDownloader.cancel(
                                    taskId: _taskId!);
                                ToastHelper.showToast('Download Canceled');
                                setState(() {
                                  isDownload1080 = true;
                                  isCancel1080 = false;
                                  _taskId = null;
                                });
                              }
                            }
                          },
                          child: Text('CANCEL'),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 50),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.warning,
                      color: Colors.yellow,
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Important Notice',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.warning,
                      color: Colors.yellow,
                      size: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    'Please download one movie or TV show \nat a time for faster speeds and server stability.'
                        .toUpperCase(),
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
