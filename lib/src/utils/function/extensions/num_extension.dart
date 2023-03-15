part of 'extensions.dart';

extension NumExtension on num {
  ///returns value * (percentage/100)
  double percent(num percentage) => (this * (percentage / 100)).toDouble();

  SizedBox get boxHeight => SizedBox(
        height: h.toDouble(),
        width: 0,
      );

  SizedBox get boxWidth => SizedBox(
        height: 0,
        width: w.toDouble(),
      );
}
