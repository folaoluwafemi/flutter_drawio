part of '../toolbar_widget.dart';



class MainColorSlider extends StatefulWidget {
  final ValueChanged<Color> onChanged;
  final Color color;

  const MainColorSlider({
    Key? key,
    required this.onChanged,
    required this.color,
  }) : super(key: key);

  @override
  State<MainColorSlider> createState() => _MainColorSliderState();
}

class _MainColorSliderState extends State<MainColorSlider> {
  @override
  void initState() {
    super.initState();

    positionNotifier.addListener(changeColorByPointOffset);
  }

  void changeColorByPointOffset() {
    final double xRange = positionNotifier.value;
    final double width = context.findRenderObject()!.paintBounds.width;
    final double xRangeRatio = positionNotifier.value / width;

    widget.onChanged(interpolateColors(xRangeRatio, mainColors));
  }

  Color interpolateColors(double value, List<Color> colors) {
    assert(value >= 0 || value <= 1, 'value must be between 0 and 1');
    final int colorListLength = colors.length - 1;
    final int maxExpectedIndex = (colorListLength * value).ceil();
    final int minExpectedIndex = (colorListLength * value).floor();

    final Color minColor = colors[minExpectedIndex];
    final Color maxColor = colors[maxExpectedIndex];

    return Color.lerp(minColor, maxColor, value)!;
  }

  int extrapolateColors(Color value, List<Color> colors) {
    int difference = 100000000;

    for (final Color color in colors) {
      final int temp = (color.value - value.value).abs();
      if (temp < difference) {
        difference = temp;
      }
    }

    return difference;
  }

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
      onPanEnd: (details) => changeColorChanging(false),
      onPanUpdate: (details) {
        final Rect constraints = context.findRenderObject()!.paintBounds;
        if (!constraints.contains(Offset(details.localPosition.dx, 0))) return;
        positionNotifier.value = details.localPosition.dx;
      },
      onPanCancel: () => changeColorChanging(false),
      child: Stack(
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              gradient: LinearGradient(colors: mainColors),
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

  final ValueNotifier<bool> colorChangingNotifier = ValueNotifier<bool>(false);
  late final ValueNotifier<double> positionNotifier = ValueNotifier<double>(
    extrapolateColors(widget.color, mainColors).toDouble(),
  );

  final List<Color> mainColors = const [
    Color(0xFFFF0000),
    Color(0xFFFF8A00),
    Color(0xFFFFE600),
    Color(0xFF14FF00),
    Color(0xFF00A3FF),
    Color(0xFF0500FF),
    Color(0xFFAD00FF),
    Color(0xFFAD00FF),
    Color(0xFFFF0000),
  ];

  @override
  void dispose() {
    super.dispose();
    positionNotifier.removeListener(changeColorByPointOffset);
    positionNotifier.dispose();
    colorChangingNotifier.dispose();
  }
}
