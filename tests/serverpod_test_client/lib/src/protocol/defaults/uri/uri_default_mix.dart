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

abstract class UriDefaultMix implements _i1.SerializableModel {
  UriDefaultMix._({
    this.id,
    Uri? uriDefaultAndDefaultModel,
    Uri? uriDefaultAndDefaultPersist,
    Uri? uriDefaultModelAndDefaultPersist,
  })  : uriDefaultAndDefaultModel = uriDefaultAndDefaultModel ??
            Uri.parse('https://serverpod.dev/defaultModel'),
        uriDefaultAndDefaultPersist = uriDefaultAndDefaultPersist ??
            Uri.parse('https://serverpod.dev/default'),
        uriDefaultModelAndDefaultPersist = uriDefaultModelAndDefaultPersist ??
            Uri.parse('https://serverpod.dev/defaultModel');

  factory UriDefaultMix({
    int? id,
    Uri? uriDefaultAndDefaultModel,
    Uri? uriDefaultAndDefaultPersist,
    Uri? uriDefaultModelAndDefaultPersist,
  }) = _UriDefaultMixImpl;

  factory UriDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return UriDefaultMix(
      id: jsonSerialization['id'] as int?,
      uriDefaultAndDefaultModel: _i1.UriJsonExtension.fromJson(
          jsonSerialization['uriDefaultAndDefaultModel']),
      uriDefaultAndDefaultPersist: _i1.UriJsonExtension.fromJson(
          jsonSerialization['uriDefaultAndDefaultPersist']),
      uriDefaultModelAndDefaultPersist: _i1.UriJsonExtension.fromJson(
          jsonSerialization['uriDefaultModelAndDefaultPersist']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  Uri uriDefaultAndDefaultModel;

  Uri uriDefaultAndDefaultPersist;

  Uri uriDefaultModelAndDefaultPersist;

  /// Returns a shallow copy of this [UriDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UriDefaultMix copyWith({
    int? id,
    Uri? uriDefaultAndDefaultModel,
    Uri? uriDefaultAndDefaultPersist,
    Uri? uriDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uriDefaultAndDefaultModel': uriDefaultAndDefaultModel.toJson(),
      'uriDefaultAndDefaultPersist': uriDefaultAndDefaultPersist.toJson(),
      'uriDefaultModelAndDefaultPersist':
          uriDefaultModelAndDefaultPersist.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UriDefaultMixImpl extends UriDefaultMix {
  _UriDefaultMixImpl({
    int? id,
    Uri? uriDefaultAndDefaultModel,
    Uri? uriDefaultAndDefaultPersist,
    Uri? uriDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          uriDefaultAndDefaultModel: uriDefaultAndDefaultModel,
          uriDefaultAndDefaultPersist: uriDefaultAndDefaultPersist,
          uriDefaultModelAndDefaultPersist: uriDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [UriDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UriDefaultMix copyWith({
    Object? id = _Undefined,
    Uri? uriDefaultAndDefaultModel,
    Uri? uriDefaultAndDefaultPersist,
    Uri? uriDefaultModelAndDefaultPersist,
  }) {
    return UriDefaultMix(
      id: id is int? ? id : this.id,
      uriDefaultAndDefaultModel:
          uriDefaultAndDefaultModel ?? this.uriDefaultAndDefaultModel,
      uriDefaultAndDefaultPersist:
          uriDefaultAndDefaultPersist ?? this.uriDefaultAndDefaultPersist,
      uriDefaultModelAndDefaultPersist: uriDefaultModelAndDefaultPersist ??
          this.uriDefaultModelAndDefaultPersist,
    );
  }
}
