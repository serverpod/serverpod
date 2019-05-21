import 'package:collection/collection.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

class Cache {
  final int maxEntries;
  SerializationManager _serializationManager;

  List<_KeyListKey> _keyList = <_KeyListKey>[];
  Map<String, _CacheEntry> _entries = <String, _CacheEntry>{};
  Map<String, Set<String>> _groups = <String, Set<String>>{};

  Cache(this.maxEntries, this._serializationManager);

  void put(String key, SerializableEntity object, {Duration lifetime, String group}) {
    if (_keyList.length >= maxEntries) {
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
    if (get(key) != null)
      invalidateKey(key);

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
  }

  void _removeOldestEntry() {
    // Remove oldest key
    var oldKey = _keyList.removeLast();
    var entry = _entries.remove(oldKey);
    assert (entry != null);

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

  SerializableEntity get(String key) {
    var entry = _entries[key];
    if (entry == null)
      return null;

    if (entry.expirationTime.compareTo(DateTime.now()) > 0) {
      invalidateKey(key);
      return null;
    }

    return _serializationManager.createEntityFromSerialization(entry.serializedObject);
  }

  void invalidateKey(String key) {
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
      return a.creationTime.compareTo(b.creationTime);
    });
    if (idx != -1)
      _keyList.removeAt(idx);
  }

  void invalidateGroup(String group) {
    if (group == null)
      return;

    var keys = _groups[group];
    if (keys == null)
      return;

    // Make a copy of the set before starting to delete keys
    var keyList = keys.toList();
    for (var key in keyList) {
      invalidateKey(key);
    }
  }

  void clear() {
    _keyList.clear();
    _groups.clear();
    _entries.clear();
  }
}

class _CacheEntry {
  final String key;
  final String group;
  final Map<String, dynamic> serializedObject;
  final DateTime creationTime;
  final Duration lifetime;
  DateTime get expirationTime => creationTime.add(lifetime);

  _CacheEntry({this.key, this.group, this.serializedObject, this.lifetime,})
      : creationTime = DateTime.now();
}

class _KeyListKey {
  final String key;
  final DateTime creationTime;

  _KeyListKey(this.key, this.creationTime);
}
