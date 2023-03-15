part of '../toolbar_widget.dart';

class ShapeSelector extends StatefulWidget {
  final ValueChanged<Shape> onChanged;
  final Shape shape;
  final VoidCallback onClose;

  const ShapeSelector({
    Key? key,
    required this.onChanged,
    required this.shape,
    required this.onClose,
  }) : super(key: key);

  @override
  State<ShapeSelector> createState() => _ShapeSelectorState();
}

class _ShapeSelectorState extends State<ShapeSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select shape',
                style: context.textTheme.headlineLarge?.copyWith(
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
          ValueListenableBuilder<Shape>(
            valueListenable: shapeNotifier,
            builder: (_, shape, __) {
              return Column(
                children: [
                  ...Shape.values.map(
                    (e) => _ShapeWidget(
                      shape: e,
                      selected: e == shape,
                      onPressed: () => onShapeChanged(e),
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  void onClosePressed() {}

  void onShapeChanged(Shape shape) {
    shapeNotifier.value = shape;
    widget.onChanged(shapeNotifier.value);
  }

  late final ValueNotifier<Shape> shapeNotifier = ValueNotifier<Shape>(
    widget.shape,
  );

  @override
  void dispose() {
    super.dispose();
    shapeNotifier.dispose();
  }
}

class _ShapeWidget extends StatelessWidget {
  final Shape shape;
  final bool selected;
  final VoidCallback onPressed;

  const _ShapeWidget({
    Key? key,
    required this.shape,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 30.h,
      color: selected ? Colors.blue : null,
      onPressed: onPressed,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      child: Row(
        children: [
          SizedBox.square(
            dimension: 24.r,
            child: SvgPicture.asset(
              shape.assetPath,
              width: 24.r,
              height: 24.r,
              color: selected ? Colors.white : null,
            ),
          ),
          16.boxWidth,
          Text(
            shape.name.toFirstUpperCase(),
            style: TextStyle().copyWith(
              color: selected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
