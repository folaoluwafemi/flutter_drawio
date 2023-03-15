part of 'drawing_delta.dart';

class DrawingMetadata with EquatableMixin {
  final Color? color;
  final double? strokeWidth;

  const DrawingMetadata({
    this.color,
    this.strokeWidth,
  });

  @override
  String toString() {
    return '''DrawingDeltaMetadata{
        color: $color,
        strokeWidth: $strokeWidth
      }''';
  }

  DrawingMetadata copyWith({
    Color? color,
    double? strokeWidth,
  }) {
    return DrawingMetadata(
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }

  @override
  List<Object?> get props => [color, strokeWidth];
}
