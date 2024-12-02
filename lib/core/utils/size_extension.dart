import 'package:flutter/material.dart';

extension SizeExtension on num {
  // custom screen width
  Widget get pw => SizedBox(width: toDouble());
  // custom screen height
  Widget get ph => SizedBox(height: toDouble());
}
