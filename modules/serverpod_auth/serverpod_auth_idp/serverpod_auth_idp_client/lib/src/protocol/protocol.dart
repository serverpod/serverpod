/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:typed_data' as _idt;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'providers/anonymous/models/exceptions/anonymous_account_blocked_exception.dart'
    as _ite257iv;
import 'providers/anonymous/models/exceptions/anonymous_account_blocked_exception_reason.dart'
    as _ig3ph7nw;
import 'providers/email/models/exceptions/email_account_login_exception.dart'
    as _ij1yj4f1;
import 'providers/email/models/exceptions/email_account_login_exception_reason.dart'
    as _ihd5znj2;
import 'providers/email/models/exceptions/email_account_password_reset_exception.dart'
    as _i7yyr103;
import 'providers/email/models/exceptions/email_account_password_reset_exception_reason.dart'
    as _io8tbstn;
import 'providers/email/models/exceptions/email_account_request_exception.dart'
    as _iqtw285f;
import 'providers/email/models/exceptions/email_account_request_exception_reason.dart'
    as _isgeino8;
import 'providers/facebook/models/facebook_access_token_verification_exception.dart'
    as _i92zrjf0;
import 'providers/firebase/models/firebase_email_not_verified_exception.dart'
    as _imswdwet;
import 'providers/firebase/models/firebase_id_token_verification_exception.dart'
    as _i14hfyiz;
import 'providers/github/models/github_access_token_verification_exception.dart'
    as _i8u0zfwn;
import 'providers/google/models/google_id_token_verification_exception.dart'
    as _iyz9kvht;
import 'providers/microsoft/models/microsoft_access_token_verification_exception.dart'
    as _i0bj371b;
import 'providers/passkey/models/passkey_challenge_expired_exception.dart'
    as _ihzslz1a;
import 'providers/passkey/models/passkey_challenge_not_found_exception.dart'
    as _ihzssrx9;
import 'providers/passkey/models/passkey_login_request.dart' as _itcmwg9u;
import 'providers/passkey/models/passkey_public_key_not_found_exception.dart'
    as _isvo2sb5;
import 'providers/passkey/models/passkey_registration_request.dart'
    as _izjoggd8;
