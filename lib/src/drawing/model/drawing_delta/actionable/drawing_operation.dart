part of '../drawing_delta.dart';

/// This defines what stage the [Offset] of the user's gesture is in
///
/// start - The user has just started drawing
/// neutral - The user is currently drawing
/// end - The user has just finished drawing
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
