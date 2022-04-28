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
    _CacheEntry entry = _CacheEntry(
      key: key,
      group: group,
      serializedObject: object.serializeAll(),
      lifetime: lifetime,
    );

    // Remove old entry
    if (await get(key) != null) await invalidateKey(key);

    // Insert
    _keyList.insert(0, _KeyListKey(key, entry.creationTime));
    _entries[key] = entry;

    if (group != null) {
      Set<String>? groupKeys = _groups[group];
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
    _KeyListKey oldKey = _keyList.removeLast();
    _CacheEntry entry = _entries.remove(oldKey.key)!;

    // Remove from group
    if (entry.group != null) _removeKeyFromGroup(oldKey.key, entry.group!);
  }

  void _removeKeyFromGroup(String key, String group) {
    Set<String> groupKeys = _groups[group]!;
    groupKeys.remove(key);
    if (groupKeys.isEmpty) _groups.remove(group);
  }

  @override
  Future<SerializableEntity?> get(String key) async {
    _CacheEntry? entry = _entries[key];
    if (entry == null) return null;

    if (entry.expirationTime != null &&
        entry.expirationTime!.compareTo(DateTime.now()) < 0) {
      await invalidateKey(key);
      return null;
    }

    return serializationManager
        .createEntityFromSerialization(entry.serializedObject);
  }

  @override
  Future<void> invalidateKey(String key) async {
    // Remove from entries
    _CacheEntry? entry = _entries.remove(key);
    if (entry == null) return;

    // Remove from group
    if (entry.group != null) _removeKeyFromGroup(key, entry.group!);

    // Remove from chronological list
    _removeKeyFromKeyList(key, entry.creationTime);
  }

  void _removeKeyFromKeyList(String key, DateTime time) {
    int idx = binarySearch<_KeyListKey>(_keyList, _KeyListKey(key, time),
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
    Set<String>? keys = _groups[group];
    if (keys == null) return;

    // Make a copy of the set before starting to delete keys
    List<String> keyList = keys.toList();
    for (String key in keyList) {
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
  final Map<String, dynamic> serializedObject;
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
