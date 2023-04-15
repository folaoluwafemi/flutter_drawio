import 'package:flutter/material.dart';
import 'package:drawer/drawer.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ExamplePage(),
      theme: ThemeData.dark(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final DrawingController controller = DrawingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DrawingCanvas(
        size: Size(
          MediaQuery.of(context).size.width * 0.9,
          MediaQuery.of(context).size.height * 0.9,
        ),
        controller: controller,
      ),
    );
  }
}

// appBar: AppBar(
// actions: [
// const Spacer(),
// IconButton(
// icon: const Icon(Icons.clear),
// onPressed: () => controller.clearDrawings(),
// ),
// IconButton(
// icon: const Icon(Icons.color_lens),
// onPressed: () => controller.changeColor(
// controller.color == Colors.red ? Colors.blue : Colors.red,
// ),
// ),
// ChangeNotifierBuilder(
// listenable: controller,
// builder: (context, controller) => IconButton(
// icon: controller.drawingMode == DrawingMode.sketch
// ? const Icon(Icons.format_shapes)
//     : const Icon(Icons.brush),
// onPressed: () => controller.changeDrawingMode(
// controller.drawingMode == DrawingMode.sketch
// ? DrawingMode.shape
//     : DrawingMode.sketch,
// ),
// ),
// ),
// //add icon buttons for all the shapes
// IconButton(
// icon: const Icon(Icons.circle_outlined),
// onPressed: () => controller.changeShape(Shape.circle),
// ),
// IconButton(
// icon: const Icon(Icons.star),
// onPressed: () => controller.changeShape(Shape.star),
// ),
// IconButton(
// icon: const Icon(Icons.crop_square),
// onPressed: () => controller.changeShape(Shape.rectangle),
// ),
// IconButton(
// icon: const Icon(Icons.signal_cellular_0_bar_rounded),
// onPressed: () => controller.changeShape(Shape.triangle),
// ),
//
// const Spacer(),
// ],
// ),
