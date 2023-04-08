part of '../drawing_delta.dart';

enum DrawingOperation {
  start,
  end,
  neutral;

  factory DrawingOperation.fromString(String data) {
    data = data.cleanLower;
    return DrawingOperation.values.firstWhere(
      (element) => element.name.cleanLower == data,
    );
  }

  String get toSerializerString => name;
}
