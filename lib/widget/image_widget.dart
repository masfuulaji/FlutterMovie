import 'package:flutter/material.dart';
import 'package:flutter_movie/app_constants.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget(
      {super.key,
      required this.imageSrc,
      required this.height,
      required this.width,
      this.radius = 0});

  final String imageSrc;
  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        '${AppConstants.imageUrlW500}$imageSrc',
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => SizedBox(
          height: height,
          width: width,
          child: const Icon(Icons.broken_image_rounded),
        ),
      ),
    );
  }
}
