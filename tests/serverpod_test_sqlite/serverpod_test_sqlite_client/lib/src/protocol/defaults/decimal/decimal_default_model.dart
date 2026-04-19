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

abstract class DecimalDefaultModel implements _i1.SerializableModel {
  DecimalDefaultModel._({
    this.id,
    _i1.Decimal? decimalDefaultModelStr,
    _i1.Decimal? decimalDefaultModelStrNull,
  }) : decimalDefaultModelStr =
           decimalDefaultModelStr ?? _i1.Decimal.parse('10.5'),
       decimalDefaultModelStrNull =
           decimalDefaultModelStrNull ?? _i1.Decimal.parse('20.5');

  factory DecimalDefaultModel({
    int? id,
    _i1.Decimal? decimalDefaultModelStr,
    _i1.Decimal? decimalDefaultModelStrNull,
  }) = _DecimalDefaultModelImpl;

  factory DecimalDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return DecimalDefaultModel(
      id: jsonSerialization['id'] as int?,
      decimalDefaultModelStr:
          jsonSerialization['decimalDefaultModelStr'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['decimalDefaultModelStr'],
            ),
      decimalDefaultModelStrNull:
          jsonSerialization['decimalDefaultModelStrNull'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['decimalDefaultModelStrNull'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.Decimal decimalDefaultModelStr;

  _i1.Decimal? decimalDefaultModelStrNull;

  /// Returns a shallow copy of this [DecimalDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DecimalDefaultModel copyWith({
    int? id,
    _i1.Decimal? decimalDefaultModelStr,
    _i1.Decimal? decimalDefaultModelStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DecimalDefaultModel',
      if (id != null) 'id': id,
      'decimalDefaultModelStr': decimalDefaultModelStr.toJson(),
      if (decimalDefaultModelStrNull != null)
        'decimalDefaultModelStrNull': decimalDefaultModelStrNull?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DecimalDefaultModelImpl extends DecimalDefaultModel {
  _DecimalDefaultModelImpl({
    int? id,
    _i1.Decimal? decimalDefaultModelStr,
    _i1.Decimal? decimalDefaultModelStrNull,
  }) : super._(
         id: id,
         decimalDefaultModelStr: decimalDefaultModelStr,
         decimalDefaultModelStrNull: decimalDefaultModelStrNull,
       );

  /// Returns a shallow copy of this [DecimalDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DecimalDefaultModel copyWith({
    Object? id = _Undefined,
    _i1.Decimal? decimalDefaultModelStr,
    Object? decimalDefaultModelStrNull = _Undefined,
  }) {
    return DecimalDefaultModel(
      id: id is int? ? id : this.id,
      decimalDefaultModelStr:
          decimalDefaultModelStr ?? this.decimalDefaultModelStr,
      decimalDefaultModelStrNull: decimalDefaultModelStrNull is _i1.Decimal?
          ? decimalDefaultModelStrNull
          : this.decimalDefaultModelStrNull,
    );
  }
}
