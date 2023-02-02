import 'package:flutter/material.dart';
import 'package:flutter_movie/movie/pages/movie_detail_page.dart';
import 'package:flutter_movie/movie/providers/movie_search_provider.dart';
import 'package:flutter_movie/widget/image_widget.dart';
import 'package:provider/provider.dart';

class MovieSearchPage extends SearchDelegate {
  @override
  String? get searchFieldLabel => "Search Movie";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (query.isNotEmpty) {
        context.read<MovieSearchProvider>().searchMovie(context, query);
      }
    });

    return Consumer<MovieSearchProvider>(
      builder: (context, value, child) {
        if (query.isEmpty) {
          return const Center(
            child: Text('Search Movie'),
          );
        }

        if (value.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (value.movies.isEmpty) {
          return const Center(
            child: Text('No Result'),
          );
        }

        if (value.movies.isNotEmpty) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final movie = value.movies[index];
              return Stack(
                children: [
                  Row(
                    children: [
                      ImageWidget(
                        imageSrc: movie.posterPath,
                        height: 120,
                        width: 80,
                        radius: 10,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              movie.overview,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Positioned.fill(
                      child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailPage(
                              id: movie.id,
                            ),
                          ),
                        );
                      },
                    ),
                  ))
                ],
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: value.movies.length,
          );
        }

        return const Center(
          child: Text('No Result'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SizedBox();
  }
}
