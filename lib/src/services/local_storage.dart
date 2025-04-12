// Implmentation of local storage service

import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

// Implementation of local storage service using Hive
class LocalStorage extends IlocalStorageService {
  @override
  Future<void> deleteAll() async {
    // TODO: implement deleteAll
    await Hive.deleteFromDisk();
  }

  @override
  Future<void> deleteBox({required String boxName}) async {
    try {
      await Hive.deleteBoxFromDisk(boxName);
    } on Exception catch (e) {
      Logger().e(e);
    }
  }

  @override
  Future<void> deleteRecord({required String boxName, required String key}) {
    throw UnimplementedError();
  }

  @override
  Future read({
    required String boxName,
    required String key,
    defaultValue,
  }) async {
    // TODO: implement read
    try {
      var box = await Hive.openBox(boxName);
      return box.get(key, defaultValue: defaultValue);
    } on Exception catch (e) {
      Logger().e(e);
      return defaultValue;
    }
  }

  @override
  Future<void> write({
    required String boxName,
    required String key,
    required value,
  }) async {
    // TODO: implement write
    var box = await Hive.openBox(boxName);
    await box.put(key, value);
  }
}

// Interface for local storage service
abstract class IlocalStorageService {
  Future<dynamic> read({
    required String boxName,
    required String key,
    dynamic defaultValue,
  });
  Future<void> write({
    required String boxName,
    required String key,
    required dynamic value,
  });
  Future<void> deleteAll();
  Future<void> deleteRecord({required String boxName, required String key});
  Future<void> deleteBox({required String boxName});
}
