import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/detail_screen/movie_detail_screen.dart';

class MovieSection extends StatelessWidget {
  final String endpoint;
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500/';
  final bool isLarge;
  final bool isFullWidth;

  MovieSection({
    required this.endpoint,
    this.isLarge = false,
    this.isFullWidth = false,
  });

  Future<List> fetchMovies(String endpoint) async {
    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: fetchMovies(endpoint),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load movies'));
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: SizedBox(
              height: isLarge ? 220 : 200,
              width: isFullWidth ? MediaQuery.of(context).size.width : null,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var movie = snapshot.data![index];
                  var imageUrl = movie['poster_path'] != null
                      ? imageBaseUrl + movie['poster_path']
                      : 'https://via.placeholder.com/100x150';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailScreen(movieId: movie['id']),
                        ),
                      );
                    },
                    child: Container(
                      width: isLarge
                          ? MediaQuery.of(context).size.width * 0.85
                          : 120,
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.fitWidth,
                          width: isLarge
                              ? MediaQuery.of(context).size.width * 0.85
                              : 120,
                          height: isLarge ? 180 : 150,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
