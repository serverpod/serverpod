/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Just some simple data.
class DataWithUniqueFields extends _i1.SerializableEntity {
  DataWithUniqueFields({
    this.id,
    required this.num,
    required this.uniqueField,
  });

  factory DataWithUniqueFields.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DataWithUniqueFields(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      num: serializationManager.deserialize<int>(jsonSerialization['num']),
      uniqueField: serializationManager
          .deserialize<int>(jsonSerialization['uniqueField']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int num;

  int uniqueField;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'num': num,
      'uniqueField': uniqueField,
    };
  }
}
