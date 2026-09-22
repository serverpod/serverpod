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
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import '../scopes/scope_server_only_field.dart' as _ijcqyoxk;
import '../types.dart' as _ih2vh47j;

class ScopeServerOnlyField
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ScopeServerOnlyField({
    this.allScope,
    this.serverOnlyScope,
    this.nested,
  });

  factory ScopeServerOnlyField.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ScopeServerOnlyField(
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
    );
  }

  _ih2vh47j.Types? allScope;

  _ih2vh47j.Types? serverOnlyScope;

  _ijcqyoxk.ScopeServerOnlyField? nested;

  /// Returns a shallow copy of this [ScopeServerOnlyField]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ScopeServerOnlyField copyWith({
    _ih2vh47j.Types? allScope = const _UndefinedScopeServerOnlyField$allScope(),
    _ih2vh47j.Types? serverOnlyScope =
        const _UndefinedScopeServerOnlyField$serverOnlyScope(),
    _ijcqyoxk.ScopeServerOnlyField? nested =
        const _UndefinedScopeServerOnlyField$nested(),
  }) {
    return ScopeServerOnlyField(
      allScope: allScope is _is.UndefinedSentinel
          ? this.allScope?.copyWith()
          : allScope,
      serverOnlyScope: serverOnlyScope is _is.UndefinedSentinel
          ? this.serverOnlyScope?.copyWith()
          : serverOnlyScope,
      nested: nested is _is.UndefinedSentinel
          ? this.nested?.copyWith()
          : nested,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScopeServerOnlyField',
      if (allScope != null) 'allScope': allScope?.toJson(),
      if (serverOnlyScope != null) 'serverOnlyScope': serverOnlyScope?.toJson(),
      if (nested != null) 'nested': nested?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScopeServerOnlyField',
      if (allScope != null) 'allScope': allScope?.toJsonForProtocol(),
      if (nested != null) 'nested': nested?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _UndefinedScopeServerOnlyField$allScope extends _is.UndefinedSentinel
    implements _ih2vh47j.Types {
  const _UndefinedScopeServerOnlyField$allScope();
}

class _UndefinedScopeServerOnlyField$serverOnlyScope
    extends _is.UndefinedSentinel
    implements _ih2vh47j.Types {
  const _UndefinedScopeServerOnlyField$serverOnlyScope();
}

class _UndefinedScopeServerOnlyField$nested extends _is.UndefinedSentinel
    implements _ijcqyoxk.ScopeServerOnlyField {
  const _UndefinedScopeServerOnlyField$nested();
}
