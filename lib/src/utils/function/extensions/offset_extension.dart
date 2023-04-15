part of 'extensions.dart';

extension OffsetExtension on Offset {
  Offset copyWith({
    double? dx,
    double? dy,
  }) {
    return Offset(
      dx ?? this.dx,
      dy ?? this.dy,
    );
  }

  PointDouble get point => PointDouble(dx, dy);
}
