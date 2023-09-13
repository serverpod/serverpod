/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ExceptionWithData extends _i1.SerializableEntity
    implements _i1.SerializableException {
  ExceptionWithData._({
    required this.message,
    required this.creationDate,
    required this.errorFields,
    this.someNullableField,
  });

  factory ExceptionWithData({
    required String message,
    required DateTime creationDate,
    required List<String> errorFields,
    int? someNullableField,
  }) = _ExceptionWithDataImpl;

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

  ExceptionWithData copyWith({
    String? message,
    DateTime? creationDate,
    List<String>? errorFields,
    int? someNullableField,
  });
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

class _Undefined {}

class _ExceptionWithDataImpl extends ExceptionWithData {
  _ExceptionWithDataImpl({
    required String message,
    required DateTime creationDate,
    required List<String> errorFields,
    int? someNullableField,
  }) : super._(
          message: message,
          creationDate: creationDate,
          errorFields: errorFields,
          someNullableField: someNullableField,
        );

  @override
  ExceptionWithData copyWith({
    String? message,
    DateTime? creationDate,
    List<String>? errorFields,
    Object? someNullableField = _Undefined,
  }) {
    return ExceptionWithData(
      message: message ?? this.message,
      creationDate: creationDate ?? this.creationDate,
      errorFields: errorFields ?? this.errorFields.clone(),
      someNullableField: someNullableField is int?
          ? someNullableField
          : this.someNullableField,
    );
  }
}
