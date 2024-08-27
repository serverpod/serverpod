/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class DefaultException
    implements _i1.SerializableException, _i1.SerializableModel {
  DefaultException._({
    String? defaultMessage,
    String? defaultModelMessage,
    String? defaultMixMessage,
  })  : defaultMessage = defaultMessage ?? 'Default error message',
        defaultModelMessage =
            defaultModelMessage ?? 'Default model error message',
        defaultMixMessage = defaultMixMessage ?? 'Default model error message';

  factory DefaultException({
    String? defaultMessage,
    String? defaultModelMessage,
    String? defaultMixMessage,
  }) = _DefaultExceptionImpl;

  factory DefaultException.fromJson(Map<String, dynamic> jsonSerialization) {
    return DefaultException(
      defaultMessage: jsonSerialization['defaultMessage'] as String,
      defaultModelMessage: jsonSerialization['defaultModelMessage'] as String,
      defaultMixMessage: jsonSerialization['defaultMixMessage'] as String,
    );
  }

  String defaultMessage;

  String defaultModelMessage;

  String defaultMixMessage;

  DefaultException copyWith({
    String? defaultMessage,
    String? defaultModelMessage,
    String? defaultMixMessage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'defaultMessage': defaultMessage,
      'defaultModelMessage': defaultModelMessage,
      'defaultMixMessage': defaultMixMessage,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _DefaultExceptionImpl extends DefaultException {
  _DefaultExceptionImpl({
    String? defaultMessage,
    String? defaultModelMessage,
    String? defaultMixMessage,
  }) : super._(
          defaultMessage: defaultMessage,
          defaultModelMessage: defaultModelMessage,
          defaultMixMessage: defaultMixMessage,
        );

  @override
  DefaultException copyWith({
    String? defaultMessage,
    String? defaultModelMessage,
    String? defaultMixMessage,
  }) {
    return DefaultException(
      defaultMessage: defaultMessage ?? this.defaultMessage,
      defaultModelMessage: defaultModelMessage ?? this.defaultModelMessage,
      defaultMixMessage: defaultMixMessage ?? this.defaultMixMessage,
    );
  }
}
