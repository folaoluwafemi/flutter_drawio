part of 'eraser.dart';

class Region {
  final PointDouble centre;
  final double radius;

  const Region({
    required this.centre,
    required this.radius,
  });

  double get minX => centre.x - radius;

  double get maxX => centre.x + radius;

  double get minY => centre.y - radius;

  double get maxY => centre.y + radius;

  PointDouble get maxPoint => PointDouble(maxX, maxY);

  PointDouble get minPoint => PointDouble(minX, minY);

  bool containsPoint(PointDouble point) {
    final double x = point.x;
    final double y = point.y;

    final bool isPointInHorizontalRegion = x >= minX && x <= maxX;
    final bool isPointInVerticalRegion = y >= minY && y <= maxY;

    return isPointInHorizontalRegion && isPointInVerticalRegion;
  }

  Region copyWith({
    PointDouble? centre,
    double? radius,
  }) {
    return Region(
      centre: centre ?? this.centre,
      radius: radius ?? this.radius,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> centreMap = {'x': centre.x, 'y': centre.y};
    return {
      'centre': centreMap,
      'radius': radius,
    };
  }

  factory Region.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> centreMap = (map['centre'] as Map).cast();

    return Region(
      centre: PointDouble(
        centreMap['x'] as double,
        centreMap['y'] as double,
      ),
      radius: map['radius'] as double,
    );
  }
}
