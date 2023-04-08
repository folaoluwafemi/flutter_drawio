// import 'package:flutter_drawer/src/global/global_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'list_extension.dart';

part 'num_extension.dart';

part 'string_extension.dart';

extension ColorExtension on Color {
  String get toSerializerString => value.toString().removeAll('#');
}
