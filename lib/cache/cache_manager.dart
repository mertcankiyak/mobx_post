import 'package:flutter/material.dart';
import 'package:mobx_post/product/enums/hive_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._init();

  static CacheManager get instance => _instance;
  Box<dynamic>? _myBox;

  CacheManager._init() {
    Hive.openBox(BoxKeys.userInfoBox.toString()).then((value) {
      _myBox = value;
    });
  }

  static Future prefrencesInit() async {
    await Hive.initFlutter();
    instance._myBox = await Hive.openBox("testBox");
  }

  Future<void> setStringValue(
      {required HiveKeys key, required String value}) async {
    await _myBox?.put(key.toString(), value);
  }

  String getStringValue({required HiveKeys key}) {
    String value = _myBox?.get(key.toString()) ?? "";
    return value;
  }
}
