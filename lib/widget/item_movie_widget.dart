import 'package:flutter/material.dart';

import '../movie/models/movie_model.dart';
import 'image_widget.dart';

class ItemMovieWidget extends Container {
  final MovieModel movie;

  final double heightBackdrop;
  final double widthBackdrop;
  final double heightPoster;
  final double widthPoster;
  final void Function()? onPressed;

  ItemMovieWidget(
      {required this.movie,
      required this.heightBackdrop,
      required this.widthBackdrop,
      required this.heightPoster,
      required this.widthPoster,
      this.onPressed,
      super.key});

  @override
  Clip get clipBehavior => Clip.hardEdge;
  @override
  Decoration? get decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      );
  @override
  Widget? get child => Stack(
        children: [
          ImageWidget(
            imageSrc: '${movie.backdropPath}',
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
                  imageSrc: '${movie.posterPath}',
                  height: heightPoster,
                  width: widthPoster,
                  radius: 12,
                ),
                Text(
                  movie.title,
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
                      '${movie.voteAverage} (${movie.voteCount})',
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
