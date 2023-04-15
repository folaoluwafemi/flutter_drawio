part of 'extensions.dart';

extension SizeExtension on Size {
  double get magnitude {
    return math.sqrt((height * height) + (width * width));
  }
}
