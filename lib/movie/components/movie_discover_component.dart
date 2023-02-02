import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie/movie/pages/movie_detail_page.dart';
import 'package:flutter_movie/movie/providers/movie_get_discover_provider.dart';
import 'package:flutter_movie/widget/item_movie_widget.dart';
import 'package:provider/provider.dart';

class DiscoverMovieComponent extends StatefulWidget {
  const DiscoverMovieComponent({super.key});

  @override
  State<DiscoverMovieComponent> createState() => _DiscoverMovieComponentState();
}

class _DiscoverMovieComponentState extends State<DiscoverMovieComponent> {
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
                  return ItemMovieWidget(
                    movie: movie,
                    heightBackdrop: 300,
                    widthBackdrop: double.infinity,
                    heightPoster: 150,
                    widthPoster: 120,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MovieDetailPage(id: movie.id);
                          },
                        ),
                      );
                    },
                  );
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
  }
}
