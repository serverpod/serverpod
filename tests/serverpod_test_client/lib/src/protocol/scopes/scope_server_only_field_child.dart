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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import '../protocol.dart' as _iv35mfmj;
import '../scopes/scope_server_only_field.dart' as _ijcqyoxk;
import '../types.dart' as _ih2vh47j;

abstract class ScopeServerOnlyFieldChild extends _iv35mfmj.ScopeServerOnlyField
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ScopeServerOnlyFieldChild._({
    super.allScope,
    super.nested,
    required this.childFoo,
  });

  factory ScopeServerOnlyFieldChild({
    _ih2vh47j.Types? allScope,
    _ijcqyoxk.ScopeServerOnlyField? nested,
    required String childFoo,
  }) = _ScopeServerOnlyFieldChildImpl;

  factory ScopeServerOnlyFieldChild.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ScopeServerOnlyFieldChild(
      allScope: jsonSerialization['allScope'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_ih2vh47j.Types>(
              jsonSerialization['allScope'],
            ),
      nested: jsonSerialization['nested'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_ijcqyoxk.ScopeServerOnlyField>(
              jsonSerialization['nested'],
            ),
      childFoo: jsonSerialization['childFoo'] as String,
    );
  }

  String childFoo;

  /// Returns a shallow copy of this [ScopeServerOnlyFieldChild]
  /// with some or all fields replaced by the given arguments.
  @override
  @_isc.useResult
  ScopeServerOnlyFieldChild copyWith({
    Object? allScope,
    Object? nested,
    String? childFoo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScopeServerOnlyFieldChild',
      if (allScope != null) 'allScope': allScope?.toJson(),
      if (nested != null) 'nested': nested?.toJson(),
      'childFoo': childFoo,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScopeServerOnlyFieldChild',
      if (allScope != null) 'allScope': allScope?.toJsonForProtocol(),
      if (nested != null) 'nested': nested?.toJsonForProtocol(),
      'childFoo': childFoo,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScopeServerOnlyFieldChildImpl extends ScopeServerOnlyFieldChild {
  _ScopeServerOnlyFieldChildImpl({
    _ih2vh47j.Types? allScope,
    _ijcqyoxk.ScopeServerOnlyField? nested,
    required String childFoo,
  }) : super._(
         allScope: allScope,
         nested: nested,
         childFoo: childFoo,
       );

  /// Returns a shallow copy of this [ScopeServerOnlyFieldChild]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ScopeServerOnlyFieldChild copyWith({
    Object? allScope = _Undefined,
    Object? nested = _Undefined,
    String? childFoo,
  }) {
    return ScopeServerOnlyFieldChild(
      allScope: allScope is _ih2vh47j.Types?
          ? allScope
          : this.allScope?.copyWith(),
      nested: nested is _ijcqyoxk.ScopeServerOnlyField?
          ? nested
          : this.nested?.copyWith(),
      childFoo: childFoo ?? this.childFoo,
    );
  }
}