export 'providers/anonymous/models/exceptions/anonymous_account_blocked_exception.dart';
export 'providers/anonymous/models/exceptions/anonymous_account_blocked_exception_reason.dart';
export 'providers/email/models/exceptions/email_account_login_exception.dart';
export 'providers/email/models/exceptions/email_account_login_exception_reason.dart';
export 'providers/email/models/exceptions/email_account_password_reset_exception.dart';
export 'providers/email/models/exceptions/email_account_password_reset_exception_reason.dart';
export 'providers/email/models/exceptions/email_account_request_exception.dart';
export 'providers/email/models/exceptions/email_account_request_exception_reason.dart';
export 'providers/facebook/models/facebook_access_token_verification_exception.dart';
export 'providers/firebase/models/firebase_email_not_verified_exception.dart';
export 'providers/firebase/models/firebase_id_token_verification_exception.dart';
export 'providers/github/models/github_access_token_verification_exception.dart';
export 'providers/google/models/google_id_token_verification_exception.dart';
export 'providers/microsoft/models/microsoft_access_token_verification_exception.dart';
export 'providers/passkey/models/passkey_challenge_expired_exception.dart';
export 'providers/passkey/models/passkey_challenge_not_found_exception.dart';
export 'providers/passkey/models/passkey_login_request.dart';
export 'providers/passkey/models/passkey_public_key_not_found_exception.dart';
export 'providers/passkey/models/passkey_registration_request.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  final Set<_isc.SerializationManager> _hostProtocols = {};

  void registerHostProtocol(
    String projectName,
    _isc.SerializationManager protocol,
  ) {
    _hostProtocols.add(protocol);
  }

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
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ite257iv.AnonymousAccountBlockedException) {
      return _ite257iv.AnonymousAccountBlockedException.fromJson(data) as T;
    }
    if (t == _ig3ph7nw.AnonymousAccountBlockedExceptionReason) {
      return _ig3ph7nw.AnonymousAccountBlockedExceptionReason.fromJson(data)
          as T;
    }
    if (t == _ij1yj4f1.EmailAccountLoginException) {
      return _ij1yj4f1.EmailAccountLoginException.fromJson(data) as T;
    }
    if (t == _ihd5znj2.EmailAccountLoginExceptionReason) {
      return _ihd5znj2.EmailAccountLoginExceptionReason.fromJson(data) as T;
    }
    if (t == _i7yyr103.EmailAccountPasswordResetException) {
      return _i7yyr103.EmailAccountPasswordResetException.fromJson(data) as T;
    }
    if (t == _io8tbstn.EmailAccountPasswordResetExceptionReason) {
      return _io8tbstn.EmailAccountPasswordResetExceptionReason.fromJson(data)
          as T;
    }
    if (t == _iqtw285f.EmailAccountRequestException) {
      return _iqtw285f.EmailAccountRequestException.fromJson(data) as T;
    }
    if (t == _isgeino8.EmailAccountRequestExceptionReason) {
      return _isgeino8.EmailAccountRequestExceptionReason.fromJson(data) as T;
    }
    if (t == _i92zrjf0.FacebookAccessTokenVerificationException) {
      return _i92zrjf0.FacebookAccessTokenVerificationException.fromJson(data)
          as T;
    }
    if (t == _imswdwet.FirebaseEmailNotVerifiedException) {
      return _imswdwet.FirebaseEmailNotVerifiedException.fromJson(data) as T;
    }
    if (t == _i14hfyiz.FirebaseIdTokenVerificationException) {
      return _i14hfyiz.FirebaseIdTokenVerificationException.fromJson(data) as T;
    }
    if (t == _i8u0zfwn.GitHubAccessTokenVerificationException) {
      return _i8u0zfwn.GitHubAccessTokenVerificationException.fromJson(data)
          as T;
    }
    if (t == _iyz9kvht.GoogleIdTokenVerificationException) {
      return _iyz9kvht.GoogleIdTokenVerificationException.fromJson(data) as T;
    }
    if (t == _i0bj371b.MicrosoftAccessTokenVerificationException) {
      return _i0bj371b.MicrosoftAccessTokenVerificationException.fromJson(data)
          as T;
    }
    if (t == _ihzslz1a.PasskeyChallengeExpiredException) {
      return _ihzslz1a.PasskeyChallengeExpiredException.fromJson(data) as T;
    }
    if (t == _ihzssrx9.PasskeyChallengeNotFoundException) {
      return _ihzssrx9.PasskeyChallengeNotFoundException.fromJson(data) as T;
    }
    if (t == _itcmwg9u.PasskeyLoginRequest) {
      return _itcmwg9u.PasskeyLoginRequest.fromJson(data) as T;
    }
    if (t == _isvo2sb5.PasskeyPublicKeyNotFoundException) {
      return _isvo2sb5.PasskeyPublicKeyNotFoundException.fromJson(data) as T;
    }
    if (t == _izjoggd8.PasskeyRegistrationRequest) {
      return _izjoggd8.PasskeyRegistrationRequest.fromJson(data) as T;
    }
    if (t == _isc.getType<_ite257iv.AnonymousAccountBlockedException?>()) {
      return (data != null
              ? _ite257iv.AnonymousAccountBlockedException.fromJson(data)
              : null)
          as T;
    }
    if (t ==
        _isc.getType<_ig3ph7nw.AnonymousAccountBlockedExceptionReason?>()) {
      return (data != null
              ? _ig3ph7nw.AnonymousAccountBlockedExceptionReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ij1yj4f1.EmailAccountLoginException?>()) {
      return (data != null
              ? _ij1yj4f1.EmailAccountLoginException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ihd5znj2.EmailAccountLoginExceptionReason?>()) {
      return (data != null
              ? _ihd5znj2.EmailAccountLoginExceptionReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i7yyr103.EmailAccountPasswordResetException?>()) {
      return (data != null
              ? _i7yyr103.EmailAccountPasswordResetException.fromJson(data)
              : null)
          as T;
    }
    if (t ==
        _isc.getType<_io8tbstn.EmailAccountPasswordResetExceptionReason?>()) {
      return (data != null
              ? _io8tbstn.EmailAccountPasswordResetExceptionReason.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _isc.getType<_iqtw285f.EmailAccountRequestException?>()) {
      return (data != null
              ? _iqtw285f.EmailAccountRequestException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_isgeino8.EmailAccountRequestExceptionReason?>()) {
      return (data != null
              ? _isgeino8.EmailAccountRequestExceptionReason.fromJson(data)
              : null)
          as T;
    }
    if (t ==
        _isc.getType<_i92zrjf0.FacebookAccessTokenVerificationException?>()) {
      return (data != null
              ? _i92zrjf0.FacebookAccessTokenVerificationException.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _isc.getType<_imswdwet.FirebaseEmailNotVerifiedException?>()) {
      return (data != null
              ? _imswdwet.FirebaseEmailNotVerifiedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i14hfyiz.FirebaseIdTokenVerificationException?>()) {
      return (data != null
              ? _i14hfyiz.FirebaseIdTokenVerificationException.fromJson(data)
              : null)
          as T;
    }
    if (t ==
        _isc.getType<_i8u0zfwn.GitHubAccessTokenVerificationException?>()) {
      return (data != null
              ? _i8u0zfwn.GitHubAccessTokenVerificationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iyz9kvht.GoogleIdTokenVerificationException?>()) {
      return (data != null
              ? _iyz9kvht.GoogleIdTokenVerificationException.fromJson(data)
              : null)
          as T;
    }
    if (t ==
        _isc.getType<_i0bj371b.MicrosoftAccessTokenVerificationException?>()) {
      return (data != null
              ? _i0bj371b.MicrosoftAccessTokenVerificationException.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _isc.getType<_ihzslz1a.PasskeyChallengeExpiredException?>()) {
      return (data != null
              ? _ihzslz1a.PasskeyChallengeExpiredException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ihzssrx9.PasskeyChallengeNotFoundException?>()) {
      return (data != null
              ? _ihzssrx9.PasskeyChallengeNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_itcmwg9u.PasskeyLoginRequest?>()) {
      return (data != null
              ? _itcmwg9u.PasskeyLoginRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_isvo2sb5.PasskeyPublicKeyNotFoundException?>()) {
      return (data != null
              ? _isvo2sb5.PasskeyPublicKeyNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_izjoggd8.PasskeyRegistrationRequest?>()) {
      return (data != null
              ? _izjoggd8.PasskeyRegistrationRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<({_idt.ByteData challenge, _isc.UuidValue id})>()) {
      return (
            challenge: deserialize<_idt.ByteData>(
              ((data as Map)['n'] as Map)['challenge'],
            ),
            id: deserialize<_isc.UuidValue>(data['n']['id']),
          )
          as T;
    }
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ite257iv.AnonymousAccountBlockedException =>
        'AnonymousAccountBlockedException',
      _ig3ph7nw.AnonymousAccountBlockedExceptionReason =>
        'AnonymousAccountBlockedExceptionReason',
      _ij1yj4f1.EmailAccountLoginException => 'EmailAccountLoginException',
      _ihd5znj2.EmailAccountLoginExceptionReason =>
        'EmailAccountLoginExceptionReason',
      _i7yyr103.EmailAccountPasswordResetException =>
        'EmailAccountPasswordResetException',
      _io8tbstn.EmailAccountPasswordResetExceptionReason =>
        'EmailAccountPasswordResetExceptionReason',
      _iqtw285f.EmailAccountRequestException => 'EmailAccountRequestException',
      _isgeino8.EmailAccountRequestExceptionReason =>
        'EmailAccountRequestExceptionReason',
      _i92zrjf0.FacebookAccessTokenVerificationException =>
        'FacebookAccessTokenVerificationException',
      _imswdwet.FirebaseEmailNotVerifiedException =>
        'FirebaseEmailNotVerifiedException',
      _i14hfyiz.FirebaseIdTokenVerificationException =>
        'FirebaseIdTokenVerificationException',
      _i8u0zfwn.GitHubAccessTokenVerificationException =>
        'GitHubAccessTokenVerificationException',
      _iyz9kvht.GoogleIdTokenVerificationException =>
        'GoogleIdTokenVerificationException',
      _i0bj371b.MicrosoftAccessTokenVerificationException =>
        'MicrosoftAccessTokenVerificationException',
      _ihzslz1a.PasskeyChallengeExpiredException =>
        'PasskeyChallengeExpiredException',
      _ihzssrx9.PasskeyChallengeNotFoundException =>
        'PasskeyChallengeNotFoundException',
      _itcmwg9u.PasskeyLoginRequest => 'PasskeyLoginRequest',
      _isvo2sb5.PasskeyPublicKeyNotFoundException =>
        'PasskeyPublicKeyNotFoundException',
      _izjoggd8.PasskeyRegistrationRequest => 'PasskeyRegistrationRequest',
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
      case _ite257iv.AnonymousAccountBlockedException():
        return 'AnonymousAccountBlockedException';
      case _ig3ph7nw.AnonymousAccountBlockedExceptionReason():
        return 'AnonymousAccountBlockedExceptionReason';
      case _ij1yj4f1.EmailAccountLoginException():
        return 'EmailAccountLoginException';
      case _ihd5znj2.EmailAccountLoginExceptionReason():
        return 'EmailAccountLoginExceptionReason';
      case _i7yyr103.EmailAccountPasswordResetException():
        return 'EmailAccountPasswordResetException';
      case _io8tbstn.EmailAccountPasswordResetExceptionReason():
        return 'EmailAccountPasswordResetExceptionReason';
      case _iqtw285f.EmailAccountRequestException():
        return 'EmailAccountRequestException';
      case _isgeino8.EmailAccountRequestExceptionReason():
        return 'EmailAccountRequestExceptionReason';
      case _i92zrjf0.FacebookAccessTokenVerificationException():
        return 'FacebookAccessTokenVerificationException';
      case _imswdwet.FirebaseEmailNotVerifiedException():
        return 'FirebaseEmailNotVerifiedException';
      case _i14hfyiz.FirebaseIdTokenVerificationException():
        return 'FirebaseIdTokenVerificationException';
      case _i8u0zfwn.GitHubAccessTokenVerificationException():
        return 'GitHubAccessTokenVerificationException';
      case _iyz9kvht.GoogleIdTokenVerificationException():
        return 'GoogleIdTokenVerificationException';
      case _i0bj371b.MicrosoftAccessTokenVerificationException():
        return 'MicrosoftAccessTokenVerificationException';
      case _ihzslz1a.PasskeyChallengeExpiredException():
        return 'PasskeyChallengeExpiredException';
      case _ihzssrx9.PasskeyChallengeNotFoundException():
        return 'PasskeyChallengeNotFoundException';
      case _itcmwg9u.PasskeyLoginRequest():
        return 'PasskeyLoginRequest';
      case _isvo2sb5.PasskeyPublicKeyNotFoundException():
        return 'PasskeyPublicKeyNotFoundException';
      case _izjoggd8.PasskeyRegistrationRequest():
        return 'PasskeyRegistrationRequest';
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
      return deserialize<_ite257iv.AnonymousAccountBlockedException>(
        data['data'],
      );
    }
    if (dataClassName == 'AnonymousAccountBlockedExceptionReason') {
      return deserialize<_ig3ph7nw.AnonymousAccountBlockedExceptionReason>(
        data['data'],
      );
    }
    if (dataClassName == 'EmailAccountLoginException') {
      return deserialize<_ij1yj4f1.EmailAccountLoginException>(data['data']);
    }
    if (dataClassName == 'EmailAccountLoginExceptionReason') {
      return deserialize<_ihd5znj2.EmailAccountLoginExceptionReason>(
        data['data'],
      );
    }
    if (dataClassName == 'EmailAccountPasswordResetException') {
      return deserialize<_i7yyr103.EmailAccountPasswordResetException>(
        data['data'],
      );
    }
    if (dataClassName == 'EmailAccountPasswordResetExceptionReason') {
      return deserialize<_io8tbstn.EmailAccountPasswordResetExceptionReason>(
        data['data'],
      );
    }
    if (dataClassName == 'EmailAccountRequestException') {
      return deserialize<_iqtw285f.EmailAccountRequestException>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequestExceptionReason') {
      return deserialize<_isgeino8.EmailAccountRequestExceptionReason>(
        data['data'],
      );
    }
    if (dataClassName == 'FacebookAccessTokenVerificationException') {
      return deserialize<_i92zrjf0.FacebookAccessTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'FirebaseEmailNotVerifiedException') {
      return deserialize<_imswdwet.FirebaseEmailNotVerifiedException>(
        data['data'],
      );
    }
    if (dataClassName == 'FirebaseIdTokenVerificationException') {
      return deserialize<_i14hfyiz.FirebaseIdTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'GitHubAccessTokenVerificationException') {
      return deserialize<_i8u0zfwn.GitHubAccessTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'GoogleIdTokenVerificationException') {
      return deserialize<_iyz9kvht.GoogleIdTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'MicrosoftAccessTokenVerificationException') {
      return deserialize<_i0bj371b.MicrosoftAccessTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'PasskeyChallengeExpiredException') {
      return deserialize<_ihzslz1a.PasskeyChallengeExpiredException>(
        data['data'],
      );
    }
    if (dataClassName == 'PasskeyChallengeNotFoundException') {
      return deserialize<_ihzssrx9.PasskeyChallengeNotFoundException>(
        data['data'],
      );
    }
    if (dataClassName == 'PasskeyLoginRequest') {
      return deserialize<_itcmwg9u.PasskeyLoginRequest>(data['data']);
    }
    if (dataClassName == 'PasskeyPublicKeyNotFoundException') {
      return deserialize<_isvo2sb5.PasskeyPublicKeyNotFoundException>(
        data['data'],
      );
    }
    if (dataClassName == 'PasskeyRegistrationRequest') {
      return deserialize<_izjoggd8.PasskeyRegistrationRequest>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  Object? dynamicFieldToJson(
    Object? object, {
    bool forProtocol = false,
  }) {
    if ((object is List || object is Set || object is Map) ||
        getClassNameForObject(object) != null) {
      return super.dynamicFieldToJson(object, forProtocol: forProtocol);
    }
    for (final protocol in _hostProtocols) {
      final className = protocol.getClassNameForObject(object);
      if (className == null) continue;
      final host = protocol.getModuleName();
      final wrapped = {
        'className': className.contains('.') ? className : '$host.$className',
        'data': object,
      };
      return forProtocol
          ? _isc.SerializationManager.toEncodableForProtocol(wrapped)
          : _isc.SerializationManager.toEncodable(wrapped);
    }
    return super.dynamicFieldToJson(object, forProtocol: forProtocol);
  }

  @override
  dynamic deserializeDynamicFieldValue(Object? value) {
    if (value == null) return null;
    if (value is! Map<String, dynamic> || value['className'] is! String) {
      throw FormatException(
        'Dynamic fields are encoded as a Map with className and data, but got '
        '${value.runtimeType} instead.',
      );
    }
    final className = value['className'] as String;
    for (final protocol in _hostProtocols) {
      final host = protocol.getModuleName();
      final hostPrefix = '$host.';
      if (className.startsWith(hostPrefix)) {
        final strippedClassName = className.substring(hostPrefix.length);
        if (strippedClassName.contains('.')) {
          throw FormatException(
            'Dynamic field className must not use multiple prefixes: $className',
          );
        }
        final hostData = Map<String, dynamic>.from(value);
        hostData['className'] = strippedClassName;
        return protocol.deserializeByClassName(hostData);
      }
    }
    if (className.contains('.')) {
      for (final protocol in _hostProtocols) {
        try {
          return protocol.deserializeByClassName(value);
        } on _isc.DeserializationClassNameNotFoundException catch (_) {}
      }
    }
    return deserializeByClassName(value);
  }

  @override
  String getModuleName() => 'serverpod_auth_idp';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    if (record is ({_idt.ByteData challenge, _isc.UuidValue id})) {
      return {
        "n": {
          "challenge": record.challenge.toJson(),
          "id": record.id.toJson(),
        },
      };
    }
    try {
      return _iacc.Protocol().mapRecordToJson(record);
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
