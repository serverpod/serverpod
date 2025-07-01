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

abstract class BoolDefaultModel implements _i1.SerializableModel {
  BoolDefaultModel._({
    this.id,
    bool? boolDefaultModelTrue,
    bool? boolDefaultModelFalse,
    bool? boolDefaultModelNullFalse,
  })  : boolDefaultModelTrue = boolDefaultModelTrue ?? true,
        boolDefaultModelFalse = boolDefaultModelFalse ?? false,
        boolDefaultModelNullFalse = boolDefaultModelNullFalse ?? false;

  factory BoolDefaultModel({
    int? id,
    bool? boolDefaultModelTrue,
    bool? boolDefaultModelFalse,
    bool? boolDefaultModelNullFalse,
  }) = _BoolDefaultModelImpl;

  factory BoolDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoolDefaultModel(
      id: jsonSerialization['id'] as int?,
      boolDefaultModelTrue: jsonSerialization['boolDefaultModelTrue'] as bool,
      boolDefaultModelFalse: jsonSerialization['boolDefaultModelFalse'] as bool,
      boolDefaultModelNullFalse:
          jsonSerialization['boolDefaultModelNullFalse'] as bool,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  bool boolDefaultModelTrue;

  bool boolDefaultModelFalse;

  bool boolDefaultModelNullFalse;

  /// Returns a shallow copy of this [BoolDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoolDefaultModel copyWith({
    int? id,
    bool? boolDefaultModelTrue,
    bool? boolDefaultModelFalse,
    bool? boolDefaultModelNullFalse,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'boolDefaultModelTrue': boolDefaultModelTrue,
      'boolDefaultModelFalse': boolDefaultModelFalse,
      'boolDefaultModelNullFalse': boolDefaultModelNullFalse,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoolDefaultModelImpl extends BoolDefaultModel {
  _BoolDefaultModelImpl({
    int? id,
    bool? boolDefaultModelTrue,
    bool? boolDefaultModelFalse,
    bool? boolDefaultModelNullFalse,
  }) : super._(
          id: id,
          boolDefaultModelTrue: boolDefaultModelTrue,
          boolDefaultModelFalse: boolDefaultModelFalse,
          boolDefaultModelNullFalse: boolDefaultModelNullFalse,
        );

  /// Returns a shallow copy of this [BoolDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoolDefaultModel copyWith({
    Object? id = _Undefined,
    bool? boolDefaultModelTrue,
    bool? boolDefaultModelFalse,
    bool? boolDefaultModelNullFalse,
  }) {
    return BoolDefaultModel(
      id: id is int? ? id : this.id,
      boolDefaultModelTrue: boolDefaultModelTrue ?? this.boolDefaultModelTrue,
      boolDefaultModelFalse:
          boolDefaultModelFalse ?? this.boolDefaultModelFalse,
      boolDefaultModelNullFalse:
          boolDefaultModelNullFalse ?? this.boolDefaultModelNullFalse,
    );
  }
}
