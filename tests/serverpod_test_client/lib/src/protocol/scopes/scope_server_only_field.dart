/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

abstract class ScopeServerOnlyField implements _i1.SerializableModel {
  ScopeServerOnlyField._({
    this.allScope,
    this.nested,
  });

  factory ScopeServerOnlyField({
    _i2.Types? allScope,
    _i2.ScopeServerOnlyField? nested,
  }) = _ScopeServerOnlyFieldImpl;

  factory ScopeServerOnlyField.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ScopeServerOnlyField(
      allScope: jsonSerialization['allScope'] == null
          ? null
          : _i2.Types.fromJson(
              (jsonSerialization['allScope'] as Map<String, dynamic>)),
      nested: jsonSerialization['nested'] == null
          ? null
          : _i2.ScopeServerOnlyField.fromJson(
              (jsonSerialization['nested'] as Map<String, dynamic>)),
    );
  }

  _i2.Types? allScope;

  _i2.ScopeServerOnlyField? nested;

  ScopeServerOnlyField copyWith({
    _i2.Types? allScope,
    _i2.ScopeServerOnlyField? nested,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (allScope != null) 'allScope': allScope?.toJson(),
      if (nested != null) 'nested': nested?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScopeServerOnlyFieldImpl extends ScopeServerOnlyField {
  _ScopeServerOnlyFieldImpl({
    _i2.Types? allScope,
    _i2.ScopeServerOnlyField? nested,
  }) : super._(
          allScope: allScope,
          nested: nested,
        );

  @override
  ScopeServerOnlyField copyWith({
    Object? allScope = _Undefined,
    Object? nested = _Undefined,
  }) {
    return ScopeServerOnlyField(
      allScope: allScope is _i2.Types? ? allScope : this.allScope?.copyWith(),
      nested: nested is _i2.ScopeServerOnlyField?
          ? nested
          : this.nested?.copyWith(),
    );
  }
}
