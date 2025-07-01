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

abstract class DoubleDefaultModel implements _i1.SerializableModel {
  DoubleDefaultModel._({
    this.id,
    double? doubleDefaultModel,
    double? doubleDefaultModelNull,
  })  : doubleDefaultModel = doubleDefaultModel ?? 10.5,
        doubleDefaultModelNull = doubleDefaultModelNull ?? 20.5;

  factory DoubleDefaultModel({
    int? id,
    double? doubleDefaultModel,
    double? doubleDefaultModelNull,
  }) = _DoubleDefaultModelImpl;

  factory DoubleDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoubleDefaultModel(
      id: jsonSerialization['id'] as int?,
      doubleDefaultModel:
          (jsonSerialization['doubleDefaultModel'] as num).toDouble(),
      doubleDefaultModelNull:
          (jsonSerialization['doubleDefaultModelNull'] as num).toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  double doubleDefaultModel;

  double doubleDefaultModelNull;

  /// Returns a shallow copy of this [DoubleDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DoubleDefaultModel copyWith({
    int? id,
    double? doubleDefaultModel,
    double? doubleDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'doubleDefaultModel': doubleDefaultModel,
      'doubleDefaultModelNull': doubleDefaultModelNull,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoubleDefaultModelImpl extends DoubleDefaultModel {
  _DoubleDefaultModelImpl({
    int? id,
    double? doubleDefaultModel,
    double? doubleDefaultModelNull,
  }) : super._(
          id: id,
          doubleDefaultModel: doubleDefaultModel,
          doubleDefaultModelNull: doubleDefaultModelNull,
        );

  /// Returns a shallow copy of this [DoubleDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DoubleDefaultModel copyWith({
    Object? id = _Undefined,
    double? doubleDefaultModel,
    double? doubleDefaultModelNull,
  }) {
    return DoubleDefaultModel(
      id: id is int? ? id : this.id,
      doubleDefaultModel: doubleDefaultModel ?? this.doubleDefaultModel,
      doubleDefaultModelNull:
          doubleDefaultModelNull ?? this.doubleDefaultModelNull,
    );
  }
}
