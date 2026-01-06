/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: deprecated_member_use_from_same_package

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i2;
import '../types.dart' as _i3;
import '../scopes/scope_server_only_field.dart' as _i4;

class ScopeServerOnlyField
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
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
          : _i2.Protocol().deserialize<_i3.Types>(
              jsonSerialization['allScope'],
            ),
      serverOnlyScope: jsonSerialization['serverOnlyScope'] == null
          ? null
          : _i2.Protocol().deserialize<_i3.Types>(
              jsonSerialization['serverOnlyScope'],
            ),
      nested: jsonSerialization['nested'] == null
          ? null
          : _i2.Protocol().deserialize<_i4.ScopeServerOnlyField>(
              jsonSerialization['nested'],
            ),
    );
  }

  _i3.Types? allScope;

  _i3.Types? serverOnlyScope;

  _i4.ScopeServerOnlyField? nested;

  /// Returns a shallow copy of this [ScopeServerOnlyField]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScopeServerOnlyField copyWith({
    Object? allScope = _Undefined,
    Object? serverOnlyScope = _Undefined,
    Object? nested = _Undefined,
  }) {
    return ScopeServerOnlyField(
      allScope: allScope is _i3.Types? ? allScope : this.allScope?.copyWith(),
      serverOnlyScope: serverOnlyScope is _i3.Types?
          ? serverOnlyScope
          : this.serverOnlyScope?.copyWith(),
      nested: nested is _i4.ScopeServerOnlyField?
          ? nested
          : this.nested?.copyWith(),
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
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}
