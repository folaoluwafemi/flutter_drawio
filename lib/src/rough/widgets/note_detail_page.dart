import 'package:flutter/material.dart';
import 'package:flutter_drawer/src/global/global_barrel.dart';
import 'package:flutter_drawer/src/rough/drawing/drawing_barrel.dart';
import 'package:flutter_drawer/src/rough/toolbar/controller/toolbar_controller.dart';
import 'package:flutter_drawer/src/rough/toolbar/widget/toolbar_widget.dart';
import 'package:flutter_drawer/src/rough/widgets/drawing_canvas.dart';
import 'package:flutter_drawer/src/rough/widgets/drawing_controller.dart';
import 'package:flutter_drawer/src/utils/function/extensions/extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoteDetailPage extends StatelessWidget {
  const NoteDetailPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return true ? const NoteDetailPageX() : Container();
  }
}

class NoteDetailPageX extends StatefulWidget {
  const NoteDetailPageX({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NotePageState();
}

class _NotePageState extends State<NoteDetailPageX> {
  final double drawingBoundsVertical = 500;
  final double drawingBoundsHorizontal = 600;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          children: [
            20.boxHeight,
            ToolBarWidget(controller: toolbarController),
            20.boxHeight,
            ChangeNotifierBuilder<ToolbarController>(
              listenable: toolbarController,
              buildWhen: (previous, next) =>
                  previous?.drawingController == next.drawingController,
              builder: (_, controller) {
                return Container(
                  color: Colors.orange,
                  child: DrawingCanvas(
                    controller: controller.drawingController,
                    size: Size(
                      900.w,
                      600.h,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void changeColor(Color color) {
    controller.changeColor(color);
  }

  final DrawingController controller = DrawingController();
  final ValueNotifier<bool> erasingNotifier = ValueNotifier<bool>(false);

  void erasingCheckingCallback() {
    final bool isCurrentlyErasing = controller.drawingMode == DrawingMode.erase;

    if (isCurrentlyErasing ^ erasingNotifier.value) {
      erasingNotifier.value = isCurrentlyErasing;
    }
  }

  final ToolbarController toolbarController = ToolbarController();

  @override
  void initState() {
    controller.initialize();
    toolbarController.initialize();

    controller.addListener(erasingCheckingCallback);

    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(erasingCheckingCallback);
    controller.dispose();
    erasingNotifier.dispose();
    toolbarController.dispose();

    super.dispose();
  }
}
