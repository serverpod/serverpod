/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class BoolDefault implements _i1.SerializableModel {
  BoolDefault._({
    this.id,
    bool? boolDefaultTrue,
    bool? boolDefaultFalse,
    bool? boolDefaultNullFalse,
  })  : boolDefaultTrue = boolDefaultTrue ?? true,
        boolDefaultFalse = boolDefaultFalse ?? false,
        boolDefaultNullFalse = boolDefaultNullFalse ?? false;

  factory BoolDefault({
    int? id,
    bool? boolDefaultTrue,
    bool? boolDefaultFalse,
    bool? boolDefaultNullFalse,
  }) = _BoolDefaultImpl;

  factory BoolDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoolDefault(
      id: jsonSerialization['id'] as int?,
      boolDefaultTrue: jsonSerialization['boolDefaultTrue'] as bool,
      boolDefaultFalse: jsonSerialization['boolDefaultFalse'] as bool,
      boolDefaultNullFalse: jsonSerialization['boolDefaultNullFalse'] as bool?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  bool boolDefaultTrue;

  bool boolDefaultFalse;

  bool? boolDefaultNullFalse;

  /// Returns a shallow copy of this [BoolDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoolDefault copyWith({
    int? id,
    bool? boolDefaultTrue,
    bool? boolDefaultFalse,
    bool? boolDefaultNullFalse,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'boolDefaultTrue': boolDefaultTrue,
      'boolDefaultFalse': boolDefaultFalse,
      if (boolDefaultNullFalse != null)
        'boolDefaultNullFalse': boolDefaultNullFalse,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoolDefaultImpl extends BoolDefault {
  _BoolDefaultImpl({
    int? id,
    bool? boolDefaultTrue,
    bool? boolDefaultFalse,
    bool? boolDefaultNullFalse,
  }) : super._(
          id: id,
          boolDefaultTrue: boolDefaultTrue,
          boolDefaultFalse: boolDefaultFalse,
          boolDefaultNullFalse: boolDefaultNullFalse,
        );

  /// Returns a shallow copy of this [BoolDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoolDefault copyWith({
    Object? id = _Undefined,
    bool? boolDefaultTrue,
    bool? boolDefaultFalse,
    Object? boolDefaultNullFalse = _Undefined,
  }) {
    return BoolDefault(
      id: id is int? ? id : this.id,
      boolDefaultTrue: boolDefaultTrue ?? this.boolDefaultTrue,
      boolDefaultFalse: boolDefaultFalse ?? this.boolDefaultFalse,
      boolDefaultNullFalse: boolDefaultNullFalse is bool?
          ? boolDefaultNullFalse
          : this.boolDefaultNullFalse,
    );
  }
}
