/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: depend_on_referenced_packages

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_serialization/undefined_sentinel.dart' as _issu;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import '../protocol.dart' as _iv35mfmj;
import '../scopes/scope_server_only_field.dart' as _ijcqyoxk;
import '../types.dart' as _ih2vh47j;

abstract class ScopeServerOnlyFieldChild extends _iv35mfmj.ScopeServerOnlyField
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ScopeServerOnlyFieldChild._({
    super.allScope,
    super.serverOnlyScope,
    super.nested,
    required this.childFoo,
  });

  factory ScopeServerOnlyFieldChild({
    _ih2vh47j.Types? allScope,
    _ih2vh47j.Types? serverOnlyScope,
    _ijcqyoxk.ScopeServerOnlyField? nested,
    required String childFoo,
  }) = _ScopeServerOnlyFieldChildImpl;

  factory ScopeServerOnlyFieldChild.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ScopeServerOnlyFieldChild(
      allScope: jsonSerialization['allScope'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_ih2vh47j.Types>(
              jsonSerialization['allScope'],
            ),
      serverOnlyScope: jsonSerialization['serverOnlyScope'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_ih2vh47j.Types>(
              jsonSerialization['serverOnlyScope'],
            ),
      nested: jsonSerialization['nested'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_ijcqyoxk.ScopeServerOnlyField>(
              jsonSerialization['nested'],
            ),
      childFoo: jsonSerialization['childFoo'] as String,
    );
  }

  String childFoo;

  /// Returns a shallow copy of this [ScopeServerOnlyFieldChild]
  /// with some or all fields replaced by the given arguments.
  @override
  @_is.useResult
  ScopeServerOnlyFieldChild copyWith({
    _ih2vh47j.Types? allScope =
        const _UndefinedScopeServerOnlyFieldChild$allScope(),
    _ih2vh47j.Types? serverOnlyScope =
        const _UndefinedScopeServerOnlyFieldChild$allScope(),
    _ijcqyoxk.ScopeServerOnlyField? nested =
        const _UndefinedScopeServerOnlyFieldChild$nested(),
    String? childFoo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScopeServerOnlyFieldChild',
      if (allScope != null) 'allScope': allScope?.toJson(),
      if (serverOnlyScope != null) 'serverOnlyScope': serverOnlyScope?.toJson(),
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
    return _is.SerializationManager.encode(this);
  }
}

class _UndefinedScopeServerOnlyFieldChild$allScope
    extends _issu.UndefinedSentinel
    implements _ih2vh47j.Types {
  const _UndefinedScopeServerOnlyFieldChild$allScope();
}

class _UndefinedScopeServerOnlyFieldChild$nested extends _issu.UndefinedSentinel
    implements _ijcqyoxk.ScopeServerOnlyField {
  const _UndefinedScopeServerOnlyFieldChild$nested();
}

class _ScopeServerOnlyFieldChildImpl extends ScopeServerOnlyFieldChild {
  _ScopeServerOnlyFieldChildImpl({
    _ih2vh47j.Types? allScope,
    _ih2vh47j.Types? serverOnlyScope,
    _ijcqyoxk.ScopeServerOnlyField? nested,
    required String childFoo,
  }) : super._(
         allScope: allScope,
         serverOnlyScope: serverOnlyScope,
         nested: nested,
         childFoo: childFoo,
       );

  /// Returns a shallow copy of this [ScopeServerOnlyFieldChild]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ScopeServerOnlyFieldChild copyWith({
    _ih2vh47j.Types? allScope =
        const _UndefinedScopeServerOnlyFieldChild$allScope(),
    _ih2vh47j.Types? serverOnlyScope =
        const _UndefinedScopeServerOnlyFieldChild$allScope(),
    _ijcqyoxk.ScopeServerOnlyField? nested =
        const _UndefinedScopeServerOnlyFieldChild$nested(),
    String? childFoo,
  }) {
    return ScopeServerOnlyFieldChild(
      allScope: allScope is _issu.UndefinedSentinel
          ? this.allScope?.copyWith()
          : allScope,
      serverOnlyScope: serverOnlyScope is _issu.UndefinedSentinel
          ? this.serverOnlyScope?.copyWith()
          : serverOnlyScope,
      nested: nested is _issu.UndefinedSentinel
          ? this.nested?.copyWith()
          : nested,
      childFoo: childFoo ?? this.childFoo,
    );
  }
}
