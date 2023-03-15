import 'package:flutter/material.dart';

typedef ValueListenableSelectorCallback<T> = bool Function(
  T? previous,
  T current,
);

typedef ValueListenableSelectorBuilder<T> = Widget Function(
  BuildContext context,
  T value,
);

class ValueListenableSelector<T> extends StatefulWidget {
  final ValueNotifier<T> listenable;
  final ValueListenableSelectorCallback<T> buildWhen;
  final ValueListenableSelectorBuilder<T> builder;

  const ValueListenableSelector({
    required this.listenable,
    required this.buildWhen,
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  State<ValueListenableSelector<T>> createState() =>
      _ValueListenableSelectorState<T>();
}

class _ValueListenableSelectorState<T>
    extends State<ValueListenableSelector<T>> {
  late T? value;

  ValueNotifier<T> get listenable => widget.listenable;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.listenable.addListener(listenableChangeCallback);
  }

  @override
  void dispose() {
    widget.listenable.removeListener(listenableChangeCallback);
    super.dispose();
  }

  void listenableChangeCallback() {
    final bool shouldBuild = widget.buildWhen.call(
      value,
      listenable.value,
    );

    if (shouldBuild) {
      setState(() {});
    }
    value = listenable.value;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, listenable.value);
  }
}
