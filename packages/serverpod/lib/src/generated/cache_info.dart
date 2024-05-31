/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Provides high level information about a cache.
abstract class CacheInfo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
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

  factory CacheInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return CacheInfo(
      numEntries: jsonSerialization['numEntries'] as int,
      maxEntries: jsonSerialization['maxEntries'] as int,
      keys: (jsonSerialization['keys'] as List?)
          ?.map((e) => e as String)
          .toList(),
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

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'numEntries': numEntries,
      'maxEntries': maxEntries,
      if (keys != null) 'keys': keys?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
