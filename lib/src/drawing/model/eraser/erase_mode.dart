part of 'eraser.dart';

/// This defines the erase mode of the [Eraser].
///
/// drawing - Erases the entire drawing
/// area - Erases the area/portion of the drawing
enum EraseMode {
  drawing,
  area;

  factory EraseMode.fromString(String data) {
    data = data.cleanLower;

    return EraseMode.values.firstWhere(
      (element) => element.name.cleanLower == data,
    );
  }

  String get toSerializerString => name;
}
