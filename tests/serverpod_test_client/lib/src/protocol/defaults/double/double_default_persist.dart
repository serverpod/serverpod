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

abstract class DoubleDefaultPersist implements _i1.SerializableModel {
  DoubleDefaultPersist._({
    this.id,
    this.doubleDefaultPersist,
  });

  factory DoubleDefaultPersist({
    int? id,
    double? doubleDefaultPersist,
  }) = _DoubleDefaultPersistImpl;

  factory DoubleDefaultPersist.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return DoubleDefaultPersist(
      id: jsonSerialization['id'] as int?,
      doubleDefaultPersist:
          (jsonSerialization['doubleDefaultPersist'] as num?)?.toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  double? doubleDefaultPersist;

  /// Returns a shallow copy of this [DoubleDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DoubleDefaultPersist copyWith({
    int? id,
    double? doubleDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (doubleDefaultPersist != null)
        'doubleDefaultPersist': doubleDefaultPersist,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoubleDefaultPersistImpl extends DoubleDefaultPersist {
  _DoubleDefaultPersistImpl({
    int? id,
    double? doubleDefaultPersist,
  }) : super._(
          id: id,
          doubleDefaultPersist: doubleDefaultPersist,
        );

  /// Returns a shallow copy of this [DoubleDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DoubleDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? doubleDefaultPersist = _Undefined,
  }) {
    return DoubleDefaultPersist(
      id: id is int? ? id : this.id,
      doubleDefaultPersist: doubleDefaultPersist is double?
          ? doubleDefaultPersist
          : this.doubleDefaultPersist,
    );
  }
}
