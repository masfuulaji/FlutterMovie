import 'package:flutter/material.dart';
import 'package:flutter_movie/movie/components/movie_discover_component.dart';
import 'package:flutter_movie/movie/components/movie_now_playing_component.dart';
import 'package:flutter_movie/movie/components/movie_top_rated_component.dart';
import 'package:flutter_movie/movie/pages/movie_pagination_page.dart';

class MoviePage extends StatelessWidget {
  const MoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Image.asset('assets/images/logo_movie_big.png'),
                ),
              ),
              const Text('Movie DB'),
            ],
          ),
          floating: true,
          snap: true,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        _WidgetTitle(
          title: 'Discover Movies',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const MoviePaginationPage(typeMovie: TypeMovie.discover),
              ),
            );
          },
        ),
        const DiscoverMovieComponent(),
        _WidgetTitle(
          title: 'Top Rated Movies',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const MoviePaginationPage(typeMovie: TypeMovie.topRated),
              ),
            );
          },
        ),
        const MoviePopularComponent(),
        _WidgetTitle(
          title: 'Now Playing Movies',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const MoviePaginationPage(typeMovie: TypeMovie.nowPlaying),
              ),
            );
          },
        ),
        const MovieNowPlayingComponent()
      ],
    ));
  }
}

class _WidgetTitle extends SliverToBoxAdapter {
  final String title;
  final void Function() onPressed;

  const _WidgetTitle({required this.title, required this.onPressed});
  @override
  Widget? get child => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                  shape: const StadiumBorder(),
                ),
                child: const Text('See All'))
          ],
        ),
      );
}
