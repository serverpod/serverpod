/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Provides high level information about a cache.
class CacheInfo extends _i1.SerializableEntity {
  CacheInfo({
    required this.numEntries,
    required this.maxEntries,
    this.keys,
  });

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

  /// Number of entries stored in the cache.
  int numEntries;

  /// Maximum number of entries that can be stored in the cache.
  int maxEntries;

  /// Optional list of keys used by the cache.
  List<String>? keys;

  @override
  Map<String, dynamic> toJson() {
    return {
      'numEntries': numEntries,
      'maxEntries': maxEntries,
      'keys': keys,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'numEntries': numEntries,
      'maxEntries': maxEntries,
      'keys': keys,
    };
  }
}
