/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import 'exception_detail.dart' as _i1vx2qjs;

abstract class ExceptionWithModelList
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  ExceptionWithModelList._({
    required this.message,
    required this.details,
  });

  factory ExceptionWithModelList({
    required String message,
    required List<_i1vx2qjs.ExceptionDetail> details,
  }) = _ExceptionWithModelListImpl;

  factory ExceptionWithModelList.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ExceptionWithModelList(
      message: jsonSerialization['message'] as String,
      details: _igqrxdcj.Protocol()
          .deserialize<List<_i1vx2qjs.ExceptionDetail>>(
            jsonSerialization['details'],
          ),
    );
  }

  String message;

  List<_i1vx2qjs.ExceptionDetail> details;

  /// Returns a shallow copy of this [ExceptionWithModelList]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ExceptionWithModelList copyWith({
    String? message,
    List<_i1vx2qjs.ExceptionDetail>? details,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExceptionWithModelList',
      'message': message,
      'details': details.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ExceptionWithModelList',
      'message': message,
      'details': details.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return 'ExceptionWithModelList(message: $message, details: $details)';
  }
}

class _ExceptionWithModelListImpl extends ExceptionWithModelList {
  _ExceptionWithModelListImpl({
    required String message,
    required List<_i1vx2qjs.ExceptionDetail> details,
  }) : super._(
         message: message,
         details: details,
       );

  /// Returns a shallow copy of this [ExceptionWithModelList]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ExceptionWithModelList copyWith({
    String? message,
    List<_i1vx2qjs.ExceptionDetail>? details,
  }) {
    return ExceptionWithModelList(
      message: message ?? this.message,
      details: details ?? this.details.map((e0) => e0.copyWith()).toList(),
    );
  }
}
