import 'package:flutter/material.dart';
import 'package:flutter_movie/injector.dart';
import 'package:flutter_movie/movie/pages/movie_page.dart';
import 'package:flutter_movie/movie/providers/movie_get_discover_provider.dart';
import 'package:flutter_movie/movie/providers/movie_get_now_playing_provider.dart';
import 'package:flutter_movie/movie/providers/movie_get_top_rated_provider.dart';
import 'package:flutter_movie/movie/providers/movie_search_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  setup();
  runApp(const App());
  FlutterNativeSplash.remove();
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => getIt<MovieGetDiscoverProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<MovieGetTopRatedProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<MovieGetNowPlayingProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<MovieSearchProvider>(),
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
