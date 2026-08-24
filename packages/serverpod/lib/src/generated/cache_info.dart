/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod/src/generated/protocol.dart' as _ic00rqxb;

/// Provides high level information about a cache.
abstract class CacheInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
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
      keys: jsonSerialization['keys'] == null
          ? null
          : _ic00rqxb.Protocol().deserialize<List<String>>(
              jsonSerialization['keys'],
            ),
    );
  }

  /// Number of entries stored in the cache.
  int numEntries;

  /// Maximum number of entries that can be stored in the cache.
  int maxEntries;

  /// Optional list of keys used by the cache.
  List<String>? keys;

  /// Returns a shallow copy of this [CacheInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CacheInfo copyWith({
    int? numEntries,
    int? maxEntries,
    List<String>? keys,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.CacheInfo',
      'numEntries': numEntries,
      'maxEntries': maxEntries,
      if (keys != null) 'keys': keys?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.CacheInfo',
      'numEntries': numEntries,
      'maxEntries': maxEntries,
      if (keys != null) 'keys': keys?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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

  /// Returns a shallow copy of this [CacheInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CacheInfo copyWith({
    int? numEntries,
    int? maxEntries,
    Object? keys = _Undefined,
  }) {
    return CacheInfo(
      numEntries: numEntries ?? this.numEntries,
      maxEntries: maxEntries ?? this.maxEntries,
      keys: keys is List<String>? ? keys : this.keys?.map((e0) => e0).toList(),
    );
  }
}
