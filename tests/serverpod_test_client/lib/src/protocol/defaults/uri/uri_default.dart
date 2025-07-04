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

abstract class UriDefault implements _i1.SerializableModel {
  UriDefault._({
    this.id,
    Uri? uriDefault,
    Uri? uriDefaultNull,
  })  : uriDefault = uriDefault ?? Uri.parse('https://serverpod.dev/default'),
        uriDefaultNull =
            uriDefaultNull ?? Uri.parse('https://serverpod.dev/default');

  factory UriDefault({
    int? id,
    Uri? uriDefault,
    Uri? uriDefaultNull,
  }) = _UriDefaultImpl;

  factory UriDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return UriDefault(
      id: jsonSerialization['id'] as int?,
      uriDefault:
          _i1.UriJsonExtension.fromJson(jsonSerialization['uriDefault']),
      uriDefaultNull: jsonSerialization['uriDefaultNull'] == null
          ? null
          : _i1.UriJsonExtension.fromJson(jsonSerialization['uriDefaultNull']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  Uri uriDefault;

  Uri? uriDefaultNull;

  /// Returns a shallow copy of this [UriDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UriDefault copyWith({
    int? id,
    Uri? uriDefault,
    Uri? uriDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uriDefault': uriDefault.toJson(),
      if (uriDefaultNull != null) 'uriDefaultNull': uriDefaultNull?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UriDefaultImpl extends UriDefault {
  _UriDefaultImpl({
    int? id,
    Uri? uriDefault,
    Uri? uriDefaultNull,
  }) : super._(
          id: id,
          uriDefault: uriDefault,
          uriDefaultNull: uriDefaultNull,
        );

  /// Returns a shallow copy of this [UriDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UriDefault copyWith({
    Object? id = _Undefined,
    Uri? uriDefault,
    Object? uriDefaultNull = _Undefined,
  }) {
    return UriDefault(
      id: id is int? ? id : this.id,
      uriDefault: uriDefault ?? this.uriDefault,
      uriDefaultNull:
          uriDefaultNull is Uri? ? uriDefaultNull : this.uriDefaultNull,
    );
  }
}
