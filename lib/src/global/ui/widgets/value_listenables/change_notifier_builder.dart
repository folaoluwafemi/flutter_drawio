import 'package:flutter/material.dart';

typedef ChangeNotifierSelector<T extends ChangeNotifier> = bool Function(
  T? previous,
  T next,
);

typedef ChangeNotifierBuilderCallback<T extends ChangeNotifier> = Widget
    Function(BuildContext context, T value);

class ChangeNotifierBuilder<T extends ChangeNotifier> extends StatefulWidget {
  final ChangeNotifierBuilderCallback<T> builder;
  final T listenable;
  final ChangeNotifierSelector<T>? buildWhen;

  const ChangeNotifierBuilder({
    Key? key,
    required this.listenable,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  State<ChangeNotifierBuilder<T>> createState() =>
      _ChangeNotifierBuilderState<T>();
}

class _ChangeNotifierBuilderState<T extends ChangeNotifier>
    extends State<ChangeNotifierBuilder<T>> {
  T? listenable;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.listenable.addListener(changeListener);
    });
  }

  void changeListener() {
    final bool? shouldSetState = widget.buildWhen?.call(
      listenable,
      widget.listenable,
    );
    if (shouldSetState ?? true) {
      setState(() {});
    }
    listenable = widget.listenable;
  }

  @override
  void didUpdateWidget(ChangeNotifierBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listenable != widget.listenable) {
      oldWidget.listenable.removeListener(changeListener);
      listenable = widget.listenable;
      widget.listenable.addListener(changeListener);
    }
  }

  @override
  void dispose() {
    widget.listenable.removeListener(changeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, widget.listenable);
  }
}
