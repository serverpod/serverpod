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
import 'providers/anonymous/models/exceptions/anonymous_account_blocked_exception.dart'
    as _i2;
import 'providers/anonymous/models/exceptions/anonymous_account_blocked_exception_reason.dart'
    as _i3;
import 'providers/email/models/exceptions/email_account_login_exception.dart'
    as _i4;
import 'providers/email/models/exceptions/email_account_login_exception_reason.dart'
    as _i5;
import 'providers/email/models/exceptions/email_account_password_reset_exception.dart'
    as _i6;
import 'providers/email/models/exceptions/email_account_password_reset_exception_reason.dart'
    as _i7;
import 'providers/email/models/exceptions/email_account_request_exception.dart'
    as _i8;
import 'providers/email/models/exceptions/email_account_request_exception_reason.dart'
    as _i9;
import 'providers/facebook/models/facebook_access_token_verification_exception.dart'
    as _i10;
import 'providers/firebase/models/firebase_id_token_verification_exception.dart'
    as _i11;
import 'providers/github/models/github_access_token_verification_exception.dart'
    as _i12;
import 'providers/google/models/google_id_token_verification_exception.dart'
    as _i13;
import 'providers/microsoft/models/microsoft_access_token_verification_exception.dart'
    as _i14;
import 'providers/passkey/models/passkey_challenge_expired_exception.dart'
    as _i15;
import 'providers/passkey/models/passkey_challenge_not_found_exception.dart'
    as _i16;
import 'providers/passkey/models/passkey_login_request.dart' as _i17;
import 'providers/passkey/models/passkey_public_key_not_found_exception.dart'
    as _i18;
import 'providers/passkey/models/passkey_registration_request.dart' as _i19;
import 'providers/passwordless/models/exceptions/passwordless_login_exception.dart'
    as _i20;
import 'providers/passwordless/models/exceptions/passwordless_login_exception_reason.dart'
    as _i21;
