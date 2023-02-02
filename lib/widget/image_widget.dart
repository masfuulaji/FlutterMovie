import 'package:flutter/material.dart';
import 'package:flutter_movie/app_constants.dart';

enum TypeSrcImg { movieDb, external }

class ImageWidget extends StatelessWidget {
  const ImageWidget(
      {super.key,
      this.imageSrc,
      this.height,
      this.width,
      this.radius = 0,
      this.type = TypeSrcImg.movieDb,
      this.onTap});

  final String? imageSrc;
  final TypeSrcImg type;
  final double? height;
  final double? width;
  final double radius;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: _image(),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onTap,
            ),
          ),
        )
      ],
    );
  }

  Image _image() {
    return Image.network(
      type == TypeSrcImg.movieDb
          ? '${AppConstants.imageUrlW500}$imageSrc'
          : imageSrc!,
      height: height,
      width: width,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(color: Colors.grey[300]));
      },
      errorBuilder: (context, error, stackTrace) => SizedBox(
        height: height,
        width: width,
        child: const Icon(Icons.broken_image_rounded),
      ),
    );
  }
}
