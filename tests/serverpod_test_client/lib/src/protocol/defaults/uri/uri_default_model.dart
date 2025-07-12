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

abstract class UriDefaultModel implements _i1.SerializableModel {
  UriDefaultModel._({
    this.id,
    Uri? uriDefaultModel,
    Uri? uriDefaultModelNull,
  })  : uriDefaultModel =
            uriDefaultModel ?? Uri.parse('https://serverpod.dev/defaultModel'),
        uriDefaultModelNull = uriDefaultModelNull ??
            Uri.parse('https://serverpod.dev/defaultModel');

  factory UriDefaultModel({
    int? id,
    Uri? uriDefaultModel,
    Uri? uriDefaultModelNull,
  }) = _UriDefaultModelImpl;

  factory UriDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return UriDefaultModel(
      id: jsonSerialization['id'] as int?,
      uriDefaultModel:
          _i1.UriJsonExtension.fromJson(jsonSerialization['uriDefaultModel']),
      uriDefaultModelNull: jsonSerialization['uriDefaultModelNull'] == null
          ? null
          : _i1.UriJsonExtension.fromJson(
              jsonSerialization['uriDefaultModelNull']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  Uri uriDefaultModel;

  Uri? uriDefaultModelNull;

  /// Returns a shallow copy of this [UriDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UriDefaultModel copyWith({
    int? id,
    Uri? uriDefaultModel,
    Uri? uriDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uriDefaultModel': uriDefaultModel.toJson(),
      if (uriDefaultModelNull != null)
        'uriDefaultModelNull': uriDefaultModelNull?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UriDefaultModelImpl extends UriDefaultModel {
  _UriDefaultModelImpl({
    int? id,
    Uri? uriDefaultModel,
    Uri? uriDefaultModelNull,
  }) : super._(
          id: id,
          uriDefaultModel: uriDefaultModel,
          uriDefaultModelNull: uriDefaultModelNull,
        );

  /// Returns a shallow copy of this [UriDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UriDefaultModel copyWith({
    Object? id = _Undefined,
    Uri? uriDefaultModel,
    Object? uriDefaultModelNull = _Undefined,
  }) {
    return UriDefaultModel(
      id: id is int? ? id : this.id,
      uriDefaultModel: uriDefaultModel ?? this.uriDefaultModel,
      uriDefaultModelNull: uriDefaultModelNull is Uri?
          ? uriDefaultModelNull
          : this.uriDefaultModelNull,
    );
  }
}
