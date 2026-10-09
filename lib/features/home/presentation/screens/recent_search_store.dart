import 'package:hive_ce_flutter/adapters.dart';

 class RecentSearchesStore {
  static const _boxName = 'recent_searches';
  static const _key = 'items';
  static const int maxItems = 8;

  Future<Box> _box() async =>
      Hive.isBoxOpen(_boxName) ? Hive.box(_boxName) : await Hive.openBox(_boxName);

  Future<List<String>> load() async {
    try {
      final v = (await _box()).get(_key);
      return v is List ? List<String>.from(v) : <String>[];
    } catch (_) {
      return <String>[];
    }
  }

  Future<List<String>> add(String query) async {
    final q = query.trim();
    if (q.isEmpty) return load();
    final items = await load();
    items.removeWhere((e) => e.toLowerCase() == q.toLowerCase());
    items.insert(0, q);
    if (items.length > maxItems) items.removeRange(maxItems, items.length);
    return _save(items);
  }

  Future<List<String>> remove(String query) async {
    final items = await load()
      ..removeWhere((e) => e.toLowerCase() == query.toLowerCase());
    return _save(items);
  }

  Future<List<String>> clear() => _save(<String>[]);

  Future<List<String>> _save(List<String> items) async {
    try {
      await (await _box()).put(_key, items);
    } catch (_) {}
    return items;
  }
}