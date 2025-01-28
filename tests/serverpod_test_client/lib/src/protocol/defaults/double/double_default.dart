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

abstract class DoubleDefault implements _i1.SerializableModel {
  DoubleDefault._({
    this.id,
    double? doubleDefault,
    double? doubleDefaultNull,
  })  : doubleDefault = doubleDefault ?? 10.5,
        doubleDefaultNull = doubleDefaultNull ?? 20.5;

  factory DoubleDefault({
    int? id,
    double? doubleDefault,
    double? doubleDefaultNull,
  }) = _DoubleDefaultImpl;

  factory DoubleDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoubleDefault(
      id: jsonSerialization['id'] as int?,
      doubleDefault: (jsonSerialization['doubleDefault'] as num).toDouble(),
      doubleDefaultNull:
          (jsonSerialization['doubleDefaultNull'] as num?)?.toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  double doubleDefault;

  double? doubleDefaultNull;

  /// Returns a shallow copy of this [DoubleDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DoubleDefault copyWith({
    int? id,
    double? doubleDefault,
    double? doubleDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'doubleDefault': doubleDefault,
      if (doubleDefaultNull != null) 'doubleDefaultNull': doubleDefaultNull,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoubleDefaultImpl extends DoubleDefault {
  _DoubleDefaultImpl({
    int? id,
    double? doubleDefault,
    double? doubleDefaultNull,
  }) : super._(
          id: id,
          doubleDefault: doubleDefault,
          doubleDefaultNull: doubleDefaultNull,
        );

  /// Returns a shallow copy of this [DoubleDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DoubleDefault copyWith({
    Object? id = _Undefined,
    double? doubleDefault,
    Object? doubleDefaultNull = _Undefined,
  }) {
    return DoubleDefault(
      id: id is int? ? id : this.id,
      doubleDefault: doubleDefault ?? this.doubleDefault,
      doubleDefaultNull: doubleDefaultNull is double?
          ? doubleDefaultNull
          : this.doubleDefaultNull,
    );
  }
}
