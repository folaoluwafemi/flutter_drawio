part of '../toolbar_widget.dart';

class TransparencySlider extends StatefulWidget {
  final ValueChanged<double> onChanged;
  final Color color;
  final double width;

  const TransparencySlider({
    Key? key,
    required this.onChanged,
    required this.color,
    required this.width,
  }) : super(key: key);

  @override
  State<TransparencySlider> createState() => _TransparencySliderState();
}

class _TransparencySliderState extends State<TransparencySlider> {
  @override
  void initState() {
    super.initState();
    positionNotifier = ValueNotifier<double>(
      widget.width * widget.color.opacity,
    );
    positionNotifier.addListener(changeColorByPointOffset);
  }

  double ratio = 0;

  void changeColorByPointOffset() {
    final double position = positionNotifier.value;
    final double width = context.findRenderObject()!.paintBounds.width;
    final double xRangeRatio = position / width;
    ratio = xRangeRatio;
  }

  void setChanged() {
    widget.onChanged(ratio);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.color.opacity);
    return GestureDetector(
      onPanStart: (details) {
        final Rect constraints = context.findRenderObject()!.paintBounds;
        if (!constraints.contains(details.localPosition)) return;
        positionNotifier.value = details.localPosition.dx;
        changeColorChanging(true);
        setChanged();
      },
      onPanDown: (details) {
        final Rect constraints = context.findRenderObject()!.paintBounds;
        if (!constraints.contains(details.localPosition)) return;
        changeColorChanging(true);
        positionNotifier.value = details.localPosition.dx;
        setChanged();
      },
      onPanEnd: (details) {
        changeColorChanging(false);
        setChanged();
      },
      onPanUpdate: (details) {
        final Rect constraints = context.findRenderObject()!.paintBounds;
        if (!constraints.contains(details.localPosition)) return;
        positionNotifier.value = details.localPosition.dx;
        setChanged();
      },
      onPanCancel: () {
        changeColorChanging(false);
        setChanged();
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 8,
            width: widget.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.color.withOpacity(0),
                  widget.color.withOpacity(1),
                ],
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

  final ValueNotifier<bool> colorChangingNotifier = ValueNotifier<bool>(false);
  late final ValueNotifier<double> positionNotifier;

  @override
  void dispose() {
    super.dispose();
    positionNotifier.removeListener(changeColorByPointOffset);
    positionNotifier.dispose();
    colorChangingNotifier.dispose();
  }
}
