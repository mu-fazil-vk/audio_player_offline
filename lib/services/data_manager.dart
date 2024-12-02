import 'package:hive_flutter/hive_flutter.dart';

void addOrUpdateData(String category, String key, dynamic value) async {
  final box = await _openBox(category);
  await box.put(key, value);
}

Future getData(
  String category,
  String key, {
  dynamic defaultValue,
  Duration cachingDuration = const Duration(days: 30),
}) async {
  final box = await _openBox(category);
  return await box.get(key, defaultValue: defaultValue);
}

void deleteData(String category, String key) async {
  final box = await _openBox(category);
  await box.delete(key);
}

Future<Box> _openBox(String category) async {
  if (Hive.isBoxOpen(category)) {
    return Hive.box(category);
  } else {
    return Hive.openBox(category);
  }
}
