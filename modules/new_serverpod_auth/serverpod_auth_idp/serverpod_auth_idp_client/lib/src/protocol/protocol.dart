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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'providers/email/models/exceptions/email_account_login_exception.dart'
    as _i2;
import 'providers/email/models/exceptions/email_account_login_exception_reason.dart'
    as _i3;
import 'providers/email/models/exceptions/email_account_password_reset_exception.dart'
    as _i4;
import 'providers/email/models/exceptions/email_account_password_reset_exception_reason.dart'
    as _i5;
import 'providers/email/models/exceptions/email_account_request_exception.dart'
    as _i6;
import 'providers/email/models/exceptions/email_account_request_exception_reason.dart'
    as _i7;
import 'providers/google/models/google_id_token_verification_exception.dart'
    as _i8;
import 'providers/passkey/models/passkey_challenge_expired_exception.dart'
    as _i9;
import 'providers/passkey/models/passkey_challenge_not_found_exception.dart'
    as _i10;
import 'providers/passkey/models/passkey_login_request.dart' as _i11;
import 'providers/passkey/models/passkey_public_key_not_found_exception.dart'
    as _i12;
import 'providers/passkey/models/passkey_registration_request.dart' as _i13;
import 'dart:typed_data' as _i14;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i15;
export 'providers/email/models/exceptions/email_account_login_exception.dart';
export 'providers/email/models/exceptions/email_account_login_exception_reason.dart';
export 'providers/email/models/exceptions/email_account_password_reset_exception.dart';
export 'providers/email/models/exceptions/email_account_password_reset_exception_reason.dart';
export 'providers/email/models/exceptions/email_account_request_exception.dart';
export 'providers/email/models/exceptions/email_account_request_exception_reason.dart';
export 'providers/google/models/google_id_token_verification_exception.dart';
export 'providers/passkey/models/passkey_challenge_expired_exception.dart';
export 'providers/passkey/models/passkey_challenge_not_found_exception.dart';
export 'providers/passkey/models/passkey_login_request.dart';
export 'providers/passkey/models/passkey_public_key_not_found_exception.dart';
export 'providers/passkey/models/passkey_registration_request.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.EmailAccountLoginException) {
      return _i2.EmailAccountLoginException.fromJson(data) as T;
    }
    if (t == _i3.EmailAccountLoginExceptionReason) {
      return _i3.EmailAccountLoginExceptionReason.fromJson(data) as T;
    }
    if (t == _i4.EmailAccountPasswordResetException) {
      return _i4.EmailAccountPasswordResetException.fromJson(data) as T;
    }
    if (t == _i5.EmailAccountPasswordResetExceptionReason) {
      return _i5.EmailAccountPasswordResetExceptionReason.fromJson(data) as T;
    }
    if (t == _i6.EmailAccountRequestException) {
      return _i6.EmailAccountRequestException.fromJson(data) as T;
    }
    if (t == _i7.EmailAccountRequestExceptionReason) {
      return _i7.EmailAccountRequestExceptionReason.fromJson(data) as T;
    }
    if (t == _i8.GoogleIdTokenVerificationException) {
      return _i8.GoogleIdTokenVerificationException.fromJson(data) as T;
    }
    if (t == _i9.PasskeyChallengeExpiredException) {
      return _i9.PasskeyChallengeExpiredException.fromJson(data) as T;
    }
    if (t == _i10.PasskeyChallengeNotFoundException) {
      return _i10.PasskeyChallengeNotFoundException.fromJson(data) as T;
    }
    if (t == _i11.PasskeyLoginRequest) {
      return _i11.PasskeyLoginRequest.fromJson(data) as T;
    }
    if (t == _i12.PasskeyPublicKeyNotFoundException) {
      return _i12.PasskeyPublicKeyNotFoundException.fromJson(data) as T;
    }
    if (t == _i13.PasskeyRegistrationRequest) {
      return _i13.PasskeyRegistrationRequest.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.EmailAccountLoginException?>()) {
      return (data != null
          ? _i2.EmailAccountLoginException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i3.EmailAccountLoginExceptionReason?>()) {
      return (data != null
          ? _i3.EmailAccountLoginExceptionReason.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.EmailAccountPasswordResetException?>()) {
      return (data != null
          ? _i4.EmailAccountPasswordResetException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i5.EmailAccountPasswordResetExceptionReason?>()) {
      return (data != null
          ? _i5.EmailAccountPasswordResetExceptionReason.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i6.EmailAccountRequestException?>()) {
      return (data != null
          ? _i6.EmailAccountRequestException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i7.EmailAccountRequestExceptionReason?>()) {
      return (data != null
          ? _i7.EmailAccountRequestExceptionReason.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i8.GoogleIdTokenVerificationException?>()) {
      return (data != null
          ? _i8.GoogleIdTokenVerificationException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i9.PasskeyChallengeExpiredException?>()) {
      return (data != null
          ? _i9.PasskeyChallengeExpiredException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i10.PasskeyChallengeNotFoundException?>()) {
      return (data != null
          ? _i10.PasskeyChallengeNotFoundException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i11.PasskeyLoginRequest?>()) {
      return (data != null ? _i11.PasskeyLoginRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.PasskeyPublicKeyNotFoundException?>()) {
      return (data != null
          ? _i12.PasskeyPublicKeyNotFoundException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i13.PasskeyRegistrationRequest?>()) {
      return (data != null
          ? _i13.PasskeyRegistrationRequest.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<({_i14.ByteData challenge, _i1.UuidValue id})>()) {
      return (
        challenge: deserialize<_i14.ByteData>(
            ((data as Map)['n'] as Map)['challenge']),
        id: deserialize<_i1.UuidValue>(data['n']['id']),
      ) as T;
    }
    try {
      return _i15.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    switch (data) {
      case _i2.EmailAccountLoginException():
        return 'EmailAccountLoginException';
      case _i3.EmailAccountLoginExceptionReason():
        return 'EmailAccountLoginExceptionReason';
      case _i4.EmailAccountPasswordResetException():
        return 'EmailAccountPasswordResetException';
      case _i5.EmailAccountPasswordResetExceptionReason():
        return 'EmailAccountPasswordResetExceptionReason';
      case _i6.EmailAccountRequestException():
        return 'EmailAccountRequestException';
      case _i7.EmailAccountRequestExceptionReason():
        return 'EmailAccountRequestExceptionReason';
      case _i8.GoogleIdTokenVerificationException():
        return 'GoogleIdTokenVerificationException';
      case _i9.PasskeyChallengeExpiredException():
        return 'PasskeyChallengeExpiredException';
      case _i10.PasskeyChallengeNotFoundException():
        return 'PasskeyChallengeNotFoundException';
      case _i11.PasskeyLoginRequest():
        return 'PasskeyLoginRequest';
      case _i12.PasskeyPublicKeyNotFoundException():
        return 'PasskeyPublicKeyNotFoundException';
      case _i13.PasskeyRegistrationRequest():
        return 'PasskeyRegistrationRequest';
    }
    className = _i15.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'EmailAccountLoginException') {
      return deserialize<_i2.EmailAccountLoginException>(data['data']);
    }
    if (dataClassName == 'EmailAccountLoginExceptionReason') {
      return deserialize<_i3.EmailAccountLoginExceptionReason>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetException') {
      return deserialize<_i4.EmailAccountPasswordResetException>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetExceptionReason') {
      return deserialize<_i5.EmailAccountPasswordResetExceptionReason>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestException') {
      return deserialize<_i6.EmailAccountRequestException>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequestExceptionReason') {
      return deserialize<_i7.EmailAccountRequestExceptionReason>(data['data']);
    }
    if (dataClassName == 'GoogleIdTokenVerificationException') {
      return deserialize<_i8.GoogleIdTokenVerificationException>(data['data']);
    }
    if (dataClassName == 'PasskeyChallengeExpiredException') {
      return deserialize<_i9.PasskeyChallengeExpiredException>(data['data']);
    }
    if (dataClassName == 'PasskeyChallengeNotFoundException') {
      return deserialize<_i10.PasskeyChallengeNotFoundException>(data['data']);
    }
    if (dataClassName == 'PasskeyLoginRequest') {
      return deserialize<_i11.PasskeyLoginRequest>(data['data']);
    }
    if (dataClassName == 'PasskeyPublicKeyNotFoundException') {
      return deserialize<_i12.PasskeyPublicKeyNotFoundException>(data['data']);
    }
    if (dataClassName == 'PasskeyRegistrationRequest') {
      return deserialize<_i13.PasskeyRegistrationRequest>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i15.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}

/// Maps any `Record`s known to this [Protocol] to their JSON representation
///
/// Throws in case the record type is not known.
///
/// This method will return `null` (only) for `null` inputs.
Map<String, dynamic>? mapRecordToJson(Record? record) {
  if (record == null) {
    return null;
  }
  if (record is ({_i14.ByteData challenge, _i1.UuidValue id})) {
    return {
      "n": {
        "challenge": record.challenge,
        "id": record.id,
      },
    };
  }
  throw Exception('Unsupported record type ${record.runtimeType}');
}

/// Maps container types (like [List], [Map], [Set]) containing
/// [Record]s or non-String-keyed [Map]s to their JSON representation.
///
/// It should not be called for [SerializableModel] types. These
/// handle the "[Record] in container" mapping internally already.
///
/// It is only supposed to be called from generated protocol code.
///
/// Returns either a `List<dynamic>` (for List, Sets, and Maps with
/// non-String keys) or a `Map<String, dynamic>` in case the input was
/// a `Map<String, …>`.
Object? mapContainerToJson(Object obj) {
  if (obj is! Iterable && obj is! Map) {
    throw ArgumentError.value(
      obj,
      'obj',
      'The object to serialize should be of type List, Map, or Set',
    );
  }

  dynamic mapIfNeeded(Object? obj) {
    return switch (obj) {
      Record record => mapRecordToJson(record),
      Iterable iterable => mapContainerToJson(iterable),
      Map map => mapContainerToJson(map),
      Object? value => value,
    };
  }

  switch (obj) {
    case Map<String, dynamic>():
      return {
        for (var entry in obj.entries) entry.key: mapIfNeeded(entry.value),
      };
    case Map():
      return [
        for (var entry in obj.entries)
          {
            'k': mapIfNeeded(entry.key),
            'v': mapIfNeeded(entry.value),
          }
      ];

    case Iterable():
      return [
        for (var e in obj) mapIfNeeded(e),
      ];
  }

  return obj;
}
