/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'refresh_token_expired_exception.dart' as _i2;
import 'refresh_token_invalid_secret_exception.dart' as _i3;
import 'refresh_token_malformed_exception.dart' as _i4;
import 'refresh_token_not_found_exception.dart' as _i5;
import 'token_pair.dart' as _i6;
import 'package:serverpod_auth_user_client/serverpod_auth_user_client.dart'
    as _i7;
export 'refresh_token_expired_exception.dart';
export 'refresh_token_invalid_secret_exception.dart';
export 'refresh_token_malformed_exception.dart';
export 'refresh_token_not_found_exception.dart';
export 'token_pair.dart';
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
    if (t == _i2.RefreshTokenExpiredException) {
      return _i2.RefreshTokenExpiredException.fromJson(data) as T;
    }
    if (t == _i3.RefreshTokenInvalidSecretException) {
      return _i3.RefreshTokenInvalidSecretException.fromJson(data) as T;
    }
    if (t == _i4.RefreshTokenMalformedException) {
      return _i4.RefreshTokenMalformedException.fromJson(data) as T;
    }
    if (t == _i5.RefreshTokenNotFoundException) {
      return _i5.RefreshTokenNotFoundException.fromJson(data) as T;
    }
    if (t == _i6.TokenPair) {
      return _i6.TokenPair.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.RefreshTokenExpiredException?>()) {
      return (data != null
          ? _i2.RefreshTokenExpiredException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i3.RefreshTokenInvalidSecretException?>()) {
      return (data != null
          ? _i3.RefreshTokenInvalidSecretException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.RefreshTokenMalformedException?>()) {
      return (data != null
          ? _i4.RefreshTokenMalformedException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i5.RefreshTokenNotFoundException?>()) {
      return (data != null
          ? _i5.RefreshTokenNotFoundException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i6.TokenPair?>()) {
      return (data != null ? _i6.TokenPair.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<(String, String)>()) {
      return (
        deserialize<String>(((data as Map)['p'] as List)[0]),
        deserialize<String>(data['p'][1]),
      ) as T;
    }
    try {
      return _i7.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.RefreshTokenExpiredException) {
      return 'RefreshTokenExpiredException';
    }
    if (data is _i3.RefreshTokenInvalidSecretException) {
      return 'RefreshTokenInvalidSecretException';
    }
    if (data is _i4.RefreshTokenMalformedException) {
      return 'RefreshTokenMalformedException';
    }
    if (data is _i5.RefreshTokenNotFoundException) {
      return 'RefreshTokenNotFoundException';
    }
    if (data is _i6.TokenPair) {
      return 'TokenPair';
    }
    className = _i7.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_user.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'RefreshTokenExpiredException') {
      return deserialize<_i2.RefreshTokenExpiredException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenInvalidSecretException') {
      return deserialize<_i3.RefreshTokenInvalidSecretException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenMalformedException') {
      return deserialize<_i4.RefreshTokenMalformedException>(data['data']);
    }
    if (dataClassName == 'RefreshTokenNotFoundException') {
      return deserialize<_i5.RefreshTokenNotFoundException>(data['data']);
    }
    if (dataClassName == 'TokenPair') {
      return deserialize<_i6.TokenPair>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_user.')) {
      data['className'] = dataClassName.substring(20);
      return _i7.Protocol().deserializeByClassName(data);
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
  if (record is (String, String)) {
    return {
      "p": [
        record.$1,
        record.$2,
      ],
    };
  }
  throw Exception('Unsupported record type ${record.runtimeType}');
}

/// Maps container types (like [List], [Map], [Set]) containing [Record]s to their JSON representation.
///
/// It should not be called for [SerializableModel] types. These handle the "[Record] in container" mapping internally already.
///
/// It is only supposed to be called from generated protocol code.
///
/// Returns either a `List<dynamic>` (for List, Sets, and Maps with non-String keys) or a `Map<String, dynamic>` in case the input was a `Map<String, …>`.
Object? mapRecordContainingContainerToJson(Object obj) {
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
      Iterable iterable => mapRecordContainingContainerToJson(iterable),
      Map map => mapRecordContainingContainerToJson(map),
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
