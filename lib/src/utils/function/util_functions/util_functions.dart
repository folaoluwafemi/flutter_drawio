import 'package:flutter/material.dart';
import 'package:flutter_drawer/src/utils/utils_barrel.dart';

abstract class UtilFunctions {
  static bool listEqual(List list1, List list2) {
    if (list1.length != list2.length) return false;
    final int listLength = list1.length;
    for (int i = 0; i < listLength; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