import 'dart:typed_data' as _i22;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i23;
export 'providers/anonymous/models/exceptions/anonymous_account_blocked_exception.dart';
export 'providers/anonymous/models/exceptions/anonymous_account_blocked_exception_reason.dart';
export 'providers/email/models/exceptions/email_account_login_exception.dart';
export 'providers/email/models/exceptions/email_account_login_exception_reason.dart';
export 'providers/email/models/exceptions/email_account_password_reset_exception.dart';
export 'providers/email/models/exceptions/email_account_password_reset_exception_reason.dart';
export 'providers/email/models/exceptions/email_account_request_exception.dart';
export 'providers/email/models/exceptions/email_account_request_exception_reason.dart';
export 'providers/facebook/models/facebook_access_token_verification_exception.dart';
export 'providers/firebase/models/firebase_id_token_verification_exception.dart';
export 'providers/github/models/github_access_token_verification_exception.dart';
export 'providers/google/models/google_id_token_verification_exception.dart';
export 'providers/microsoft/models/microsoft_access_token_verification_exception.dart';
export 'providers/passkey/models/passkey_challenge_expired_exception.dart';
export 'providers/passkey/models/passkey_challenge_not_found_exception.dart';
export 'providers/passkey/models/passkey_login_request.dart';
export 'providers/passkey/models/passkey_public_key_not_found_exception.dart';
export 'providers/passkey/models/passkey_registration_request.dart';
export 'providers/passwordless/models/exceptions/passwordless_login_exception.dart';
export 'providers/passwordless/models/exceptions/passwordless_login_exception_reason.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    if (className == null) return null;
    if (!className.startsWith('serverpod_auth_idp.')) return className;
    return className.substring(19);
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.AnonymousAccountBlockedException) {
      return _i2.AnonymousAccountBlockedException.fromJson(data) as T;
    }
    if (t == _i3.AnonymousAccountBlockedExceptionReason) {
      return _i3.AnonymousAccountBlockedExceptionReason.fromJson(data) as T;
    }
    if (t == _i4.EmailAccountLoginException) {
      return _i4.EmailAccountLoginException.fromJson(data) as T;
    }
    if (t == _i5.EmailAccountLoginExceptionReason) {
      return _i5.EmailAccountLoginExceptionReason.fromJson(data) as T;
    }
    if (t == _i6.EmailAccountPasswordResetException) {
      return _i6.EmailAccountPasswordResetException.fromJson(data) as T;
    }
    if (t == _i7.EmailAccountPasswordResetExceptionReason) {
      return _i7.EmailAccountPasswordResetExceptionReason.fromJson(data) as T;
    }
    if (t == _i8.EmailAccountRequestException) {
      return _i8.EmailAccountRequestException.fromJson(data) as T;
    }
    if (t == _i9.EmailAccountRequestExceptionReason) {
      return _i9.EmailAccountRequestExceptionReason.fromJson(data) as T;
    }
    if (t == _i10.FacebookAccessTokenVerificationException) {
      return _i10.FacebookAccessTokenVerificationException.fromJson(data) as T;
    }
    if (t == _i11.FirebaseIdTokenVerificationException) {
      return _i11.FirebaseIdTokenVerificationException.fromJson(data) as T;
    }
    if (t == _i12.GitHubAccessTokenVerificationException) {
      return _i12.GitHubAccessTokenVerificationException.fromJson(data) as T;
    }
    if (t == _i13.GoogleIdTokenVerificationException) {
      return _i13.GoogleIdTokenVerificationException.fromJson(data) as T;
    }
    if (t == _i14.MicrosoftAccessTokenVerificationException) {
      return _i14.MicrosoftAccessTokenVerificationException.fromJson(data) as T;
    }
    if (t == _i15.PasskeyChallengeExpiredException) {
      return _i15.PasskeyChallengeExpiredException.fromJson(data) as T;
    }
    if (t == _i16.PasskeyChallengeNotFoundException) {
      return _i16.PasskeyChallengeNotFoundException.fromJson(data) as T;
    }
    if (t == _i17.PasskeyLoginRequest) {
      return _i17.PasskeyLoginRequest.fromJson(data) as T;
    }
    if (t == _i18.PasskeyPublicKeyNotFoundException) {
      return _i18.PasskeyPublicKeyNotFoundException.fromJson(data) as T;
    }
    if (t == _i19.PasskeyRegistrationRequest) {
      return _i19.PasskeyRegistrationRequest.fromJson(data) as T;
    }
    if (t == _i20.PasswordlessLoginException) {
      return _i20.PasswordlessLoginException.fromJson(data) as T;
    }
    if (t == _i21.PasswordlessLoginExceptionReason) {
      return _i21.PasswordlessLoginExceptionReason.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AnonymousAccountBlockedException?>()) {
      return (data != null
              ? _i2.AnonymousAccountBlockedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i3.AnonymousAccountBlockedExceptionReason?>()) {
      return (data != null
              ? _i3.AnonymousAccountBlockedExceptionReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i4.EmailAccountLoginException?>()) {
      return (data != null
              ? _i4.EmailAccountLoginException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i5.EmailAccountLoginExceptionReason?>()) {
      return (data != null
              ? _i5.EmailAccountLoginExceptionReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i6.EmailAccountPasswordResetException?>()) {
      return (data != null
              ? _i6.EmailAccountPasswordResetException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i7.EmailAccountPasswordResetExceptionReason?>()) {
      return (data != null
              ? _i7.EmailAccountPasswordResetExceptionReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i8.EmailAccountRequestException?>()) {
      return (data != null
              ? _i8.EmailAccountRequestException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i9.EmailAccountRequestExceptionReason?>()) {
      return (data != null
              ? _i9.EmailAccountRequestExceptionReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i10.FacebookAccessTokenVerificationException?>()) {
      return (data != null
              ? _i10.FacebookAccessTokenVerificationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i11.FirebaseIdTokenVerificationException?>()) {
      return (data != null
              ? _i11.FirebaseIdTokenVerificationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i12.GitHubAccessTokenVerificationException?>()) {
      return (data != null
              ? _i12.GitHubAccessTokenVerificationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i13.GoogleIdTokenVerificationException?>()) {
      return (data != null
              ? _i13.GoogleIdTokenVerificationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i14.MicrosoftAccessTokenVerificationException?>()) {
      return (data != null
              ? _i14.MicrosoftAccessTokenVerificationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i15.PasskeyChallengeExpiredException?>()) {
      return (data != null
              ? _i15.PasskeyChallengeExpiredException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i16.PasskeyChallengeNotFoundException?>()) {
      return (data != null
              ? _i16.PasskeyChallengeNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i17.PasskeyLoginRequest?>()) {
      return (data != null ? _i17.PasskeyLoginRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.PasskeyPublicKeyNotFoundException?>()) {
      return (data != null
              ? _i18.PasskeyPublicKeyNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i19.PasskeyRegistrationRequest?>()) {
      return (data != null
              ? _i19.PasskeyRegistrationRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i20.PasswordlessLoginException?>()) {
      return (data != null
              ? _i20.PasswordlessLoginException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i21.PasswordlessLoginExceptionReason?>()) {
      return (data != null
              ? _i21.PasswordlessLoginExceptionReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<({_i22.ByteData challenge, _i1.UuidValue id})>()) {
      return (
            challenge: deserialize<_i22.ByteData>(
              ((data as Map)['n'] as Map)['challenge'],
            ),
            id: deserialize<_i1.UuidValue>(data['n']['id']),
          )
          as T;
    }
    try {
      return _i23.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AnonymousAccountBlockedException =>
        'AnonymousAccountBlockedException',
      _i3.AnonymousAccountBlockedExceptionReason =>
        'AnonymousAccountBlockedExceptionReason',
      _i4.EmailAccountLoginException => 'EmailAccountLoginException',
      _i5.EmailAccountLoginExceptionReason =>
        'EmailAccountLoginExceptionReason',
      _i6.EmailAccountPasswordResetException =>
        'EmailAccountPasswordResetException',
      _i7.EmailAccountPasswordResetExceptionReason =>
        'EmailAccountPasswordResetExceptionReason',
      _i8.EmailAccountRequestException => 'EmailAccountRequestException',
      _i9.EmailAccountRequestExceptionReason =>
        'EmailAccountRequestExceptionReason',
      _i10.FacebookAccessTokenVerificationException =>
        'FacebookAccessTokenVerificationException',
      _i11.FirebaseIdTokenVerificationException =>
        'FirebaseIdTokenVerificationException',
      _i12.GitHubAccessTokenVerificationException =>
        'GitHubAccessTokenVerificationException',
      _i13.GoogleIdTokenVerificationException =>
        'GoogleIdTokenVerificationException',
      _i14.MicrosoftAccessTokenVerificationException =>
        'MicrosoftAccessTokenVerificationException',
      _i15.PasskeyChallengeExpiredException =>
        'PasskeyChallengeExpiredException',
      _i16.PasskeyChallengeNotFoundException =>
        'PasskeyChallengeNotFoundException',
      _i17.PasskeyLoginRequest => 'PasskeyLoginRequest',
      _i18.PasskeyPublicKeyNotFoundException =>
        'PasskeyPublicKeyNotFoundException',
      _i19.PasskeyRegistrationRequest => 'PasskeyRegistrationRequest',
      _i20.PasswordlessLoginException => 'PasswordlessLoginException',
      _i21.PasswordlessLoginExceptionReason =>
        'PasswordlessLoginExceptionReason',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'serverpod_auth_idp.',
        '',
      );
    }

    switch (data) {
      case _i2.AnonymousAccountBlockedException():
        return 'AnonymousAccountBlockedException';
      case _i3.AnonymousAccountBlockedExceptionReason():
        return 'AnonymousAccountBlockedExceptionReason';
      case _i4.EmailAccountLoginException():
        return 'EmailAccountLoginException';
      case _i5.EmailAccountLoginExceptionReason():
        return 'EmailAccountLoginExceptionReason';
      case _i6.EmailAccountPasswordResetException():
        return 'EmailAccountPasswordResetException';
      case _i7.EmailAccountPasswordResetExceptionReason():
        return 'EmailAccountPasswordResetExceptionReason';
      case _i8.EmailAccountRequestException():
        return 'EmailAccountRequestException';
      case _i9.EmailAccountRequestExceptionReason():
        return 'EmailAccountRequestExceptionReason';
      case _i10.FacebookAccessTokenVerificationException():
        return 'FacebookAccessTokenVerificationException';
      case _i11.FirebaseIdTokenVerificationException():
        return 'FirebaseIdTokenVerificationException';
      case _i12.GitHubAccessTokenVerificationException():
        return 'GitHubAccessTokenVerificationException';
      case _i13.GoogleIdTokenVerificationException():
        return 'GoogleIdTokenVerificationException';
      case _i14.MicrosoftAccessTokenVerificationException():
        return 'MicrosoftAccessTokenVerificationException';
      case _i15.PasskeyChallengeExpiredException():
        return 'PasskeyChallengeExpiredException';
      case _i16.PasskeyChallengeNotFoundException():
        return 'PasskeyChallengeNotFoundException';
      case _i17.PasskeyLoginRequest():
        return 'PasskeyLoginRequest';
      case _i18.PasskeyPublicKeyNotFoundException():
        return 'PasskeyPublicKeyNotFoundException';
      case _i19.PasskeyRegistrationRequest():
        return 'PasskeyRegistrationRequest';
      case _i20.PasswordlessLoginException():
        return 'PasswordlessLoginException';
      case _i21.PasswordlessLoginExceptionReason():
        return 'PasswordlessLoginExceptionReason';
    }
    className = _i23.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'AnonymousAccountBlockedException') {
      return deserialize<_i2.AnonymousAccountBlockedException>(data['data']);
    }
    if (dataClassName == 'AnonymousAccountBlockedExceptionReason') {
      return deserialize<_i3.AnonymousAccountBlockedExceptionReason>(
        data['data'],
      );
    }
    if (dataClassName == 'EmailAccountLoginException') {
      return deserialize<_i4.EmailAccountLoginException>(data['data']);
    }
    if (dataClassName == 'EmailAccountLoginExceptionReason') {
      return deserialize<_i5.EmailAccountLoginExceptionReason>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetException') {
      return deserialize<_i6.EmailAccountPasswordResetException>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetExceptionReason') {
      return deserialize<_i7.EmailAccountPasswordResetExceptionReason>(
        data['data'],
      );
    }
    if (dataClassName == 'EmailAccountRequestException') {
      return deserialize<_i8.EmailAccountRequestException>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequestExceptionReason') {
      return deserialize<_i9.EmailAccountRequestExceptionReason>(data['data']);
    }
    if (dataClassName == 'FacebookAccessTokenVerificationException') {
      return deserialize<_i10.FacebookAccessTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'FirebaseIdTokenVerificationException') {
      return deserialize<_i11.FirebaseIdTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'GitHubAccessTokenVerificationException') {
      return deserialize<_i12.GitHubAccessTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'GoogleIdTokenVerificationException') {
      return deserialize<_i13.GoogleIdTokenVerificationException>(data['data']);
    }
    if (dataClassName == 'MicrosoftAccessTokenVerificationException') {
      return deserialize<_i14.MicrosoftAccessTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'PasskeyChallengeExpiredException') {
      return deserialize<_i15.PasskeyChallengeExpiredException>(data['data']);
    }
    if (dataClassName == 'PasskeyChallengeNotFoundException') {
      return deserialize<_i16.PasskeyChallengeNotFoundException>(data['data']);
    }
    if (dataClassName == 'PasskeyLoginRequest') {
      return deserialize<_i17.PasskeyLoginRequest>(data['data']);
    }
    if (dataClassName == 'PasskeyPublicKeyNotFoundException') {
      return deserialize<_i18.PasskeyPublicKeyNotFoundException>(data['data']);
    }
    if (dataClassName == 'PasskeyRegistrationRequest') {
      return deserialize<_i19.PasskeyRegistrationRequest>(data['data']);
    }
    if (dataClassName == 'PasswordlessLoginException') {
      return deserialize<_i20.PasswordlessLoginException>(data['data']);
    }
    if (dataClassName == 'PasswordlessLoginExceptionReason') {
      return deserialize<_i21.PasswordlessLoginExceptionReason>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i23.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
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
    if (record is ({_i22.ByteData challenge, _i1.UuidValue id})) {
      return {
        "n": {
          "challenge": record.challenge,
          "id": record.id,
        },
      };
    }
    try {
      return _i23.Protocol().mapRecordToJson(record);
    } catch (_) {}
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
            },
        ];

      case Iterable():
        return [
          for (var e in obj) mapIfNeeded(e),
        ];
    }

    return obj;
  }
}
