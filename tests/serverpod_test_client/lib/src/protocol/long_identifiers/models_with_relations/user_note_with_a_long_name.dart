/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class UserNoteWithALongName extends _i1.SerializableEntity {
  UserNoteWithALongName._({
    this.id,
    required this.name,
  });

  factory UserNoteWithALongName({
    int? id,
    required String name,
  }) = _UserNoteWithALongNameImpl;

  factory UserNoteWithALongName.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return UserNoteWithALongName(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  UserNoteWithALongName copyWith({
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
}

class _Undefined {}

class _UserNoteWithALongNameImpl extends UserNoteWithALongName {
  _UserNoteWithALongNameImpl({
    int? id,
    required String name,
  }) : super._(
          id: id,
          name: name,
        );

  @override
  UserNoteWithALongName copyWith({
    Object? id = _Undefined,
    String? name,
  }) {
    return UserNoteWithALongName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
    );
  }
}
