/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unnecessary_import
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_serialization/serverpod_serialization.dart';

enum AuthenticationFailReason with SerializableEntity {
  invalidCredentials,
  userCreationDenied,
  internalError,
  tooManyFailedAttempts,
  ;

  static String get _className => 'AuthenticationFailReason';

  @override
  String get className => _className;

  factory AuthenticationFailReason.fromSerialization(
      Map<String, dynamic> serialization) {
    var data = SerializableEntity.unwrapSerializationDataForClassName(
        _className, serialization);
    switch (data['index']) {
      case 0:
        return AuthenticationFailReason.invalidCredentials;
      case 1:
        return AuthenticationFailReason.userCreationDenied;
      case 2:
        return AuthenticationFailReason.internalError;
      case 3:
        return AuthenticationFailReason.tooManyFailedAttempts;
      default:
        throw Exception('Invalid $_className index $data[\'index\']');
    }
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'index': index,
    });
  }
}
