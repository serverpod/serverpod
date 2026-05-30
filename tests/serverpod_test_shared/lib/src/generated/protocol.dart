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
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;
import 'shared/container.dart' as _i2;
import 'shared/dynamic_on_shared.dart' as _i3;
import 'shared/enum.dart' as _i4;
import 'shared/exception.dart' as _i5;
import 'shared/subclass.dart' as _i6;
import 'shared/model.dart' as _i7;
import 'shared/sealed/parent.dart' as _i8;
export 'shared/container.dart';
export 'shared/dynamic_on_shared.dart';
export 'shared/enum.dart';
export 'shared/exception.dart';
export 'shared/subclass.dart';
export 'shared/model.dart';
export 'shared/sealed/parent.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  final Set<_i1.SerializationManager> _hostProtocols = {};

  static final Map<Type, dynamic Function(dynamic, Protocol)> _deserializers =
      _buildDeserializers();

  static Map<Type, dynamic Function(dynamic, Protocol)> _buildDeserializers() {
    final map = <Type, dynamic Function(dynamic, Protocol)>{};
    map[_i2.SharedContainer] = (data, protocol) =>
        _i2.SharedContainer.fromJson(data);
    map[_i3.DynamicOnShared] = (data, protocol) =>
        _i3.DynamicOnShared.fromJson(data);
    map[_i4.SharedEnum] = (data, protocol) => _i4.SharedEnum.fromJson(data);
    map[_i5.SharedException] = (data, protocol) =>
        _i5.SharedException.fromJson(data);
    map[_i6.SharedSubclass] = (data, protocol) =>
        _i6.SharedSubclass.fromJson(data);
    map[_i7.SharedModel] = (data, protocol) => _i7.SharedModel.fromJson(data);
    map[_i8.SharedSealedChild] = (data, protocol) =>
        _i8.SharedSealedChild.fromJson(data);
    map[_i1.getType<_i2.SharedContainer?>()] = (data, protocol) =>
        (data != null ? _i2.SharedContainer.fromJson(data) : null);
    map[_i1.getType<_i3.DynamicOnShared?>()] = (data, protocol) =>
        (data != null ? _i3.DynamicOnShared.fromJson(data) : null);
    map[_i1.getType<_i4.SharedEnum?>()] = (data, protocol) =>
        (data != null ? _i4.SharedEnum.fromJson(data) : null);
    map[_i1.getType<_i5.SharedException?>()] = (data, protocol) =>
        (data != null ? _i5.SharedException.fromJson(data) : null);
    map[_i1.getType<_i6.SharedSubclass?>()] = (data, protocol) =>
        (data != null ? _i6.SharedSubclass.fromJson(data) : null);
    map[_i1.getType<_i7.SharedModel?>()] = (data, protocol) =>
        (data != null ? _i7.SharedModel.fromJson(data) : null);
    map[_i1.getType<_i8.SharedSealedChild?>()] = (data, protocol) =>
        (data != null ? _i8.SharedSealedChild.fromJson(data) : null);
    map[dynamic] = (data, protocol) => deserializeDynamicFieldValue(data) as T;
    return map;
  }

  void registerHostProtocol(
    String projectName,
    _i1.SerializationManager protocol,
  ) {
    _hostProtocols.add(protocol);
  }

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
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

    final fn = _deserializers[t];
    if (fn != null) {
      return fn(data, this) as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.SharedContainer => 'SharedContainer',
      _i3.DynamicOnShared => 'DynamicOnShared',
      _i4.SharedEnum => 'SharedEnum',
      _i5.SharedException => 'SharedException',
      _i6.SharedSubclass => 'SharedSubclass',
      _i7.SharedModel => 'SharedModel',
      _i8.SharedSealedChild => 'SharedSealedChild',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'serverpod_test.',
        '',
      );
    }

    switch (data) {
      case _i2.SharedContainer():
        return 'SharedContainer';
      case _i3.DynamicOnShared():
        return 'DynamicOnShared';
      case _i4.SharedEnum():
        return 'SharedEnum';
      case _i5.SharedException():
        return 'SharedException';
      case _i6.SharedSubclass():
        return 'SharedSubclass';
      case _i7.SharedModel():
        return 'SharedModel';
      case _i8.SharedSealedChild():
        return 'SharedSealedChild';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'SharedContainer') {
      return deserialize<_i2.SharedContainer>(data['data']);
    }
    if (dataClassName == 'DynamicOnShared') {
      return deserialize<_i3.DynamicOnShared>(data['data']);
    }
    if (dataClassName == 'SharedEnum') {
      return deserialize<_i4.SharedEnum>(data['data']);
    }
    if (dataClassName == 'SharedException') {
      return deserialize<_i5.SharedException>(data['data']);
    }
    if (dataClassName == 'SharedSubclass') {
      return deserialize<_i6.SharedSubclass>(data['data']);
    }
    if (dataClassName == 'SharedModel') {
      return deserialize<_i7.SharedModel>(data['data']);
    }
    if (dataClassName == 'SharedSealedChild') {
      return deserialize<_i8.SharedSealedChild>(data['data']);
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
          ? _i1.SerializationManager.toEncodableForProtocol(wrapped)
          : _i1.SerializationManager.toEncodable(wrapped);
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
        } on FormatException catch (_) {}
      }
    }
    return deserializeByClassName(value);
  }

  @override
  String getModuleName() => 'serverpod_test';

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
