import 'package:flutter/material.dart';
import 'package:flutter_movie/movie/models/movie_model.dart';
import 'package:flutter_movie/movie/repositories/movie_repository_abstract.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MovieGetNowPlayingProvider with ChangeNotifier {
  final MovieRepositoryAbstarct _movieRepositoryAbstarct;

  MovieGetNowPlayingProvider(this._movieRepositoryAbstarct);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<MovieModel> _movies = [];
  List<MovieModel> get movies => _movies;

  void getNowPlaying(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final result = await _movieRepositoryAbstarct.getNowPlaying();

    result.fold(
      (errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
        _isLoading = false;
        notifyListeners();
      },
      (response) {
        _movies.clear();
        _movies.addAll(response.results);
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void getNowPlayingWithPagination(
    BuildContext context, {
    required PagingController pagingController,
    required int page,
  }) async {
    final result = await _movieRepositoryAbstarct.getNowPlaying(page: page);

    result.fold(
      (errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );

        pagingController.error = errorMessage;
        return;
      },
      (response) {
        if (response.results.length < 20) {
          pagingController.appendLastPage(response.results);
        } else {
          pagingController.appendPage(response.results, page + 1);
        }
        return;
      },
    );
  }
}
