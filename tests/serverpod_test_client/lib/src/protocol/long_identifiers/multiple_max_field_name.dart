/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class MultipleMaxFieldName extends _i1.SerializableEntity {
  MultipleMaxFieldName._({
    this.id,
    required this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    required this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
  });

  factory MultipleMaxFieldName({
    int? id,
    required String
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    required String
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
  }) = _MultipleMaxFieldNameImpl;

  factory MultipleMaxFieldName.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return MultipleMaxFieldName(
      id: jsonSerialization['id'] as int?,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1:
          jsonSerialization[
                  'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1']
              as String,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2:
          jsonSerialization[
                  'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2']
              as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1;

  String thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2;

  MultipleMaxFieldName copyWith({
    int? id,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
    };
  }
}

class _Undefined {}

class _MultipleMaxFieldNameImpl extends MultipleMaxFieldName {
  _MultipleMaxFieldNameImpl({
    int? id,
    required String
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    required String
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
  }) : super._(
          id: id,
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1:
              thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2:
              thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
        );

  @override
  MultipleMaxFieldName copyWith({
    Object? id = _Undefined,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
  }) {
    return MultipleMaxFieldName(
      id: id is int? ? id : this.id,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1:
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1 ??
              this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2:
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2 ??
              this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
    );
  }
}
