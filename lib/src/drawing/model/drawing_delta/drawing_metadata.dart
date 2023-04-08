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

  Map<String, dynamic> toMap() {
    return {
      'color': (color ?? AppColors.black).toSerializerString,
      'strokeWidth': strokeWidth,
    };
  }

  factory DrawingMetadata.fromMap(Map<String, dynamic> map) {
    return DrawingMetadata(
      color: Color(int.parse(map['color'].toString())),
      strokeWidth: (map['strokeWidth'] as num?)?.toDouble(),
    );
  }
}
