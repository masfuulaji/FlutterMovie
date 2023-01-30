import 'package:flutter/material.dart';
import 'package:flutter_movie/movie/models/movie_model.dart';
import 'package:flutter_movie/movie/providers/movie_get_discover_provider.dart';
import 'package:flutter_movie/movie/providers/movie_get_now_playing_provider.dart';
import 'package:flutter_movie/movie/providers/movie_get_top_rated_provider.dart';
import 'package:flutter_movie/widget/item_movie_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

enum TypeMovie {
  discover,
  topRated,
  nowPlaying,
}

class MoviePaginationPage extends StatefulWidget {
  const MoviePaginationPage({super.key, required this.typeMovie});

  final TypeMovie typeMovie;
  @override
  State<MoviePaginationPage> createState() => _MoviePaginationPageState();
}

class _MoviePaginationPageState extends State<MoviePaginationPage> {
  final PagingController<int, MovieModel> _pagingController = PagingController(
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      switch (widget.typeMovie) {
        case TypeMovie.discover:
          context.read<MovieGetDiscoverProvider>().getDiscoverWithPagination(
                context,
                pagingController: _pagingController,
                page: pageKey,
              );
          break;
        case TypeMovie.topRated:
          context.read<MovieGetTopRatedProvider>().getTopRatedWithPagination(
                context,
                pagingController: _pagingController,
                page: pageKey,
              );
          break;
        case TypeMovie.nowPlaying:
          context
              .read<MovieGetNowPlayingProvider>()
              .getNowPlayingWithPagination(
                context,
                pagingController: _pagingController,
                page: pageKey,
              );
          break;
        default:
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Builder(builder: (context) {
          switch (widget.typeMovie) {
            case TypeMovie.discover:
              return const Text('Discover Movies');
            case TypeMovie.topRated:
              return const Text('Popular Movies');
            case TypeMovie.nowPlaying:
              return const Text('Now Playing Movies');
            default:
              return const Text('Movie DB');
          }
        }),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      body: PagedListView<int, MovieModel>.separated(
        padding: const EdgeInsets.all(16),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<MovieModel>(
          itemBuilder: (context, item, index) => ItemMovieWidget(
            movie: item,
            heightBackdrop: 260,
            widthBackdrop: double.infinity,
            heightPoster: 120,
            widthPoster: 80,
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
