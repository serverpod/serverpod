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

abstract class IntDefault implements _i1.SerializableModel {
  IntDefault._({
    this.id,
    int? intDefault,
    int? intDefaultNull,
  })  : intDefault = intDefault ?? 10,
        intDefaultNull = intDefaultNull ?? 20;

  factory IntDefault({
    int? id,
    int? intDefault,
    int? intDefaultNull,
  }) = _IntDefaultImpl;

  factory IntDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return IntDefault(
      id: jsonSerialization['id'] as int?,
      intDefault: jsonSerialization['intDefault'] as int,
      intDefaultNull: jsonSerialization['intDefaultNull'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int intDefault;

  int? intDefaultNull;

  /// Returns a shallow copy of this [IntDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IntDefault copyWith({
    int? id,
    int? intDefault,
    int? intDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'intDefault': intDefault,
      if (intDefaultNull != null) 'intDefaultNull': intDefaultNull,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IntDefaultImpl extends IntDefault {
  _IntDefaultImpl({
    int? id,
    int? intDefault,
    int? intDefaultNull,
  }) : super._(
          id: id,
          intDefault: intDefault,
          intDefaultNull: intDefaultNull,
        );

  /// Returns a shallow copy of this [IntDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IntDefault copyWith({
    Object? id = _Undefined,
    int? intDefault,
    Object? intDefaultNull = _Undefined,
  }) {
    return IntDefault(
      id: id is int? ? id : this.id,
      intDefault: intDefault ?? this.intDefault,
      intDefaultNull:
          intDefaultNull is int? ? intDefaultNull : this.intDefaultNull,
    );
  }
}
