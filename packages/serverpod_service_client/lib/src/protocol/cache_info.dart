/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Provides high level information about a cache.
abstract class CacheInfo extends _i1.SerializableEntity {
  CacheInfo._({
    required this.numEntries,
    required this.maxEntries,
    this.keys,
  });

  factory CacheInfo({
    required int numEntries,
    required int maxEntries,
    List<String>? keys,
  }) = _CacheInfoImpl;

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

  CacheInfo copyWith({
    int? numEntries,
    int? maxEntries,
    List<String>? keys,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'numEntries': numEntries,
      'maxEntries': maxEntries,
      if (keys != null) 'keys': keys?.toJson(),
    };
  }
}

class _Undefined {}

class _CacheInfoImpl extends CacheInfo {
  _CacheInfoImpl({
    required int numEntries,
    required int maxEntries,
    List<String>? keys,
  }) : super._(
          numEntries: numEntries,
          maxEntries: maxEntries,
          keys: keys,
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
      keys: keys is List<String>? ? keys : this.keys?.clone(),
    );
  }
}
