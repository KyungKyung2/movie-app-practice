import 'package:flutter/material.dart';
import 'package:movie_app/sections/movie_section.dart';
import 'package:movie_app/sections/section_title.dart';



class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0), // 전체를 아래로 내리기 위한 상단 여백 추가
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백 추가
                child: SectionTitle(title: 'Popular Movies'),
              ),
              MovieSection(
                endpoint: 'https://movies-api.nomadcoders.workers.dev/popular',
                isLarge: true, // Popular Movies 섹션을 크게 표시
                isFullWidth: true, // 전체 너비를 사용
              ),
              SizedBox(height: 30), // 섹션 간의 충분한 여백 추가
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SectionTitle(title: 'Now in Cinemas'),
              ),
              MovieSection(
                endpoint: 'https://movies-api.nomadcoders.workers.dev/now-playing',
              ),
              SizedBox(height: 30), // 섹션 간의 충분한 여백 추가
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SectionTitle(title: 'Coming Soon'),
              ),
              MovieSection(
                endpoint: 'https://movies-api.nomadcoders.workers.dev/coming-soon',
              ),
              SizedBox(height: 50), // 마지막 섹션 하단에 여백 추가
            ],
          ),
        ),
      ),
    );
  }
}
