/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class ExceptionWithData extends _i1.SerializableEntity
    implements _i1.SerializableException {
  ExceptionWithData({
    required this.message,
    required this.creationDate,
    required this.errorFields,
    this.someNullableField,
  });

  factory ExceptionWithData.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ExceptionWithData(
      message: serializationManager
          .deserialize<String>(jsonSerialization['message']),
      creationDate: serializationManager
          .deserialize<DateTime>(jsonSerialization['creationDate']),
      errorFields: serializationManager
          .deserialize<List<String>>(jsonSerialization['errorFields']),
      someNullableField: serializationManager
          .deserialize<int?>(jsonSerialization['someNullableField']),
    );
  }

  String message;

  DateTime creationDate;

  List<String> errorFields;

  int? someNullableField;

  @override
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'creationDate': creationDate,
      'errorFields': errorFields,
      'someNullableField': someNullableField,
    };
  }
}
