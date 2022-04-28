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
    Map<String, dynamic> data = unwrapSerializationData(serialization);
    _index = data['index'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData(<String, dynamic>{
      'index': _index,
    });
  }

  static final AuthenticationFailReason invalidCredentials =
      AuthenticationFailReason._internal(0);
  static final AuthenticationFailReason userCreationDenied =
      AuthenticationFailReason._internal(1);
  static final AuthenticationFailReason internalError =
      AuthenticationFailReason._internal(2);

  @override
  int get hashCode => _index.hashCode;
  @override
  bool operator ==(Object other) =>
      other is AuthenticationFailReason && other._index == _index;

  static final List<AuthenticationFailReason> values =
      <AuthenticationFailReason>[
    invalidCredentials,
    userCreationDenied,
    internalError,
  ];

  String get name {
    if (this == invalidCredentials) return 'invalidCredentials';
    if (this == userCreationDenied) return 'userCreationDenied';
    if (this == internalError) return 'internalError';
    throw const FormatException();
  }
}
