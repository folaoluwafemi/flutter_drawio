part of '../drawing.dart';

enum DrawingMode {
  erase,
  sketch,
  shape,
  line;

  factory DrawingMode.fromString(String data) {
    data = data.cleanLower;
    return DrawingMode.values.firstWhere(
      (element) => element.name.cleanLower == data,
    );
  }

  String get toSerializerString => name;
}
