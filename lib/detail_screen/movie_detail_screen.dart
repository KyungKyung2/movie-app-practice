import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieDetailScreen extends StatelessWidget {
  final int movieId;
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500/';

  MovieDetailScreen({required this.movieId});

  Future<Map<String, dynamic>> fetchMovieDetails() async {
    final response = await http.get(
        Uri.parse('https://movies-api.nomadcoders.workers.dev/movie?id=$movieId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Widget buildStarRating(double rating) {
    int fullStars = rating ~/ 2; // 10점 만점 기준을 5점 만점 기준으로 변환
    double halfStarThreshold = rating % 2; // 0.5점은 반쪽 별로 표시
    List<Widget> stars = [];

    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(Icon(Icons.star, color: Colors.amber, size: 24.0));
      } else if (i == fullStars && halfStarThreshold >= 1) {
        stars.add(Icon(Icons.star_half, color: Colors.amber, size: 24.0));
      } else {
        stars.add(Icon(Icons.star_border, color: Colors.amber, size: 24.0));
      }
    }
    return Row(
      children: stars,
    );
  }

  String formatRuntime(int runtime) {
    int hours = runtime ~/ 60;
    int minutes = runtime % 60;
    return '${hours}h ${minutes}min';
  }

  String formatGenres(List genres) {
    if (genres.isEmpty) return '';
    return genres.map((genre) => genre['name']).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchMovieDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load movie details'));
          } else {
            var movie = snapshot.data!;
            return Stack(
              children: [
                // 포스터 이미지 배경
                Positioned.fill(
                  child: Image.network(
                    imageBaseUrl + movie['poster_path'],
                    fit: BoxFit.cover,
                  ),
                ),
                // 어두운 오버레이
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                // 영화 정보
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50), // 상단 여백
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Text(
                              'Back to list',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          movie['title'],
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        buildStarRating(movie['vote_average']),
                        SizedBox(height: 8),
                        Text(
                          '${formatRuntime(movie['runtime'])} | ${formatGenres(movie['genres'])}',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Storyline',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          movie['overview'],
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Spacer(),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // 예매 기능 등을 연결할 수 있습니다.
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFC107), // 버튼 색상
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 80), // 버튼 크기
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Buy ticket',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 30), // 하단 여백
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
