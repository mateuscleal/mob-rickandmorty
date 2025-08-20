import 'package:hive_flutter/hive_flutter.dart';

class HiveManager {
  static const String _boxName = 'hiveManager';
  static final Map<int, List < bool>> _listKv = {};

  Map<int, List<dynamic>> get listKv => _listKv;

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);

    final box = Hive.box(_boxName);

    _listKv.clear();
    final keys = box.keys;
    final values = box.values;

    for (int i = 0; i < keys.length; i++) {
      _listKv[keys.elementAt(i)] = values.elementAt(i);
    }
  }

  static Future<void> setValue(int key, List <dynamic> value) async {
    final box = Hive.box(_boxName);
    await box.put(key, value);
  }
}