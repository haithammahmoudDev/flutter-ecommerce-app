// import 'package:hive_ce_flutter/adapters.dart';
// import '../../features/home/domain/entities/category_entity_adapter.dart';
// import '../../features/home/domain/entities/product_adapter.dart';
//
// class TLocalStorage {
//   late final Box _storage;
//   static TLocalStorage? _instance;
//   TLocalStorage._internal();
//
//   factory TLocalStorage.instance() {
//     _instance ??= TLocalStorage._internal();
//     return _instance!;
//   }
//
//   static Future<void> init() async {
//     await Hive.initFlutter();
//
//     // Register adapters
//     if (!Hive.isAdapterRegistered(32)) {
//       Hive.registerAdapter(CategoryEntityAdapter());
//     }
//
//     if (!Hive.isAdapterRegistered(33)) {
//       Hive.registerAdapter(ProductEntityAdapter());
//     }
//
//     _instance = TLocalStorage._internal();
//
//     // Safely open or reuse the existing box
//     if (Hive.isBoxOpen('user_box')) {
//       _instance!._storage = Hive.box('user_box');
//     } else {
//       try {
//         _instance!._storage = await Hive.openBox('user_box');
//       } catch (e) {
//         try {
//           await Hive.deleteBoxFromDisk('user_box');
//         } catch (_) {}
//         _instance!._storage = await Hive.openBox('user_box');
//       }
//     }
//   }
//
//   Future<void> writeData<T>(String key, T value) async {
//     if (!_storage.isOpen) return;
//     await _storage.put(key, value);
//   }
//
//   T? readData<T>(String key) {
//     if (!_storage.isOpen) return null;
//     return _storage.get(key) as T?;
//   }
//
//   List<E>? readList<E>(String key) {
//     if (!_storage.isOpen) return null;
//     final value = _storage.get(key);
//     if (value == null) return null;
//     return (value as List).cast<E>();
//   }
//
//   Future<void> removeData(String key) async {
//     if (!_storage.isOpen) return;
//     await _storage.delete(key);
//   }
//
//   Future<void> clearAll() async {
//     if (!_storage.isOpen) return;
//     await _storage.clear();
//   }
// }