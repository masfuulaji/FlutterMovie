import 'package:flutter/material.dart';
import 'package:flutter_movie/movie/models/movie_video_model.dart';
import 'package:flutter_movie/movie/repositories/movie_repository_abstract.dart';

class MovieGetVideoProvider with ChangeNotifier {
  final MovieRepositoryAbstarct _movieRepository;

  MovieGetVideoProvider(this._movieRepository);

  MovieVideosModel? _video;
  MovieVideosModel? get video => _video;

  void getVideo(BuildContext context, {required int id}) async {
    _video = null;
    notifyListeners();

    final result = await _movieRepository.getVideo(id: id);
    result.fold((messageError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(messageError)));
      _video = null;
      notifyListeners();
      return;
    }, (response) {
      _video = response;
      notifyListeners();
      return;
    });
  }
}
