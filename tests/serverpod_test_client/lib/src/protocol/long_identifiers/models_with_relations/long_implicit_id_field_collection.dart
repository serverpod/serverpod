/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i2;

abstract class LongImplicitIdFieldCollection implements _i1.SerializableModel {
  LongImplicitIdFieldCollection._({
    this.id,
    required this.name,
    this.thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
  });

  factory LongImplicitIdFieldCollection({
    int? id,
    required String name,
    List<_i2.LongImplicitIdField>?
        thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
  }) = _LongImplicitIdFieldCollectionImpl;

  factory LongImplicitIdFieldCollection.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return LongImplicitIdFieldCollection(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa:
          (jsonSerialization[
                      'thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa']
                  as List?)
              ?.map((e) =>
                  _i2.LongImplicitIdField.fromJson((e as Map<String, dynamic>)))
              .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.LongImplicitIdField>?
      thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa;

  /// Returns a shallow copy of this [LongImplicitIdFieldCollection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LongImplicitIdFieldCollection copyWith({
    int? id,
    String? name,
    List<_i2.LongImplicitIdField>?
        thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa != null)
        'thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa':
            thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa
                ?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LongImplicitIdFieldCollectionImpl extends LongImplicitIdFieldCollection {
  _LongImplicitIdFieldCollectionImpl({
    int? id,
    required String name,
    List<_i2.LongImplicitIdField>?
        thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
  }) : super._(
          id: id,
          name: name,
          thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa:
              thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa,
        );

  /// Returns a shallow copy of this [LongImplicitIdFieldCollection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LongImplicitIdFieldCollection copyWith({
    Object? id = _Undefined,
    String? name,
    Object? thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa =
        _Undefined,
  }) {
    return LongImplicitIdFieldCollection(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa:
          thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa
                  is List<_i2.LongImplicitIdField>?
              ? thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa
              : this
                  .thisFieldIsExactly61CharactersLongAndIsThereforeAValidFieldNa
                  ?.map((e0) => e0.copyWith())
                  .toList(),
    );
  }
}
