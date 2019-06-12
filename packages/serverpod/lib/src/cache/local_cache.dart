import 'package:collection/collection.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'cache.dart';

class LocalCache extends Cache {

  List<_KeyListKey> _keyList = <_KeyListKey>[];
  Map<String, _CacheEntry> _entries = <String, _CacheEntry>{};
  Map<String, Set<String>> _groups = <String, Set<String>>{};

  LocalCache(int maxEntries, SerializationManager serializationManager) : super(maxEntries, serializationManager);

  Future<Null> put(String key, SerializableEntity object, {Duration lifetime, String group}) async {
    if (_keyList.length >= maxLocalEntries) {
      _removeOldestEntry();
    }

    // Create entry
    var entry = _CacheEntry(
      key: key,
      group: group,
      serializedObject: object.serializeAll(),
      lifetime: lifetime,
    );

    // Remove old entry
    if (await get(key) != null)
      await invalidateKey(key);

    // Insert
    _keyList.insert(0, _KeyListKey(key, entry.creationTime));
    _entries[key] = entry;

    if (group != null) {
      var groupKeys = _groups[group];
      if (groupKeys == null) {
        _groups[group] = <String>{key};
      }
      else {
        groupKeys.add(key);
      }
    }

    assert(_entries.length == _keyList.length, 'Entry length and key list length mismatch ${_entries.length} / ${_keyList.length}');
  }

  void _removeOldestEntry() {
    // Remove oldest key
    var oldKey = _keyList.removeLast();
    var entry = _entries.remove(oldKey.key);
    assert (entry != null, 'Failed to find oldKey: $oldKey');

    // Remove from group
    if (entry.group != null)
      _removeKeyFromGroup(oldKey.key, entry.group);
  }

  void _removeKeyFromGroup(String key, String group) {
    if (group != null) {
      var groupKeys = _groups[group];
      groupKeys.remove(key);
      if (groupKeys.length == 0)
        _groups.remove(group);
    }
  }

  Future<SerializableEntity> get(String key) async {
    var entry = _entries[key];
    if (entry == null)
      return null;

    if (entry.expirationTime != null && entry.expirationTime.compareTo(DateTime.now()) < 0) {
      await invalidateKey(key);
      return null;
    }

    return serializationManager.createEntityFromSerialization(entry.serializedObject);
  }

  Future<Null> invalidateKey(String key) async {
    // Remove from entries
    var entry = _entries.remove(key);
    if (entry == null)
      return;

    // Remove from group
    if (entry.group != null)
      _removeKeyFromGroup(key, entry.group);

    // Remove from chronological list
    _removeKeyFromKeyList(key, entry.creationTime);
  }

  void _removeKeyFromKeyList(String key, DateTime time) {
    int idx = binarySearch<_KeyListKey>(_keyList, _KeyListKey(key, time), compare: (_KeyListKey a, _KeyListKey b) {
      return b.creationTime.compareTo(a.creationTime);
    });

    assert(idx != -1);

    // Step backwards in case entries have the exact same time
    while(idx > 0 && _keyList[idx - 1].creationTime == time)
      idx --;

    while(idx < _keyList.length && _keyList[idx].creationTime == time) {
      if (_keyList[idx].key == key) {
        break;
      }
    }

    _keyList.removeAt(idx);
  }

  Future< Null> invalidateGroup(String group) async {
    if (group == null)
      return;

    var keys = _groups[group];
    if (keys == null)
      return;

    // Make a copy of the set before starting to delete keys
    var keyList = keys.toList();
    for (var key in keyList) {
      await invalidateKey(key);
    }
  }

  Future<Null> clear() async {
    _keyList.clear();
    _groups.clear();
    _entries.clear();
  }

  int get localSize  {
    assert(_entries.length == _keyList.length, 'Entry length and key list length mismatch ${_entries.length} / ${_keyList.length}');
    assert(_groups.length <= _entries.length);
    return _entries.length;
  }

  List<String> get localKeys => _entries.keys.toList();
}

class _CacheEntry {
  final String key;
  final String group;
  final Map<String, dynamic> serializedObject;
  final DateTime creationTime;
  final Duration lifetime;
  DateTime get expirationTime => lifetime == null ? null : creationTime.add(lifetime);

  _CacheEntry({this.key, this.group, this.serializedObject, this.lifetime,})
      : creationTime = DateTime.now();
}

class _KeyListKey {
  final String key;
  final DateTime creationTime;

  _KeyListKey(this.key, this.creationTime);

  String toString() => 'KeyListKey($key, $creationTime)';
}
