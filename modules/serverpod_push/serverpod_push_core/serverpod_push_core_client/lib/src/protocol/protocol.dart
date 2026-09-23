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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'push_ack_type.dart' as _i70pgzj6;
import 'push_delivery_outcome.dart' as _i7pp3ych;
import 'push_device_target.dart' as _i0dvde7a;
import 'push_message.dart' as _ivxt7ghq;
import 'push_platform.dart' as _igl09s3h;
import 'push_priority.dart' as _i393k73i;
import 'push_send_result.dart' as _ie94wjtz;
export 'push_ack_type.dart';
export 'push_delivery_outcome.dart';
export 'push_device_target.dart';
export 'push_message.dart';
export 'push_platform.dart';
export 'push_priority.dart';
export 'push_send_result.dart';
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
    if (!className.startsWith('serverpod_push_core.')) return className;
    return className.substring(20);
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

    if (t == _i70pgzj6.PushAckType) {
      return _i70pgzj6.PushAckType.fromJson(data) as T;
    }
    if (t == _i7pp3ych.PushDeliveryOutcome) {
      return _i7pp3ych.PushDeliveryOutcome.fromJson(data) as T;
    }
    if (t == _i0dvde7a.PushDeviceTarget) {
      return _i0dvde7a.PushDeviceTarget.fromJson(data) as T;
    }
    if (t == _ivxt7ghq.PushMessage) {
      return _ivxt7ghq.PushMessage.fromJson(data) as T;
    }
    if (t == _igl09s3h.PushPlatform) {
      return _igl09s3h.PushPlatform.fromJson(data) as T;
    }
    if (t == _i393k73i.PushPriority) {
      return _i393k73i.PushPriority.fromJson(data) as T;
    }
    if (t == _ie94wjtz.PushSendResult) {
      return _ie94wjtz.PushSendResult.fromJson(data) as T;
    }
    if (t == _isc.getType<_i70pgzj6.PushAckType?>()) {
      return (data != null ? _i70pgzj6.PushAckType.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i7pp3ych.PushDeliveryOutcome?>()) {
      return (data != null
              ? _i7pp3ych.PushDeliveryOutcome.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i0dvde7a.PushDeviceTarget?>()) {
      return (data != null ? _i0dvde7a.PushDeviceTarget.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ivxt7ghq.PushMessage?>()) {
      return (data != null ? _ivxt7ghq.PushMessage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_igl09s3h.PushPlatform?>()) {
      return (data != null ? _igl09s3h.PushPlatform.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i393k73i.PushPriority?>()) {
      return (data != null ? _i393k73i.PushPriority.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ie94wjtz.PushSendResult?>()) {
      return (data != null ? _ie94wjtz.PushSendResult.fromJson(data) : null)
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i70pgzj6.PushAckType => 'PushAckType',
      _i7pp3ych.PushDeliveryOutcome => 'PushDeliveryOutcome',
      _i0dvde7a.PushDeviceTarget => 'PushDeviceTarget',
      _ivxt7ghq.PushMessage => 'PushMessage',
      _igl09s3h.PushPlatform => 'PushPlatform',
      _i393k73i.PushPriority => 'PushPriority',
      _ie94wjtz.PushSendResult => 'PushSendResult',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'serverpod_push_core.',
        '',
      );
    }

    switch (data) {
      case _i70pgzj6.PushAckType():
        return 'PushAckType';
      case _i7pp3ych.PushDeliveryOutcome():
        return 'PushDeliveryOutcome';
      case _i0dvde7a.PushDeviceTarget():
        return 'PushDeviceTarget';
      case _ivxt7ghq.PushMessage():
        return 'PushMessage';
      case _igl09s3h.PushPlatform():
        return 'PushPlatform';
      case _i393k73i.PushPriority():
        return 'PushPriority';
      case _ie94wjtz.PushSendResult():
        return 'PushSendResult';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'PushAckType') {
      return deserialize<_i70pgzj6.PushAckType>(data['data']);
    }
    if (dataClassName == 'PushDeliveryOutcome') {
      return deserialize<_i7pp3ych.PushDeliveryOutcome>(data['data']);
    }
    if (dataClassName == 'PushDeviceTarget') {
      return deserialize<_i0dvde7a.PushDeviceTarget>(data['data']);
    }
    if (dataClassName == 'PushMessage') {
      return deserialize<_ivxt7ghq.PushMessage>(data['data']);
    }
    if (dataClassName == 'PushPlatform') {
      return deserialize<_igl09s3h.PushPlatform>(data['data']);
    }
    if (dataClassName == 'PushPriority') {
      return deserialize<_i393k73i.PushPriority>(data['data']);
    }
    if (dataClassName == 'PushSendResult') {
      return deserialize<_ie94wjtz.PushSendResult>(data['data']);
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
  String getModuleName() => 'serverpod_push_core';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
