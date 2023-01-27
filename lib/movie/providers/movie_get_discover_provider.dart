import 'package:flutter/material.dart';
import 'package:flutter_movie/movie/models/movie_model.dart';
import 'package:flutter_movie/movie/repositories/movie_repository_abstract.dart';

class MovieGetDiscoverProvider with ChangeNotifier {
  final MovieRepositoryAbstarct _movieRepositoryAbstarct;

  MovieGetDiscoverProvider(this._movieRepositoryAbstarct);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<MovieModel> _movies = [];
  List<MovieModel> get movies => _movies;

  void getDiscover(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final result = await _movieRepositoryAbstarct.getDiscover();

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
}
