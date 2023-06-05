/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:collection/collection.dart' as _i2;

abstract class ExceptionWithData extends _i1.SerializableEntity
    implements _i1.SerializableException {
  const ExceptionWithData._();

  const factory ExceptionWithData({
    required String message,
    required DateTime creationDate,
    required List<String> errorFields,
    int? someNullableField,
  }) = _ExceptionWithData;

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

  ExceptionWithData copyWith({
    String? message,
    DateTime? creationDate,
    List<String>? errorFields,
    int? someNullableField,
  });
  String get message;
  DateTime get creationDate;
  List<String> get errorFields;
  int? get someNullableField;
}

class _Undefined {}

class _ExceptionWithData extends ExceptionWithData
    implements _i1.SerializableException {
  const _ExceptionWithData({
    required this.message,
    required this.creationDate,
    required this.errorFields,
    this.someNullableField,
  }) : super._();

  @override
  final String message;

  @override
  final DateTime creationDate;

  @override
  final List<String> errorFields;

  @override
  final int? someNullableField;

  @override
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'creationDate': creationDate,
      'errorFields': errorFields,
      'someNullableField': someNullableField,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ExceptionWithData &&
            (identical(
                  other.message,
                  message,
                ) ||
                other.message == message) &&
            (identical(
                  other.creationDate,
                  creationDate,
                ) ||
                other.creationDate == creationDate) &&
            (identical(
                  other.someNullableField,
                  someNullableField,
                ) ||
                other.someNullableField == someNullableField) &&
            const _i2.DeepCollectionEquality().equals(
              errorFields,
              other.errorFields,
            ));
  }

  @override
  int get hashCode => Object.hash(
        message,
        creationDate,
        someNullableField,
        const _i2.DeepCollectionEquality().hash(errorFields),
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
      errorFields: errorFields ?? this.errorFields,
      someNullableField: someNullableField == _Undefined
          ? this.someNullableField
          : (someNullableField as int?),
    );
  }
}
