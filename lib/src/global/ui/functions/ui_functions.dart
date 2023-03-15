import 'package:flutter/material.dart';

abstract class Ui {
  static BorderRadius allBorderRadius(double radius) => BorderRadius.all(
        Radius.circular(radius),
      );

  static BorderRadius topBorderRadius(double radius) => BorderRadius.vertical(
        top: Radius.circular(radius),
      );

  static BorderRadius bottomBorderRadius(double radius) =>
      BorderRadius.vertical(
        bottom: Radius.circular(radius),
      );

  static Widget imageLoadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) return child;
    return Container(
      color: Colors.white.withOpacity(0.3),
      child: Center(
        child: Opacity(
          opacity: 0.7,
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        ),
      ),
    );
  }

  static Widget generalImageErrorBuilder(context, error, stackTrace) {
    return Container(
      color: Colors.grey,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 25,
        ),
      ),
    );
  }
}
