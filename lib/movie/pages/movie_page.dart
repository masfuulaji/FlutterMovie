import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie/app_constants.dart';
import 'package:flutter_movie/movie/models/movie_model.dart';
import 'package:flutter_movie/movie/providers/movie_get_discover_provider.dart';
import 'package:flutter_movie/widget/image_widget.dart';
import 'package:provider/provider.dart';

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
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Discover Movies',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('See All'))
              ],
            ),
          ),
        ),
        const WidgetDiscoverMovie(),
      ],
    ));
  }
}

class WidgetDiscoverMovie extends StatefulWidget {
  const WidgetDiscoverMovie({super.key});

  @override
  State<WidgetDiscoverMovie> createState() => _WidgetDiscoverMovieState();
}

class _WidgetDiscoverMovieState extends State<WidgetDiscoverMovie> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieGetDiscoverProvider>().getDiscover(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<MovieGetDiscoverProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
              child: const Center(
                child: Text('Loading...',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black45)),
              ),
            );
          }
          if (provider.movies.isNotEmpty) {
            return CarouselSlider.builder(
                itemCount: provider.movies.length,
                itemBuilder: (context, index, realIndex) {
                  final movie = provider.movies[index];
                  return ItemMovie(movie);
                },
                options: CarouselOptions(
                  height: 300,
                  viewportFraction: 0.8,
                  reverse: false,
                  autoPlay: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ));
          }

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[300],
            ),
            child: const Center(
              child: Text('No Data',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black45)),
            ),
          );
        },
      ),
    );
    ;
  }
}

class ItemMovie extends Container {
  final MovieModel movie;

  ItemMovie(this.movie, {super.key});

  @override
  // TODO: implement clipBehavior
  Clip get clipBehavior => Clip.hardEdge;
  @override
  // TODO: implement decoration
  Decoration? get decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      );
  @override
  // TODO: implement child
  Widget? get child => Stack(
        children: [
          ImageWidget(
            imageSrc: '${movie.backdropPath}',
            height: 300,
            width: double.infinity,
          ),
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageWidget(
                    imageSrc: '${movie.posterPath}',
                    height: 150,
                    width: 100,
                    radius: 12,
                  ),
                  Text(
                    movie.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 16,
                      ),
                      Text(
                        '${movie.voteAverage} (${movie.voteCount}))',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      );
}
