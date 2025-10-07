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
import '../protocol.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;

abstract class ServerOnlyChildClassWithoutId extends _i1.ParentClassWithoutId
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  ServerOnlyChildClassWithoutId._({
    super.id,
    required super.grandParentField,
    required super.parentField,
    required this.childField,
  });

  factory ServerOnlyChildClassWithoutId({
    _i2.UuidValue? id,
    required String grandParentField,
    required String parentField,
    required String childField,
  }) = _ServerOnlyChildClassWithoutIdImpl;

  factory ServerOnlyChildClassWithoutId.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ServerOnlyChildClassWithoutId(
      id: jsonSerialization['id'] == null
          ? null
          : _i2.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      grandParentField: jsonSerialization['grandParentField'] as String,
      parentField: jsonSerialization['parentField'] as String,
      childField: jsonSerialization['childField'] as String,
    );
  }

  String childField;

  /// Returns a shallow copy of this [ServerOnlyChildClassWithoutId]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  ServerOnlyChildClassWithoutId copyWith({
    Object? id,
    String? grandParentField,
    String? parentField,
    String? childField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'grandParentField': grandParentField,
      'parentField': parentField,
      'childField': childField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServerOnlyChildClassWithoutIdImpl extends ServerOnlyChildClassWithoutId {
  _ServerOnlyChildClassWithoutIdImpl({
    _i2.UuidValue? id,
    required String grandParentField,
    required String parentField,
    required String childField,
  }) : super._(
          id: id,
          grandParentField: grandParentField,
          parentField: parentField,
          childField: childField,
        );

  /// Returns a shallow copy of this [ServerOnlyChildClassWithoutId]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  ServerOnlyChildClassWithoutId copyWith({
    Object? id = _Undefined,
    String? grandParentField,
    String? parentField,
    String? childField,
  }) {
    return ServerOnlyChildClassWithoutId(
      id: id is _i2.UuidValue? ? id : this.id,
      grandParentField: grandParentField ?? this.grandParentField,
      parentField: parentField ?? this.parentField,
      childField: childField ?? this.childField,
    );
  }
}
