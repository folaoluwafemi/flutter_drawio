part of 'eraser.dart';

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
