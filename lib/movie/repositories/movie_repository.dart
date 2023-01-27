import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_movie/movie/models/movie_model.dart';
import 'package:flutter_movie/movie/repositories/movie_repository_abstract.dart';

class MovieRepository implements MovieRepositoryAbstarct {
  final Dio _dio;

  MovieRepository(this._dio);

  @override
  Future<Either<String, MovieResponseModel>> getDiscover({int page = 1}) async {
    try {
      final result = await _dio.get(
        '/discover/movie',
        queryParameters: {'page': page},
      );

      if (result.statusCode == 200 && result.data != null) {
        final model = MovieResponseModel.fromJson(result.data);
        return Right(model);
      }

      return const Left('Error while fetching data');
    } on DioError catch (e) {
      if (e.response != null) {
        return Left(e.response.toString());
      }

      return const Left('Error while fetching data');
    }
  }
}
