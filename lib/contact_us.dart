import 'package:final_movie_app/series_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_screen.dart';
import 'movie_screen.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
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
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Center(
                child: Text(
                  'Follow us via',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    final Uri url =
                        Uri.parse('https://instagram.com/acro_movie');
                    launchUrl(url);
                  },
                  child: Image.asset(
                    'images/Instagram_logo.png',
                    width: 120,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'acromoviehelp@gmail.com',
                    );

                    launchUrl(emailLaunchUri);
                  },
                  child: Image.asset(
                    'images/Gmail_logo.png',
                    width: 120,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    final Uri url = Uri.parse('https://t.me/byAtulJain');
                    launchUrl(url);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Image.asset(
                      'images/Telegram_logo.png',
                      width: 170,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final Uri url = Uri.parse('https://www.acromovie.live');
                    launchUrl(url);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Image.asset(
                      'images/share_logo.png',
                      width: 130,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ],
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
