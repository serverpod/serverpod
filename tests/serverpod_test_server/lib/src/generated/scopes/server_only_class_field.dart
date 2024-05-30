/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

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
      Map<String, dynamic> jsonSerialization) {
    return ServerOnlyClassField(
      serverOnlyClassList: (jsonSerialization['serverOnlyClassList'] as List?)
          ?.map(
              (e) => _i2.ServerOnlyClass.fromJson((e as Map<String, dynamic>)))
          .toList(),
      serverOnlyClassMap: (jsonSerialization['serverOnlyClassMap'] as Map?)
          ?.map((k, v) => MapEntry(
                k as String,
                _i2.ServerOnlyClass.fromJson((v as Map<String, dynamic>)),
              )),
    );
  }

  List<_i2.ServerOnlyClass>? serverOnlyClassList;

  Map<String, _i2.ServerOnlyClass>? serverOnlyClassMap;

  ServerOnlyClassField copyWith({
    List<_i2.ServerOnlyClass>? serverOnlyClassList,
    Map<String, _i2.ServerOnlyClass>? serverOnlyClassMap,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (serverOnlyClassList != null)
        'serverOnlyClassList':
            serverOnlyClassList?.toJson(valueToJson: (v) => v.toJson()),
      if (serverOnlyClassMap != null)
        'serverOnlyClassMap':
            serverOnlyClassMap?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
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

  @override
  ServerOnlyClassField copyWith({
    Object? serverOnlyClassList = _Undefined,
    Object? serverOnlyClassMap = _Undefined,
  }) {
    return ServerOnlyClassField(
      serverOnlyClassList: serverOnlyClassList is List<_i2.ServerOnlyClass>?
          ? serverOnlyClassList
          : this.serverOnlyClassList?.clone(),
      serverOnlyClassMap:
          serverOnlyClassMap is Map<String, _i2.ServerOnlyClass>?
              ? serverOnlyClassMap
              : this.serverOnlyClassMap?.clone(),
    );
  }
}
