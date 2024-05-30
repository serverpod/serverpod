/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class UserNote implements _i1.SerializableModel {
  UserNote._({
    this.id,
    required this.name,
  });

  factory UserNote({
    int? id,
    required String name,
  }) = _UserNoteImpl;

  factory UserNote.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserNote(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  UserNote copyWith({
    int? id,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserNoteImpl extends UserNote {
  _UserNoteImpl({
    int? id,
    required String name,
  }) : super._(
          id: id,
          name: name,
        );

  @override
  UserNote copyWith({
    Object? id = _Undefined,
    String? name,
  }) {
    return UserNote(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
    );
  }
}
