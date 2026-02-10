import 'package:nuPro/library/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:g_json/g_json.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

class UserStoreManager extends StoreManager {
  static final UserStoreManager shared = UserStoreManager();

  Future init() async {
    return await super.initStore(kStoreUser);
  }
}

class DeviceStoreManager extends StoreManager {
  static final DeviceStoreManager shared = DeviceStoreManager();

  Future init() async {
    return await super.initStore(kStoreDevice);
  }
}

class StoreManager {
  // late Box hiveStore;
  late GetStorage store;
  late String path;
  Future initStore(String storeName) async {
    path = await dataBasePath;
    await GetStorage(storeName, path).initStorage;
    store = GetStorage(storeName, path);
    debugPrint(path);
    // hiveStore = await Hive.openBox(storeName, path: path);
    // return;
    return;
  }

  Future<String> get dataBasePath async {
    final tempDir = await getApplicationDocumentsDirectory();
    return '${tempDir.path}/dataHiveStore';
  }

  Map<String, dynamic>? mapData(String key) {
    // final value = hiveStore.get(key);
    // return value != null
    //     ? Map.castFrom(hiveStore.get(key) as Map<dynamic, dynamic>)
    //     : null;
    return store.read<Map<String, dynamic>>(key);
  }

  JSON jsonData(String key) {
    // final map = mapData(key);
    // return JSON(map);
    final map = store.read<Map<String, dynamic>>(key);
    return JSON(map);
  }

  List<JSON> jsonList(String key) {
    // final list = hiveStore.get(key) as List<dynamic>?;
    // return JSON(list).listValue;
    final list = store.read<List<dynamic>>(key);
    return JSON(list).listValue;
  }

  T? data<T>(String key) {
    // return hiveStore.get(key) as T?;
    return store.read<T>(key);
  }

  bool hasData(String key) {
    // return hiveStore.get(key) != null;
    return store.hasData(key);
  }

  Future write(String key, dynamic value) async {
    // return await hiveStore.put(key, value);
    return await store.write(key, value);
  }

  Future writeAll(Map<String, dynamic> map) async {
    // return await hiveStore.putAll(map);
    // return await store.write(key, value);
  }

  Future deleteKey(String key) async {
    // return await hiveStore.delete(key);
    return await store.remove(key);
  }

  Future deleteStore() async {
    // return await hiveStore.clear();
    return await store.erase();
  }
}

class TokenStoreManager {
  static final store = GetStorage(kStoreToken);

  static Map<String, dynamic>? mapData(String key) {
    return store.read<Map<String, dynamic>>(key);
  }

  static JSON jsonData(String key) {
    final map = store.read<Map<String, dynamic>>(key);
    return JSON(map);
  }

  static T? data<T>(String key) {
    return store.read<T>(key);
  }

  static bool hasData(String key) {
    return store.hasData(key);
  }

  static Future write(String key, dynamic value) async {
    return store.write(key, value);
  }

  static Future deleteKey(String key) async {
    return store.remove(key);
  }

  static Future deleteStore() async {
    return store.erase();
  }
}
