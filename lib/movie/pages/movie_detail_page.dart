import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_movie/injector.dart';
import 'package:flutter_movie/movie/providers/movie_get_detail_provider.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key, required this.id});

  final int id;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          getIt<MovieGetDetailProvider>()..getDetail(context, id: id),
      builder: (context, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            Consumer<MovieGetDetailProvider>(
              builder: (context, value, child) {
                if (value.movie != null) {
                  log(value.movie.toString());
                }
                return SliverAppBar(
                  title: Text(value.movie == null ? '' : value.movie!.title),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
