/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ObjectWithServerpodObject extends _i1.SerializableEntity {
  ObjectWithServerpodObject._({
    required this.logLevel1,
    required this.logLevel2,
  });

  factory ObjectWithServerpodObject({
    required _i1.LogLevel logLevel1,
    required _i1.LogLevel logLevel2,
  }) = _ObjectWithServerpodObjectImpl;

  factory ObjectWithServerpodObject.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ObjectWithServerpodObject(
      logLevel1: _i1.LogLevel.fromJson((jsonSerialization['logLevel1'] as int)),
      logLevel2: _i1.LogLevel.fromJson((jsonSerialization['logLevel2'] as int)),
    );
  }

  _i1.LogLevel logLevel1;

  _i1.LogLevel logLevel2;

  ObjectWithServerpodObject copyWith({
    _i1.LogLevel? logLevel1,
    _i1.LogLevel? logLevel2,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'logLevel1': logLevel1.toJson(),
      'logLevel2': logLevel2.toJson(),
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'logLevel1': logLevel1.toJson(),
      'logLevel2': logLevel2.toJson(),
    };
  }
}

class _ObjectWithServerpodObjectImpl extends ObjectWithServerpodObject {
  _ObjectWithServerpodObjectImpl({
    required _i1.LogLevel logLevel1,
    required _i1.LogLevel logLevel2,
  }) : super._(
          logLevel1: logLevel1,
          logLevel2: logLevel2,
        );

  @override
  ObjectWithServerpodObject copyWith({
    _i1.LogLevel? logLevel1,
    _i1.LogLevel? logLevel2,
  }) {
    return ObjectWithServerpodObject(
      logLevel1: logLevel1 ?? this.logLevel1,
      logLevel2: logLevel2 ?? this.logLevel2,
    );
  }
}
