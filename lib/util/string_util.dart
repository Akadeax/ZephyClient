import 'package:flutter/scheduler.dart';

import '../main.dart';

String shortenIfNeeded(String original, [int shortenLen = 10]) {
  if(original.length <= shortenLen) return original;
  return original.substring(0, shortenLen) + "...";
}
