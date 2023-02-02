import 'package:flutter/material.dart';
import 'package:flutter_movie/movie/pages/movie_detail_page.dart';
import 'package:flutter_movie/movie/providers/movie_get_top_rated_provider.dart';
import 'package:flutter_movie/widget/image_widget.dart';
import 'package:provider/provider.dart';

class MoviePopularComponent extends StatefulWidget {
  const MoviePopularComponent({super.key});

  @override
  State<MoviePopularComponent> createState() => _MoviePopularComponentState();
}

class _MoviePopularComponentState extends State<MoviePopularComponent> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieGetTopRatedProvider>().getTopRated(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 200,
        child: Consumer<MovieGetTopRatedProvider>(
          builder: (context, value, child) {
            if (value.isLoading) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8)),
              );
            }

            if (value.movies.isNotEmpty) {
              return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return ImageWidget(
                      imageSrc: value.movies[index].posterPath,
                      height: 200,
                      width: 120,
                      radius: 8,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return MovieDetailPage(
                                id: value.movies[index].id,
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        width: 8,
                      ),
                  itemCount: value.movies.length);
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8)),
              child: const Center(
                child: Text(
                  'No data',
                  style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
