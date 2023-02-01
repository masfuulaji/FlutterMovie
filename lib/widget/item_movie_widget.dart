import 'package:flutter/material.dart';
import 'package:flutter_movie/movie/models/movie_detail_model.dart';

import '../movie/models/movie_model.dart';
import 'image_widget.dart';

class ItemMovieWidget extends Container {
  final MovieModel? movie;
  final MovieDetailModel? movieDetail;

  final double heightBackdrop;
  final double widthBackdrop;
  final double heightPoster;
  final double widthPoster;
  final double radius;
  final void Function()? onPressed;

  ItemMovieWidget(
      {required this.heightBackdrop,
      required this.widthBackdrop,
      required this.heightPoster,
      required this.widthPoster,
      this.radius = 12,
      this.movie,
      this.movieDetail,
      this.onPressed,
      super.key});

  @override
  Clip get clipBehavior => Clip.hardEdge;
  @override
  Decoration? get decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      );
  @override
  Widget? get child => Stack(
        children: [
          ImageWidget(
            imageSrc:
                '${movie != null ? movie!.backdropPath : movieDetail!.backdropPath}',
            height: heightBackdrop,
            width: widthBackdrop,
          ),
          Container(
            height: heightBackdrop,
            width: widthBackdrop,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageWidget(
                  imageSrc:
                      '${movie != null ? movie!.posterPath : movieDetail!.posterPath}',
                  height: heightPoster,
                  width: widthPoster,
                  radius: 12,
                ),
                Text(
                  movie != null ? movie!.title : movieDetail!.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16,
                    ),
                    Text(
                      movie != null
                          ? '${movie!.voteAverage} (${movie!.voteCount})'
                          : '${movieDetail!.voteAverage} (${movieDetail!.voteCount})',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onPressed!(),
            ),
          ))
        ],
      );
}
