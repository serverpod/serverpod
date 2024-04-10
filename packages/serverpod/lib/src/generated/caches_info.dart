/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

/// High level information about the caches.
abstract class CachesInfo extends _i1.SerializableEntity {
  CachesInfo._({
    required this.local,
    required this.localPrio,
    required this.global,
  });

  factory CachesInfo({
    required _i2.CacheInfo local,
    required _i2.CacheInfo localPrio,
    required _i2.CacheInfo global,
  }) = _CachesInfoImpl;

  factory CachesInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return CachesInfo(
      local: _i2.CacheInfo.fromJson(
          (jsonSerialization['local'] as Map<String, dynamic>)),
      localPrio: _i2.CacheInfo.fromJson(
          (jsonSerialization['localPrio'] as Map<String, dynamic>)),
      global: _i2.CacheInfo.fromJson(
          (jsonSerialization['global'] as Map<String, dynamic>)),
    );
  }

  /// Information about the local cache.
  _i2.CacheInfo local;

  /// Information about the local priority cache.
  _i2.CacheInfo localPrio;

  /// Information about the global cache.
  _i2.CacheInfo global;

  CachesInfo copyWith({
    _i2.CacheInfo? local,
    _i2.CacheInfo? localPrio,
    _i2.CacheInfo? global,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'local': local.toJson(),
      'localPrio': localPrio.toJson(),
      'global': global.toJson(),
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'local': local.allToJson(),
      'localPrio': localPrio.allToJson(),
      'global': global.allToJson(),
    };
  }
}

class _CachesInfoImpl extends CachesInfo {
  _CachesInfoImpl({
    required _i2.CacheInfo local,
    required _i2.CacheInfo localPrio,
    required _i2.CacheInfo global,
  }) : super._(
          local: local,
          localPrio: localPrio,
          global: global,
        );

  @override
  CachesInfo copyWith({
    _i2.CacheInfo? local,
    _i2.CacheInfo? localPrio,
    _i2.CacheInfo? global,
  }) {
    return CachesInfo(
      local: local ?? this.local.copyWith(),
      localPrio: localPrio ?? this.localPrio.copyWith(),
      global: global ?? this.global.copyWith(),
    );
  }
}
