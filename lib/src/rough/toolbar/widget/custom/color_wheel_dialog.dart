part of '../toolbar_widget.dart';

class ColorSelector extends StatefulWidget {
  final ValueChanged<Color> onChanged;
  final Color color;
  final VoidCallback onClose;

  const ColorSelector({
    Key? key,
    required this.onChanged,
    required this.color,
    required this.onClose,
  }) : super(key: key);

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      width: 400.w,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select colour',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(
                    Icons.close,
                    size: 17,
                  ),
                ),
              ],
            ),
          ),
          MainColorSlider(
            color: colorNotifier.value,
            onChanged: onChanged,
          ),
          15.boxHeight,
          ValueListenableBuilder<Color>(
            valueListenable: colorNotifier,
            builder: (_, color, __) {
              return TransparencySlider(
                color: color,
                width: double.infinity,

                onChanged: onTransparencyChanged,
                // key: UniqueKey(),
              );
            },
          ),
          15.boxHeight,
          ValueListenableBuilder<Color>(
            valueListenable: hueColorNotifier,
            builder: (_, color, __) {
              return HueSlider(
                color: color,
                onChanged: onHueChanged,
                size: Size(
                  double.infinity,
                  240.r,
                ),
              );
            },
          ),
          15.boxHeight,
          ValueListenableBuilder<Color>(
            valueListenable: colorNotifier,
            builder: (_, color, __) {
              return Container(
                width: 40.r,
                height: 40.r,
                color: color,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    colorNotifier.addListener(colorChangeListener);
  }

  void colorChangeListener() {
    widget.onChanged(colorNotifier.value);
  }

  void onChanged(Color color) {
    colorNotifier.value = color.withOpacity(transparency);
    hueColorNotifier.value = color;
  }

  double transparency = 0;

  void onTransparencyChanged(double opacity) {
    transparency = opacity;
    colorNotifier.value = colorNotifier.value.withOpacity(transparency);
  }

  void onHueChanged(Color color) {
    colorNotifier.value = color.withOpacity(transparency);
  }

  late final ValueNotifier<Color> colorNotifier = ValueNotifier<Color>(
    widget.color,
  );
  late final ValueNotifier<Color> hueColorNotifier = ValueNotifier<Color>(
    widget.color,
  );

  @override
  void dispose() {
    colorNotifier.removeListener(colorChangeListener);
    colorNotifier.dispose();
    hueColorNotifier.dispose();
    super.dispose();
  }
}
