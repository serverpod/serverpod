/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:collection/collection.dart' as _i2;

/// Provides high level information about a cache.
abstract class CacheInfo extends _i1.SerializableEntity {
  const CacheInfo._();

  const factory CacheInfo({
    required int numEntries,
    required int maxEntries,
    List<String>? keys,
  }) = _CacheInfo;

  factory CacheInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return CacheInfo(
      numEntries: serializationManager
          .deserialize<int>(jsonSerialization['numEntries']),
      maxEntries: serializationManager
          .deserialize<int>(jsonSerialization['maxEntries']),
      keys: serializationManager
          .deserialize<List<String>?>(jsonSerialization['keys']),
    );
  }

  CacheInfo copyWith({
    int? numEntries,
    int? maxEntries,
    List<String>? keys,
  });

  /// Number of entries stored in the cache.
  int get numEntries;

  /// Maximum number of entries that can be stored in the cache.
  int get maxEntries;

  /// Optional list of keys used by the cache.
  List<String>? get keys;
}

class _Undefined {}

/// Provides high level information about a cache.
class _CacheInfo extends CacheInfo {
  const _CacheInfo({
    required this.numEntries,
    required this.maxEntries,
    this.keys,
  }) : super._();

  /// Number of entries stored in the cache.
  @override
  final int numEntries;

  /// Maximum number of entries that can be stored in the cache.
  @override
  final int maxEntries;

  /// Optional list of keys used by the cache.
  @override
  final List<String>? keys;

  @override
  Map<String, dynamic> toJson() {
    return {
      'numEntries': numEntries,
      'maxEntries': maxEntries,
      'keys': keys,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is CacheInfo &&
            (identical(
                  other.numEntries,
                  numEntries,
                ) ||
                other.numEntries == numEntries) &&
            (identical(
                  other.maxEntries,
                  maxEntries,
                ) ||
                other.maxEntries == maxEntries) &&
            const _i2.DeepCollectionEquality().equals(
              keys,
              other.keys,
            ));
  }

  @override
  int get hashCode => Object.hash(
        numEntries,
        maxEntries,
        const _i2.DeepCollectionEquality().hash(keys),
      );

  @override
  CacheInfo copyWith({
    int? numEntries,
    int? maxEntries,
    Object? keys = _Undefined,
  }) {
    return CacheInfo(
      numEntries: numEntries ?? this.numEntries,
      maxEntries: maxEntries ?? this.maxEntries,
      keys: keys == _Undefined ? this.keys : (keys as List<String>?),
    );
  }
}
