part of '../toolbar_widget.dart';

class HueSlider extends StatefulWidget {
  final Color color;
  final Size size;
  final ValueChanged<Color> onChanged;

  const HueSlider({
    Key? key,
    required this.color,
    required this.onChanged,
    required this.size,
  }) : super(key: key);

  @override
  State<HueSlider> createState() => _HueSliderState();
}

class _HueSliderState extends State<HueSlider> {
  Color get color => widget.color.withOpacity(1);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    positionNotifier = ValueNotifier(
      UtilFunctions.extrapolateColors(color, colorList).toDouble() *
          widget.size.width,
    );

    print(
      'extrapolated color: ${UtilFunctions.extrapolateColors(color, colorList)}',
    );
    positionNotifier.addListener(changeColorByPointOffset);
  }

  void changeColorByPointOffset() {
    final double position = positionNotifier.value;
    print('hue position: $position');
    final Rect rect = context.findRenderObject()!.paintBounds;
    xRatio = position / rect.width;
    print('hue position xratio: $xRatio');
  }

  double xRatio = 0;

  void setChanged() {
    widget.onChanged(UtilFunctions.interpolateColors(xRatio, colorList));
  }

  List<Color> get colorList => [
        Colors.white,
        Color.lerp(Colors.white, color, 0.2)!,
        Color.lerp(Colors.white, color, 0.4)!,
        Color.lerp(Colors.white, color, 0.6)!,
        Color.lerp(Colors.white, color, 0.8)!,
        color,
        color,
        Color.lerp(Colors.black, color, 0.8)!,
        Color.lerp(Colors.black, color, 0.6)!,
        Color.lerp(Colors.black, color, 0.4)!,
        Color.lerp(Colors.black, color, 0.2)!,
        const Color(0xFF000000),
      ];

  late final List<Color> yAxisList = [
    Colors.white,
    const Color(0xFF000000),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        final Rect constraints = context.findRenderObject()!.paintBounds;
        if (!constraints.contains(Offset(details.localPosition.dx, 0))) return;
        positionNotifier.value = details.localPosition.dx;
        changeColorChanging(true);
      },
      onPanDown: (details) {
        final Rect constraints = context.findRenderObject()!.paintBounds;
        if (!constraints.contains(Offset(details.localPosition.dx, 0))) return;
        changeColorChanging(true);
        positionNotifier.value = details.localPosition.dx;
      },
      onPanEnd: (details) {
        changeColorChanging(false);
        setChanged();
      },
      onPanCancel: () {
        changeColorChanging(false);
        setChanged();
      },
      onPanUpdate: (details) {
        final Rect constraints = context.findRenderObject()!.paintBounds;
        if (!constraints.contains(Offset(details.localPosition.dx, 0))) return;
        positionNotifier.value = details.localPosition.dx;
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 8,
            width: widget.size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colorList,
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: colorChangingNotifier,
            builder: (_, changing, __) {
              return ValueListenableBuilder<double>(
                valueListenable: positionNotifier,
                builder: (_, position, __) {
                  return Positioned(
                    left: position,
                    child: Knob(
                      size: changing ? const Size.square(20) : null,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void changeColorChanging(bool value) {
    if (colorChangingNotifier.value ^ value) {
      colorChangingNotifier.value = value;
    }
  }

  late final ValueNotifier<Color> colorNotifier = ValueNotifier(color);
  late final ValueNotifier<bool> colorChangingNotifier = ValueNotifier<bool>(
    false,
  );
  late final ValueNotifier<double> positionNotifier;

  @override
  void dispose() {
    super.dispose();
    positionNotifier.removeListener(changeColorByPointOffset);
    positionNotifier.dispose();
    colorChangingNotifier.dispose();
    colorNotifier.dispose();
  }
}
// part of '../toolbar_widget.dart';
//
// class HueSlider extends StatefulWidget {
//   final Color color;
//   final Size size;
//   final ValueChanged<Color> onChanged;
//
//   const HueSlider({
//     Key? key,
//     required this.color,
//     required this.onChanged,
//     required this.size,
//   }) : super(key: key);
//
//   @override
//   State<HueSlider> createState() => _HueSliderState();
// }
//
// class _HueSliderState extends State<HueSlider> {
//   @override
//   void initState() {
//     super.initState();
//     positionNotifier.addListener(changeColorByPointOffset);
//   }
//
//   void changeColorByPointOffset() {
//     final Offset position = positionNotifier.value;
//     final Rect rect = context.findRenderObject()!.paintBounds;
//     xRatio = position.dx / rect.width;
//     yRatio = position.dy / rect.height;
//   }
//
//   double xRatio = 0;
//   double yRatio = 0;
//
//   Color interpolateColors(double xValue, double yValue) {
//     assert(xValue >= 0 || xValue <= 1, 'x-value must be between 0 and 1');
//     assert(yValue >= 0 || yValue <= 1, 'y-value must be between 0 and 1');
//
//     Color xAxisColor = Color.lerp(
//       xAxisList.first,
//       xAxisList.last,
//       xValue,
//     )!;
//     // xAxisColor = xAxisColor.withOpacity(
//     //   (xValue < 0.5 && yValue > 0.5)
//     //       ? (1 - xAxisColor.opacity).percent(50)
//     //       : xAxisColor.opacity,
//     // );
//
//     Color yAxisColor = Color.lerp(
//       yAxisList.first,
//       yAxisList.last,
//       yValue,
//     )!;
//
//     // yAxisColor = yAxisColor.withOpacity(
//     //   (yValue < 0.5 && xValue > 0.5)
//     //       ? yAxisColor.opacity.percent(50)
//     //       : (yValue > 0.5 && xValue > 0.5)
//     //           ? (1 - yAxisColor.opacity).percent(50)
//     //           : yAxisColor.opacity,
//     // );
//
//     print('\n');
//     print('xOpaticy: ${xAxisColor.opacity}');
//     print('yOpaticy: ${yAxisColor.opacity}');
//     print('\n');
//     print('xValue: $xValue');
//     print('yValue: $yValue');
//     print('\n');
//
//     // if (yValue >= 0.3) {
//       xAxisColor = xAxisColor.withOpacity(1);
//       yAxisColor = yAxisColor.withOpacity(1);
//     // }
//     // if (xValue >= 0.3) {
//       xAxisColor = xAxisColor.withOpacity(1);
//       yAxisColor = Color.lerp(xAxisColor, yAxisColor, yAxisColor.opacity)!;
//     // }
//
//     // if (yValue >= 0.7) {
//       yAxisColor = yAxisColor.withOpacity(1);
//       xAxisColor = Color.lerp(yAxisColor, xAxisColor, xAxisColor.opacity)!;
//     // }
//
//     double tValue = (xValue + yValue) / 2;
//     // tValue = Offset(xValue, yValue).distance;
//     print('tValue: $tValue');
//     print('\n');
//     final Color xAxisFavoured = Color.lerp(yAxisColor, xAxisColor, tValue)!;
//     final Color yAxisFavoured = Color.lerp(xAxisColor, yAxisColor, tValue)!;
//
//     // tValue = Curves.ease.transform(tValue);
//
//     if(yValue >= 9.0) return yAxisColor;
//
//     // return Color.lerp(yAxisFavoured, xAxisFavoured, 0.5)!;
//     return xAxisFavoured;
//     // return xValue > yValue
//     //     ? Color.lerp(yAxisColor, xAxisColor, tValue)!
//     //     : Color.lerp(yAxisColor, xAxisColor, tValue)!;
//     // return xAxisColor;
//     // return yAxisColor;
//   }
//
//   void setChanged() {
//     widget.onChanged(interpolateColors(xRatio, yRatio));
//   }
//
//   late final List<Color> xAxisList = [
//     widget.color.withOpacity(0),
//     widget.color.withOpacity(1),
//   ];
//   late final List<Color> yAxisList = [
//     Colors.white,
//     const Color(0xFF000000),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Color> colorList = [
//       widget.color.withOpacity(0),
//       widget.color,
//     ];
//     final List<Color> opacityList = [
//       Colors.white,
//       const Color(0xFF000000),
//     ];
//
//     print(widget.color.opacity);
//     return GestureDetector(
//       onPanStart: (details) {
//         final Rect constraints = context.findRenderObject()!.paintBounds;
//         if (!constraints.contains(details.localPosition)) return;
//         positionNotifier.value = details.localPosition;
//         setChanged();
//       },
//       onPanDown: (details) {
//         final Rect constraints = context.findRenderObject()!.paintBounds;
//         if (!constraints.contains(details.localPosition)) return;
//         changeColorChanging(true);
//         positionNotifier.value = details.localPosition;
//         setChanged();
//       },
//       onPanEnd: (details) {
//         changeColorChanging(false);
//         setChanged();
//       },
//       onPanUpdate: (details) {
//         final Rect constraints = context.findRenderObject()!.paintBounds;
//         final bool containsX = (constraints.width < details.localPosition.dx ||
//             constraints.width > details.localPosition.dx);
//         final bool containsY = constraints.height < details.localPosition.dy ||
//             constraints.height > details.localPosition.dy;
//
//         if (containsX && !containsY) {
//           positionNotifier.value = details.localPosition.copyWith(
//             dy: details.localPosition.dy < 0 ? 0 : constraints.width,
//           );
//           setChanged();
//           return;
//         }
//         if (!containsX && containsY) {
//           positionNotifier.value = details.localPosition.copyWith(
//             dx: details.localPosition.dx < 0 ? 0 : constraints.width,
//           );
//           setChanged();
//           return;
//         }
//         if (!constraints.contains(details.localPosition)) return;
//         positionNotifier.value = details.localPosition;
//         setChanged();
//       },
//       onPanCancel: () {
//         changeColorChanging(false);
//         setChanged();
//       },
//       child: Stack(
//         alignment: Alignment.centerLeft,
//         clipBehavior: Clip.none,
//         children: [
//           //y-axis
//           Container(
//             height: widget.size.height,
//             width: widget.size.width,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 transform: GradientRotation(math.pi / 2),
//                 colors: opacityList,
//               ),
//             ),
//           ),
//           //x-axis
//           Container(
//             height: widget.size.height,
//             width: widget.size.width,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: colorList,
//               ),
//             ),
//           ),
//           ValueListenableBuilder<bool>(
//             valueListenable: colorChangingNotifier,
//             builder: (_, changing, __) {
//               return ValueListenableBuilder<Offset>(
//                 valueListenable: positionNotifier,
//                 builder: (_, position, __) {
//                   return Positioned(
//                     left: position.dx,
//                     top: position.dy,
//                     child: Knob(
//                       size: changing ? const Size.square(15) : null,
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   void changeColorChanging(bool value) {
//     if (colorChangingNotifier.value ^ value) {
//       colorChangingNotifier.value = value;
//     }
//   }
//
//   late final ValueNotifier<Color> colorNotifier = ValueNotifier(widget.color);
//   late final ValueNotifier<bool> colorChangingNotifier = ValueNotifier<bool>(
//     false,
//   );
//   late final ValueNotifier<Offset> positionNotifier = ValueNotifier(
//     Offset.zero,
//   );
//
//   @override
//   void dispose() {
//     super.dispose();
//     positionNotifier.removeListener(changeColorByPointOffset);
//     positionNotifier.dispose();
//     colorChangingNotifier.dispose();
//     colorNotifier.dispose();
//   }
// }
