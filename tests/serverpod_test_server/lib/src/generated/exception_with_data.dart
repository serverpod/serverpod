/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ExceptionWithData
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
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

  factory ExceptionWithData.fromJson(Map<String, dynamic> jsonSerialization) {
    return ExceptionWithData(
      message: jsonSerialization['message'] as String,
      creationDate:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['creationDate']),
      errorFields: (jsonSerialization['errorFields'] as List)
          .map((e) => e as String)
          .toList(),
      someNullableField: jsonSerialization['someNullableField'] as int?,
    );
  }

  String message;

  DateTime creationDate;

  List<String> errorFields;

  int? someNullableField;

  /// Returns a shallow copy of this [ExceptionWithData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
      'creationDate': creationDate.toJson(),
      'errorFields': errorFields.toJson(),
      if (someNullableField != null) 'someNullableField': someNullableField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'message': message,
      'creationDate': creationDate.toJson(),
      'errorFields': errorFields.toJson(),
      if (someNullableField != null) 'someNullableField': someNullableField,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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

  /// Returns a shallow copy of this [ExceptionWithData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
      errorFields: errorFields ?? this.errorFields.map((e0) => e0).toList(),
      someNullableField: someNullableField is int?
          ? someNullableField
          : this.someNullableField,
    );
  }
}
