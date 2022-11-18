/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unnecessary_import

import 'package:serverpod_client/serverpod_client.dart';

class AuthenticationFailReason extends SerializableEntity {
  @override
  String get className => 'AuthenticationFailReason';

  late final int _index;
  int get index => _index;

  AuthenticationFailReason._internal(this._index);

  AuthenticationFailReason.fromSerialization(
      Map<String, dynamic> serialization) {
    var data = unwrapSerializationData(serialization);
    _index = data['index'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'index': _index,
    });
  }

  static final invalidCredentials = AuthenticationFailReason._internal(0);
  static final userCreationDenied = AuthenticationFailReason._internal(1);
  static final internalError = AuthenticationFailReason._internal(2);
  static final tooManyFailedAttempts = AuthenticationFailReason._internal(3);

  @override
  int get hashCode => _index.hashCode;
  @override
  bool operator ==(other) =>
      other is AuthenticationFailReason && other._index == _index;

  static final values = <AuthenticationFailReason>[
    invalidCredentials,
    userCreationDenied,
    internalError,
    tooManyFailedAttempts,
  ];

  String get name {
    if (this == invalidCredentials) return 'invalidCredentials';
    if (this == userCreationDenied) return 'userCreationDenied';
    if (this == internalError) return 'internalError';
    if (this == tooManyFailedAttempts) return 'tooManyFailedAttempts';
    throw const FormatException();
  }
}
