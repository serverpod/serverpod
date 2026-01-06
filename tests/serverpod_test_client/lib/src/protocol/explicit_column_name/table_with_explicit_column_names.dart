/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: deprecated_member_use_from_same_package

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class TableWithExplicitColumnName implements _i1.SerializableModel {
  TableWithExplicitColumnName._({
    this.id,
    required this.userName,
    String? description,
  }) : description = description ?? 'Just some information';

  factory TableWithExplicitColumnName({
    int? id,
    required String userName,
    String? description,
  }) = _TableWithExplicitColumnNameImpl;

  factory TableWithExplicitColumnName.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TableWithExplicitColumnName(
      id: jsonSerialization['id'] as int?,
      userName: jsonSerialization['userName'] as String,
      description: jsonSerialization['description'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userName;

  String? description;

  /// Returns a shallow copy of this [TableWithExplicitColumnName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TableWithExplicitColumnName copyWith({
    int? id,
    String? userName,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TableWithExplicitColumnName',
      if (id != null) 'id': id,
      'userName': userName,
      if (description != null) 'description': description,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TableWithExplicitColumnNameImpl extends TableWithExplicitColumnName {
  _TableWithExplicitColumnNameImpl({
    int? id,
    required String userName,
    String? description,
  }) : super._(
         id: id,
         userName: userName,
         description: description,
       );

  /// Returns a shallow copy of this [TableWithExplicitColumnName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TableWithExplicitColumnName copyWith({
    Object? id = _Undefined,
    String? userName,
    Object? description = _Undefined,
  }) {
    return TableWithExplicitColumnName(
      id: id is int? ? id : this.id,
      userName: userName ?? this.userName,
      description: description is String? ? description : this.description,
    );
  }
}
