import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie/movie/models/movie_detail_model.dart';
import 'package:flutter_movie/movie/repositories/movie_repository_abstract.dart';

class MovieGetDetailProvider with ChangeNotifier {
  final MovieRepositoryAbstarct _movieRepository;

  MovieGetDetailProvider(this._movieRepository);

  MovieDetailModel? _movie;
  MovieDetailModel? get movie => _movie;

  void getDetail(BuildContext context, {required int id}) async {
    _movie = null;
    notifyListeners();

    final result = await _movieRepository.getDetail(id: id);
    result.fold((messageError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(messageError)));
      _movie = null;
      notifyListeners();
      return;
    }, (response) {
      _movie = response;
      notifyListeners();
      return;
    });
  }
}
