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
import '../scopes/scope_server_only_field.dart' as _ijcqyoxk;
import '../types.dart' as _ih2vh47j;

class ScopeServerOnlyField
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ScopeServerOnlyField({
    this.allScope,
    this.nested,
  });

  factory ScopeServerOnlyField.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ScopeServerOnlyField(
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
    );
  }

  _ih2vh47j.Types? allScope;

  _ijcqyoxk.ScopeServerOnlyField? nested;

  /// Returns a shallow copy of this [ScopeServerOnlyField]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ScopeServerOnlyField copyWith({
    Object? allScope = _Undefined,
    Object? nested = _Undefined,
  }) {
    return ScopeServerOnlyField(
      allScope: allScope is _ih2vh47j.Types?
          ? allScope
          : this.allScope?.copyWith(),
      nested: nested is _ijcqyoxk.ScopeServerOnlyField?
          ? nested
          : this.nested?.copyWith(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScopeServerOnlyField',
      if (allScope != null) 'allScope': allScope?.toJson(),
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
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}
