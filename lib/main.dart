import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie/app_constants.dart';
import 'package:flutter_movie/movie/pages/movie_page.dart';
import 'package:flutter_movie/movie/providers/movie_get_discover_provider.dart';
import 'package:flutter_movie/movie/repositories/movie_repository.dart';
import 'package:flutter_movie/movie/repositories/movie_repository_abstract.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final dioOptions = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      queryParameters: {'api_key': AppConstants.apiKey});

  final Dio dio = Dio(dioOptions);

  final MovieRepositoryAbstarct movieRepository = MovieRepository(dio);

  runApp(App(movieRepository: movieRepository));
  FlutterNativeSplash.remove();
}

class App extends StatelessWidget {
  const App({super.key, required this.movieRepository});

  final MovieRepositoryAbstarct movieRepository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MovieGetDiscoverProvider(movieRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Movie DB',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MoviePage(),
      ),
    );
  }
}
