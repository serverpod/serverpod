import 'package:collection/collection.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'cache.dart';

/// The [LocalCache] stores objects in the RAM memory locally on a [Server]. The
/// caches are typically automatically setup and managed by the [Server].
class LocalCache extends Cache {
  final List<_KeyListKey> _keyList = <_KeyListKey>[];
  final Map<String, _CacheEntry> _entries = <String, _CacheEntry>{};
  final Map<String, Set<String>> _groups = <String, Set<String>>{};

  /// Creates a new [LocalCache].
  LocalCache(int maxEntries, SerializationManager serializationManager)
      : super(maxEntries, serializationManager);

  @override
  Future<void> put(String key, SerializableEntity object,
      {Duration? lifetime, String? group}) async {
    if (_keyList.length >= maxLocalEntries) {
      _removeOldestEntry();
    }

    // Create entry
    var entry = _CacheEntry(
      key: key,
      group: group,
      serializedObject: SerializationManager.encode(object),
      lifetime: lifetime,
    );

    // Remove old entry
    if (await containsKey(key)) await invalidateKey(key);

    // Insert
    _keyList.insert(0, _KeyListKey(key, entry.creationTime));
    _entries[key] = entry;

    if (group != null) {
      var groupKeys = _groups[group];
      if (groupKeys == null) {
        _groups[group] = <String>{key};
      } else {
        groupKeys.add(key);
      }
    }

    assert(_entries.length == _keyList.length,
        'Entry length and key list length mismatch ${_entries.length} / ${_keyList.length}');
  }

  void _removeOldestEntry() {
    // Remove oldest key
    var oldKey = _keyList.removeLast();
    var entry = _entries.remove(oldKey.key)!;

    // Remove from group
    if (entry.group != null) _removeKeyFromGroup(oldKey.key, entry.group!);
  }

  void _removeKeyFromGroup(String key, String group) {
    var groupKeys = _groups[group]!;
    groupKeys.remove(key);
    if (groupKeys.isEmpty) _groups.remove(group);
  }

  @override
  Future<bool> containsKey(String key) async {
    var entry = _entries[key];

    if (entry == null) return false;

    if ((entry.expirationTime?.compareTo(DateTime.now()) ?? 0) < 0) {
      await invalidateKey(key);
      return false;
    }

    return true;
  }

  @override
  Future<T?> get<T extends SerializableEntity>(String key, [Type? t]) async {
    var entry = _entries[key];

    if (entry == null) return null;

    if ((entry.expirationTime?.compareTo(DateTime.now()) ?? 0) < 0) {
      await invalidateKey(key);
      return null;
    }

    return serializationManager.decode<T>(entry.serializedObject);
  }

  @override
  Future<void> invalidateKey(String key) async {
    // Remove from entries
    var entry = _entries.remove(key);
    if (entry == null) return;

    // Remove from group
    if (entry.group != null) _removeKeyFromGroup(key, entry.group!);

    // Remove from chronological list
    _removeKeyFromKeyList(key, entry.creationTime);
  }

  void _removeKeyFromKeyList(String key, DateTime time) {
    var idx = binarySearch<_KeyListKey>(_keyList, _KeyListKey(key, time),
        compare: (_KeyListKey a, _KeyListKey b) {
      return b.creationTime.compareTo(a.creationTime);
    });

    assert(idx != -1);

    // Step backwards in case entries have the exact same time
    while (idx > 0 && _keyList[idx - 1].creationTime == time) {
      idx--;
    }

    while (idx < _keyList.length && _keyList[idx].creationTime == time) {
      if (_keyList[idx].key == key) {
        break;
      }
    }

    _keyList.removeAt(idx);
  }

  @override
  Future<void> invalidateGroup(String group) async {
    var keys = _groups[group];
    if (keys == null) return;

    // Make a copy of the set before starting to delete keys
    var keyList = keys.toList();
    for (var key in keyList) {
      await invalidateKey(key);
    }
  }

  @override
  Future<void> clear() async {
    _keyList.clear();
    _groups.clear();
    _entries.clear();
  }

  @override
  int get localSize {
    assert(_entries.length == _keyList.length,
        'Entry length and key list length mismatch ${_entries.length} / ${_keyList.length}');
    assert(_groups.length <= _entries.length);
    return _entries.length;
  }

  @override
  List<String> get localKeys => _entries.keys.toList();
}

class _CacheEntry {
  final String key;
  final String? group;
  final String serializedObject;
  final DateTime creationTime;
  final Duration? lifetime;
  DateTime? get expirationTime =>
      lifetime == null ? null : creationTime.add(lifetime!);

  _CacheEntry({
    required this.key,
    this.group,
    required this.serializedObject,
    this.lifetime,
  }) : creationTime = DateTime.now();
}

class _KeyListKey {
  final String key;
  final DateTime creationTime;

  _KeyListKey(this.key, this.creationTime);

  @override
  String toString() => 'KeyListKey($key, $creationTime)';
}
