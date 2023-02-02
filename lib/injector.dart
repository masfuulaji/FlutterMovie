import 'package:dio/dio.dart';
import 'package:flutter_movie/app_constants.dart';
import 'package:flutter_movie/movie/providers/movie_get_detail_provider.dart';
import 'package:flutter_movie/movie/providers/movie_get_discover_provider.dart';
import 'package:flutter_movie/movie/providers/movie_get_now_playing_provider.dart';
import 'package:flutter_movie/movie/providers/movie_get_top_rated_provider.dart';
import 'package:flutter_movie/movie/providers/movie_get_video_provider.dart';
import 'package:flutter_movie/movie/providers/movie_search_provider.dart';
import 'package:flutter_movie/movie/repositories/movie_repository.dart';
import 'package:flutter_movie/movie/repositories/movie_repository_abstract.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setup() {
  //Register Movie Provider
  getIt.registerFactory<MovieGetDiscoverProvider>(
    () => MovieGetDiscoverProvider(getIt()),
  );
  getIt.registerFactory<MovieGetTopRatedProvider>(
    () => MovieGetTopRatedProvider(getIt()),
  );
  getIt.registerFactory<MovieGetNowPlayingProvider>(
    () => MovieGetNowPlayingProvider(getIt()),
  );
  getIt.registerFactory<MovieGetDetailProvider>(
    () => MovieGetDetailProvider(getIt()),
  );
  getIt.registerFactory<MovieGetVideoProvider>(
    () => MovieGetVideoProvider(getIt()),
  );
  getIt.registerFactory<MovieSearchProvider>(
    () => MovieSearchProvider(getIt()),
  );

  //Register Movie Repository
  getIt.registerLazySingleton<MovieRepositoryAbstarct>(
      () => MovieRepository(getIt()));

  //Register Http Client (DIO)
  getIt.registerLazySingleton<Dio>(() => Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      queryParameters: {'api_key': AppConstants.apiKey})));
}
