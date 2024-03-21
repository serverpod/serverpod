/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class LongImplicitIdField extends _i1.SerializableEntity {
  LongImplicitIdField._({
    this.id,
    required this.name,
  });

  factory LongImplicitIdField({
    int? id,
    required String name,
  }) = _LongImplicitIdFieldImpl;

  factory LongImplicitIdField.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return LongImplicitIdField(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  LongImplicitIdField copyWith({
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

class _LongImplicitIdFieldImpl extends LongImplicitIdField {
  _LongImplicitIdFieldImpl({
    int? id,
    required String name,
  }) : super._(
          id: id,
          name: name,
        );

  @override
  LongImplicitIdField copyWith({
    Object? id = _Undefined,
    String? name,
  }) {
    return LongImplicitIdField(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
    );
  }
}
