/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../protocol.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;
import '../types.dart' as _i3;
import '../scopes/scope_server_only_field.dart' as _i4;

abstract class ScopeServerOnlyFieldChild extends _i1.ScopeServerOnlyField
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  ScopeServerOnlyFieldChild._({
    super.allScope,
    super.serverOnlyScope,
    super.nested,
    required this.childFoo,
  });

  factory ScopeServerOnlyFieldChild({
    _i3.Types? allScope,
    _i3.Types? serverOnlyScope,
    _i4.ScopeServerOnlyField? nested,
    required String childFoo,
  }) = _ScopeServerOnlyFieldChildImpl;

  factory ScopeServerOnlyFieldChild.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ScopeServerOnlyFieldChild(
      allScope: jsonSerialization['allScope'] == null
          ? null
          : _i3.Types.fromJson(
              (jsonSerialization['allScope'] as Map<String, dynamic>)),
      serverOnlyScope: jsonSerialization['serverOnlyScope'] == null
          ? null
          : _i3.Types.fromJson(
              (jsonSerialization['serverOnlyScope'] as Map<String, dynamic>)),
      nested: jsonSerialization['nested'] == null
          ? null
          : _i4.ScopeServerOnlyField.fromJson(
              (jsonSerialization['nested'] as Map<String, dynamic>)),
      childFoo: jsonSerialization['childFoo'] as String,
    );
  }

  String childFoo;

  /// Returns a shallow copy of this [ScopeServerOnlyFieldChild]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  ScopeServerOnlyFieldChild copyWith({
    Object? allScope,
    Object? serverOnlyScope,
    Object? nested,
    String? childFoo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (allScope != null) 'allScope': allScope?.toJson(),
      if (serverOnlyScope != null) 'serverOnlyScope': serverOnlyScope?.toJson(),
      if (nested != null) 'nested': nested?.toJson(),
      'childFoo': childFoo,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (allScope != null) 'allScope': allScope?.toJsonForProtocol(),
      if (nested != null) 'nested': nested?.toJsonForProtocol(),
      'childFoo': childFoo,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScopeServerOnlyFieldChildImpl extends ScopeServerOnlyFieldChild {
  _ScopeServerOnlyFieldChildImpl({
    _i3.Types? allScope,
    _i3.Types? serverOnlyScope,
    _i4.ScopeServerOnlyField? nested,
    required String childFoo,
  }) : super._(
          allScope: allScope,
          serverOnlyScope: serverOnlyScope,
          nested: nested,
          childFoo: childFoo,
        );

  /// Returns a shallow copy of this [ScopeServerOnlyFieldChild]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  ScopeServerOnlyFieldChild copyWith({
    Object? allScope = _Undefined,
    Object? serverOnlyScope = _Undefined,
    Object? nested = _Undefined,
    String? childFoo,
  }) {
    return ScopeServerOnlyFieldChild(
      allScope: allScope is _i3.Types? ? allScope : this.allScope?.copyWith(),
      serverOnlyScope: serverOnlyScope is _i3.Types?
          ? serverOnlyScope
          : this.serverOnlyScope?.copyWith(),
      nested: nested is _i4.ScopeServerOnlyField?
          ? nested
          : this.nested?.copyWith(),
      childFoo: childFoo ?? this.childFoo,
    );
  }
}
