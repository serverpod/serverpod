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

abstract class TestRetryCallFailModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TestRetryCallFailModel._({required this.reason});

  factory TestRetryCallFailModel({required String reason}) =
      _TestRetryCallFailModelImpl;

  factory TestRetryCallFailModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TestRetryCallFailModel(
      reason: jsonSerialization['reason'] as String,
    );
  }

  String reason;

  /// Returns a shallow copy of this [TestRetryCallFailModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TestRetryCallFailModel copyWith({String? reason});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TestRetryCallFailModel',
      'reason': reason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _TestRetryCallFailModelImpl extends TestRetryCallFailModel {
  _TestRetryCallFailModelImpl({required String reason})
    : super._(reason: reason);

  /// Returns a shallow copy of this [TestRetryCallFailModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TestRetryCallFailModel copyWith({String? reason}) {
    return TestRetryCallFailModel(reason: reason ?? this.reason);
  }
}
