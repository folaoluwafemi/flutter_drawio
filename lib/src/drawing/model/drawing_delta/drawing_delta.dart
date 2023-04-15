import 'package:flutter_drawio/src/utils/utils_barrel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'actionable/drawing_operation.dart';

part 'drawing_metadata.dart';

class DrawingDelta with EquatableMixin {
  final PointDouble point;
  final DrawingOperation operation;
  final DrawingMetadata? metadata;

  const DrawingDelta({
    required this.point,
    this.operation = DrawingOperation.neutral,
    this.metadata,
  });

  @override
  String toString() {
    return '''DrawingDelta{
      point: $point,
      operation: $operation,
      metadata: $metadata
    }''';
  }

  DrawingDelta copyWith({
    PointDouble? point,
    DrawingOperation? operation,
    DrawingMetadata? metadata,
  }) {
    return DrawingDelta(
      point: point ?? this.point,
      operation: operation ?? this.operation,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [point, operation, metadata];

  Map<String, dynamic> toMap() {
    return {
      'point': point.toMap(),
      'operation': operation.toSerializerString,
      'metadata': metadata?.toMap(),
    };
  }

  factory DrawingDelta.fromMap(Map<String, dynamic> map) {
    return DrawingDelta(
      point: UtilFunctions.pointDoubleFromMap((map['point'] as Map).cast()),
      operation: DrawingOperation.fromString((map['operation'])),
      metadata: DrawingMetadata.fromMap((map['metadata'] as Map).cast()),
    );
  }
}
