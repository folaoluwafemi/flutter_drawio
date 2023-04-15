<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# drawer

A flutter package for drawing on a canvas with an api provided for serialization and deserialization of the drawn data.

## Features

- Sketch scribbles
- Draw shapes (rectangle, circle, triangle, star)
- erasing
- supports erase by area or drawing
- serialization and deserialization of drawn data

## Getting started

Add it to your pubspec.yaml file under dependencies like so:

```yaml
dependencies:
  drawer: ^0.0.1+1
```

or use commandline

```bash
flutter pub add drawer
```

then import it in your dart file

```dart
import 'package:drawer/drawer.dart';
```

## Usage

```dart
final DrawingController controller = DrawingController();

@override
void dispose() {
  //don't forget to dispose the controller
  controller.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: DrawingCanvas(
        //required param
      size: Size( 
        MediaQuery.of(context).size.width * 0.9,
        MediaQuery.of(context).size.height * 0.9,
      ),
      controller: controller,
    ),
  );
}
```

## Additional information

To create issues, prs or otherwise contribute in anyway see [contribution guide](https://github.com/folaoluwafemi/drawer/blob/main/CONTRIBUTION_GUIDE.md).
See our roadmap [here](https://github.com/folaoluwafemi/drawer/blob/main/ROADMAP.md)
