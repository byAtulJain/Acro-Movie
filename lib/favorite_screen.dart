import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MovieDetailScreen.dart';

class FavoriteScreen extends StatefulWidget {
  final String imageURL;
  final String movieName;

  const FavoriteScreen({
    Key? key,
    required this.imageURL,
    required this.movieName,
  }) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<String> _favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    // Load the list of favorite movies from storage
    _loadFavorites();
  }

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favoriteMovies');
    if (favorites != null) {
      setState(() {
        _favoriteMovies = favorites;
      });
    }
  }

  void _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoriteMovies', _favoriteMovies);
  }

  void _toggleFavorite() {
    setState(() {
      if (_favoriteMovies.contains(widget.imageURL)) {
        _favoriteMovies.remove(widget.imageURL);
      } else {
        _favoriteMovies.add(widget.imageURL);
      }
      _saveFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.6,
        ),
        itemCount: _favoriteMovies.length,
        itemBuilder: (context, index) {
          final imageURL = _favoriteMovies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      MovieDetailScreen(
                    docId: '',
                    imageUrl: imageURL,
                  ),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            child: Stack(
              children: [
                ClipRRect(
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
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: Icon(
                      Icons.favorite,
                      color: _favoriteMovies.contains(imageURL)
                          ? Colors.red
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
