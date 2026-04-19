/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class DecimalDefaultMix implements _i1.SerializableModel {
  DecimalDefaultMix._({
    this.id,
    _i1.Decimal? decimalDefaultAndDefaultModel,
    _i1.Decimal? decimalDefaultAndDefaultPersist,
    _i1.Decimal? decimalDefaultModelAndDefaultPersist,
  }) : decimalDefaultAndDefaultModel =
           decimalDefaultAndDefaultModel ?? _i1.Decimal.parse('20.5'),
       decimalDefaultAndDefaultPersist =
           decimalDefaultAndDefaultPersist ?? _i1.Decimal.parse('10.5'),
       decimalDefaultModelAndDefaultPersist =
           decimalDefaultModelAndDefaultPersist ?? _i1.Decimal.parse('10.5');

  factory DecimalDefaultMix({
    int? id,
    _i1.Decimal? decimalDefaultAndDefaultModel,
    _i1.Decimal? decimalDefaultAndDefaultPersist,
    _i1.Decimal? decimalDefaultModelAndDefaultPersist,
  }) = _DecimalDefaultMixImpl;

  factory DecimalDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return DecimalDefaultMix(
      id: jsonSerialization['id'] as int?,
      decimalDefaultAndDefaultModel:
          jsonSerialization['decimalDefaultAndDefaultModel'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['decimalDefaultAndDefaultModel'],
            ),
      decimalDefaultAndDefaultPersist:
          jsonSerialization['decimalDefaultAndDefaultPersist'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['decimalDefaultAndDefaultPersist'],
            ),
      decimalDefaultModelAndDefaultPersist:
          jsonSerialization['decimalDefaultModelAndDefaultPersist'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['decimalDefaultModelAndDefaultPersist'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.Decimal decimalDefaultAndDefaultModel;

  _i1.Decimal decimalDefaultAndDefaultPersist;

  _i1.Decimal decimalDefaultModelAndDefaultPersist;

  /// Returns a shallow copy of this [DecimalDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DecimalDefaultMix copyWith({
    int? id,
    _i1.Decimal? decimalDefaultAndDefaultModel,
    _i1.Decimal? decimalDefaultAndDefaultPersist,
    _i1.Decimal? decimalDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DecimalDefaultMix',
      if (id != null) 'id': id,
      'decimalDefaultAndDefaultModel': decimalDefaultAndDefaultModel.toJson(),
      'decimalDefaultAndDefaultPersist': decimalDefaultAndDefaultPersist
          .toJson(),
      'decimalDefaultModelAndDefaultPersist':
          decimalDefaultModelAndDefaultPersist.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DecimalDefaultMixImpl extends DecimalDefaultMix {
  _DecimalDefaultMixImpl({
    int? id,
    _i1.Decimal? decimalDefaultAndDefaultModel,
    _i1.Decimal? decimalDefaultAndDefaultPersist,
    _i1.Decimal? decimalDefaultModelAndDefaultPersist,
  }) : super._(
         id: id,
         decimalDefaultAndDefaultModel: decimalDefaultAndDefaultModel,
         decimalDefaultAndDefaultPersist: decimalDefaultAndDefaultPersist,
         decimalDefaultModelAndDefaultPersist:
             decimalDefaultModelAndDefaultPersist,
       );

  /// Returns a shallow copy of this [DecimalDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DecimalDefaultMix copyWith({
    Object? id = _Undefined,
    _i1.Decimal? decimalDefaultAndDefaultModel,
    _i1.Decimal? decimalDefaultAndDefaultPersist,
    _i1.Decimal? decimalDefaultModelAndDefaultPersist,
  }) {
    return DecimalDefaultMix(
      id: id is int? ? id : this.id,
      decimalDefaultAndDefaultModel:
          decimalDefaultAndDefaultModel ?? this.decimalDefaultAndDefaultModel,
      decimalDefaultAndDefaultPersist:
          decimalDefaultAndDefaultPersist ??
          this.decimalDefaultAndDefaultPersist,
      decimalDefaultModelAndDefaultPersist:
          decimalDefaultModelAndDefaultPersist ??
          this.decimalDefaultModelAndDefaultPersist,
    );
  }
}
