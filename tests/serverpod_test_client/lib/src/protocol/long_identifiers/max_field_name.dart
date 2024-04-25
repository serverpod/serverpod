/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class MaxFieldName extends _i1.SerializableEntity {
  MaxFieldName._({
    this.id,
    required this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  });

  factory MaxFieldName({
    int? id,
    required String
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  }) = _MaxFieldNameImpl;

  factory MaxFieldName.fromJson(Map<String, dynamic> jsonSerialization) {
    return MaxFieldName(
      id: jsonSerialization['id'] as int?,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo:
          jsonSerialization[
                  'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo']
              as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo;

  MaxFieldName copyWith({
    int? id,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
    };
  }
}

class _Undefined {}

class _MaxFieldNameImpl extends MaxFieldName {
  _MaxFieldNameImpl({
    int? id,
    required String
        thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  }) : super._(
          id: id,
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo:
              thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
        );

  @override
  MaxFieldName copyWith({
    Object? id = _Undefined,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  }) {
    return MaxFieldName(
      id: id is int? ? id : this.id,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo:
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo ??
              this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
    );
  }
}
