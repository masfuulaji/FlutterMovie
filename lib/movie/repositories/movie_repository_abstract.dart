import 'package:dartz/dartz.dart';
import 'package:flutter_movie/movie/models/movie_model.dart';

abstract class MovieRepositoryAbstarct {
  Future<Either<String, MovieResponseModel>> getDiscover({int page = 1});
}
