/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class UniqueData extends _i1.SerializableEntity {
  UniqueData._({
    this.id,
    required this.number,
    required this.email,
  });

  factory UniqueData({
    int? id,
    required int number,
    required String email,
  }) = _UniqueDataImpl;

  factory UniqueData.fromJson(Map<String, dynamic> jsonSerialization) {
    return UniqueData(
      id: jsonSerialization['id'] as int?,
      number: jsonSerialization['number'] as int,
      email: jsonSerialization['email'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int number;

  String email;

  UniqueData copyWith({
    int? id,
    int? number,
    String? email,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'number': number,
      'email': email,
    };
  }
}

class _Undefined {}

class _UniqueDataImpl extends UniqueData {
  _UniqueDataImpl({
    int? id,
    required int number,
    required String email,
  }) : super._(
          id: id,
          number: number,
          email: email,
        );

  @override
  UniqueData copyWith({
    Object? id = _Undefined,
    int? number,
    String? email,
  }) {
    return UniqueData(
      id: id is int? ? id : this.id,
      number: number ?? this.number,
      email: email ?? this.email,
    );
  }
}
