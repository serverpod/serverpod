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

abstract class DoubleDefaultMix implements _i1.SerializableModel {
  DoubleDefaultMix._({
    this.id,
    double? doubleDefaultAndDefaultModel,
    double? doubleDefaultAndDefaultPersist,
    double? doubleDefaultModelAndDefaultPersist,
  })  : doubleDefaultAndDefaultModel = doubleDefaultAndDefaultModel ?? 20.5,
        doubleDefaultAndDefaultPersist = doubleDefaultAndDefaultPersist ?? 10.5,
        doubleDefaultModelAndDefaultPersist =
            doubleDefaultModelAndDefaultPersist ?? 10.5;

  factory DoubleDefaultMix({
    int? id,
    double? doubleDefaultAndDefaultModel,
    double? doubleDefaultAndDefaultPersist,
    double? doubleDefaultModelAndDefaultPersist,
  }) = _DoubleDefaultMixImpl;

  factory DoubleDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoubleDefaultMix(
      id: jsonSerialization['id'] as int?,
      doubleDefaultAndDefaultModel:
          (jsonSerialization['doubleDefaultAndDefaultModel'] as num).toDouble(),
      doubleDefaultAndDefaultPersist:
          (jsonSerialization['doubleDefaultAndDefaultPersist'] as num)
              .toDouble(),
      doubleDefaultModelAndDefaultPersist:
          (jsonSerialization['doubleDefaultModelAndDefaultPersist'] as num)
              .toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  double doubleDefaultAndDefaultModel;

  double doubleDefaultAndDefaultPersist;

  double doubleDefaultModelAndDefaultPersist;

  /// Returns a shallow copy of this [DoubleDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DoubleDefaultMix copyWith({
    int? id,
    double? doubleDefaultAndDefaultModel,
    double? doubleDefaultAndDefaultPersist,
    double? doubleDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'doubleDefaultAndDefaultModel': doubleDefaultAndDefaultModel,
      'doubleDefaultAndDefaultPersist': doubleDefaultAndDefaultPersist,
      'doubleDefaultModelAndDefaultPersist':
          doubleDefaultModelAndDefaultPersist,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoubleDefaultMixImpl extends DoubleDefaultMix {
  _DoubleDefaultMixImpl({
    int? id,
    double? doubleDefaultAndDefaultModel,
    double? doubleDefaultAndDefaultPersist,
    double? doubleDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          doubleDefaultAndDefaultModel: doubleDefaultAndDefaultModel,
          doubleDefaultAndDefaultPersist: doubleDefaultAndDefaultPersist,
          doubleDefaultModelAndDefaultPersist:
              doubleDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [DoubleDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DoubleDefaultMix copyWith({
    Object? id = _Undefined,
    double? doubleDefaultAndDefaultModel,
    double? doubleDefaultAndDefaultPersist,
    double? doubleDefaultModelAndDefaultPersist,
  }) {
    return DoubleDefaultMix(
      id: id is int? ? id : this.id,
      doubleDefaultAndDefaultModel:
          doubleDefaultAndDefaultModel ?? this.doubleDefaultAndDefaultModel,
      doubleDefaultAndDefaultPersist:
          doubleDefaultAndDefaultPersist ?? this.doubleDefaultAndDefaultPersist,
      doubleDefaultModelAndDefaultPersist:
          doubleDefaultModelAndDefaultPersist ??
              this.doubleDefaultModelAndDefaultPersist,
    );
  }
}
