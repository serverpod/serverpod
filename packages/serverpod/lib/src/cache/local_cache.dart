import 'dart:async';

import 'package:collection/collection.dart';
import 'package:serverpod/src/cache/cache_miss_handler.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'cache.dart';

/// The [LocalCache] stores objects in the RAM memory locally on a [Server]. The
/// caches are typically automatically setup and managed by the [Server].
class LocalCache extends Cache {
  final List<_KeyListKey> _keyList = <_KeyListKey>[];
  final Map<String, _CacheEntry> _entries = <String, _CacheEntry>{};
  final Map<String, Set<String>> _groups = <String, Set<String>>{};

  /// New cache values currently being computed by a [CacheMissHandler]
  // The future values in here must not be resolved (at which state the value should just be in the cache), but just pending
  final _inProgressCacheValues = <String, Future<SerializableModel?>>{};

  /// Creates a new [LocalCache].
  LocalCache(super.maxEntries, super.serializationManager);

  @override
  Future<void> put(String key, SerializableModel object,
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

    if (entry.isExpired) {
      await invalidateKey(key);
      return false;
    }

    return true;
  }

  @override
  Future<T?> get<T extends SerializableModel>(
    String key, [
    /// Handler to generate a new value in case there is no active value in the cache
    ///
    /// In case a value computation from a previous [get] call is already running, the caller will receive the value from
    /// that call and the `cacheMissHandler` from this call will not be invoked.
    CacheMissHandler<T>? cacheMissHandler,
  ]) async {
    var entry = _entries[key];

    if (entry != null) {
      if (entry.isExpired) {
        await invalidateKey(key);
      } else {
        return serializationManager.decode<T>(entry.serializedObject);
      }
    }

    var pendingEntry = _inProgressCacheValues[key];
    if (pendingEntry != null) {
      return (await pendingEntry) as T;
    }

    if (cacheMissHandler == null) return null;

    T? value;
    var completer = Completer<T?>();
    try {
      _inProgressCacheValues[key] = completer.future;

      value = await cacheMissHandler.valueProvider();

      completer.complete(value);

      if (value == null) return null;
    } catch (e, stackTrace) {
      completer.completeError(e, stackTrace);

      rethrow;
    } finally {
      unawaited(_inProgressCacheValues.remove(key));
    }

    await put(
      key,
      value,
      lifetime: cacheMissHandler.lifetime,
      group: cacheMissHandler.group,
    );

    return value;
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

    if (idx == -1) return;

    // Step backwards in case entries have the exact same time
    while (idx > 0 && _keyList[idx - 1].creationTime == time) {
      idx--;
    }

    // Step forward until we find the key
    while (idx < _keyList.length && _keyList[idx].creationTime == time) {
      if (_keyList[idx].key == key) {
        break;
      }
      idx++;
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

  bool get isExpired {
    var expirationTime = this.expirationTime;
    return expirationTime != null && expirationTime.isBefore(DateTime.now());
  }
}

class _KeyListKey {
  final String key;
  final DateTime creationTime;

  _KeyListKey(this.key, this.creationTime);

  @override
  String toString() => 'KeyListKey($key, $creationTime)';
}
