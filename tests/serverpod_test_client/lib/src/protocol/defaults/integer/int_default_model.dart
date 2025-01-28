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

abstract class IntDefaultModel implements _i1.SerializableModel {
  IntDefaultModel._({
    this.id,
    int? intDefaultModel,
    int? intDefaultModelNull,
  })  : intDefaultModel = intDefaultModel ?? 10,
        intDefaultModelNull = intDefaultModelNull ?? 20;

  factory IntDefaultModel({
    int? id,
    int? intDefaultModel,
    int? intDefaultModelNull,
  }) = _IntDefaultModelImpl;

  factory IntDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return IntDefaultModel(
      id: jsonSerialization['id'] as int?,
      intDefaultModel: jsonSerialization['intDefaultModel'] as int,
      intDefaultModelNull: jsonSerialization['intDefaultModelNull'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int intDefaultModel;

  int intDefaultModelNull;

  /// Returns a shallow copy of this [IntDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IntDefaultModel copyWith({
    int? id,
    int? intDefaultModel,
    int? intDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'intDefaultModel': intDefaultModel,
      'intDefaultModelNull': intDefaultModelNull,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IntDefaultModelImpl extends IntDefaultModel {
  _IntDefaultModelImpl({
    int? id,
    int? intDefaultModel,
    int? intDefaultModelNull,
  }) : super._(
          id: id,
          intDefaultModel: intDefaultModel,
          intDefaultModelNull: intDefaultModelNull,
        );

  /// Returns a shallow copy of this [IntDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IntDefaultModel copyWith({
    Object? id = _Undefined,
    int? intDefaultModel,
    int? intDefaultModelNull,
  }) {
    return IntDefaultModel(
      id: id is int? ? id : this.id,
      intDefaultModel: intDefaultModel ?? this.intDefaultModel,
      intDefaultModelNull: intDefaultModelNull ?? this.intDefaultModelNull,
    );
  }
}
