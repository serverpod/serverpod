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
import 'package:serverpod/serverpod.dart' as _i1;
import '../scopes/serverOnly/server_only_class.dart' as _i2;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i3;

abstract class ServerOnlyClassField
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ServerOnlyClassField._({
    this.serverOnlyClassList,
    this.serverOnlyClassMap,
  });

  factory ServerOnlyClassField({
    List<_i2.ServerOnlyClass>? serverOnlyClassList,
    Map<String, _i2.ServerOnlyClass>? serverOnlyClassMap,
  }) = _ServerOnlyClassFieldImpl;

  factory ServerOnlyClassField.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ServerOnlyClassField(
      serverOnlyClassList: jsonSerialization['serverOnlyClassList'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.ServerOnlyClass>>(
              jsonSerialization['serverOnlyClassList'],
            ),
      serverOnlyClassMap: jsonSerialization['serverOnlyClassMap'] == null
          ? null
          : _i3.Protocol().deserialize<Map<String, _i2.ServerOnlyClass>>(
              jsonSerialization['serverOnlyClassMap'],
            ),
    );
  }

  List<_i2.ServerOnlyClass>? serverOnlyClassList;

  Map<String, _i2.ServerOnlyClass>? serverOnlyClassMap;

  /// Returns a shallow copy of this [ServerOnlyClassField]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ServerOnlyClassField copyWith({
    List<_i2.ServerOnlyClass>? serverOnlyClassList,
    Map<String, _i2.ServerOnlyClass>? serverOnlyClassMap,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ServerOnlyClassField',
      if (serverOnlyClassList != null)
        'serverOnlyClassList': serverOnlyClassList?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (serverOnlyClassMap != null)
        'serverOnlyClassMap': serverOnlyClassMap?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {'__className__': 'ServerOnlyClassField'};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServerOnlyClassFieldImpl extends ServerOnlyClassField {
  _ServerOnlyClassFieldImpl({
    List<_i2.ServerOnlyClass>? serverOnlyClassList,
    Map<String, _i2.ServerOnlyClass>? serverOnlyClassMap,
  }) : super._(
         serverOnlyClassList: serverOnlyClassList,
         serverOnlyClassMap: serverOnlyClassMap,
       );

  /// Returns a shallow copy of this [ServerOnlyClassField]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ServerOnlyClassField copyWith({
    Object? serverOnlyClassList = _Undefined,
    Object? serverOnlyClassMap = _Undefined,
  }) {
    return ServerOnlyClassField(
      serverOnlyClassList: serverOnlyClassList is List<_i2.ServerOnlyClass>?
          ? serverOnlyClassList
          : this.serverOnlyClassList?.map((e0) => e0.copyWith()).toList(),
      serverOnlyClassMap:
          serverOnlyClassMap is Map<String, _i2.ServerOnlyClass>?
          ? serverOnlyClassMap
          : this.serverOnlyClassMap?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0.copyWith(),
              ),
            ),
    );
  }
}
