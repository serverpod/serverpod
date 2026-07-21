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
import 'package:serverpod_database/serverpod_database.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i2;
import 'shared/container.dart' as _i3;
import 'shared/dynamic_on_shared.dart' as _i4;
import 'shared/enum.dart' as _i5;
import 'shared/exception.dart' as _i6;
import 'shared/exception/shared_extended_app_exception.dart' as _i7;
import 'shared/exception/shared_base_app_exception.dart' as _i8;
import 'shared/subclass.dart' as _i9;
import 'shared/model.dart' as _i10;
import 'shared/sealed/parent.dart' as _i11;
import 'shared/sealed/exception/shared_sealed_app_exception.dart' as _i12;
import 'shared/shared_object_with_sealed_exception.dart' as _i13;
import 'shared/shared_table_record.dart' as _i14;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i15;
export 'shared/container.dart';
export 'shared/dynamic_on_shared.dart';
export 'shared/enum.dart';
export 'shared/exception.dart';
export 'shared/exception/shared_extended_app_exception.dart';
export 'shared/exception/shared_base_app_exception.dart';
export 'shared/subclass.dart';
export 'shared/model.dart';
export 'shared/sealed/exception/shared_sealed_app_exception.dart';
export 'shared/sealed/parent.dart';
export 'shared/shared_object_with_sealed_exception.dart';
export 'shared/shared_table_record.dart';

class Protocol extends _i1.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  final Set<_i2.SerializationManager> _hostProtocols = {};

  static List<_i1.TableDefinition> get targetTableDefinitions => [
    _i1.TableDefinition(
      name: 'shared_table_record',
      dartName: 'SharedTableRecord',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i1.ColumnDefinition(
          name: 'sharedEnum',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'SharedEnum',
        ),
        _i1.ColumnDefinition(
          name: 'sharedSubclass',
          columnType: _i1.ColumnType.json,
          isNullable: true,
          dartType: 'SharedSubclass?',
        ),
        _i1.ColumnDefinition(
          name: 'itemCount',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
  ];

  void registerHostProtocol(
    String projectName,
    _i2.SerializationManager protocol,
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

    if (t == _i3.SharedContainer) {
      return _i3.SharedContainer.fromJson(data) as T;
    }
    if (t == _i4.DynamicOnShared) {
      return _i4.DynamicOnShared.fromJson(data) as T;
    }
    if (t == _i5.SharedEnum) {
      return _i5.SharedEnum.fromJson(data) as T;
    }
    if (t == _i6.SharedException) {
      return _i6.SharedException.fromJson(data) as T;
    }
    if (t == _i7.SharedExtendedAppException) {
      return _i7.SharedExtendedAppException.fromJson(data) as T;
    }
    if (t == _i8.SharedBaseAppException) {
      return _i8.SharedBaseAppException.fromJson(data) as T;
    }
    if (t == _i9.SharedSubclass) {
      return _i9.SharedSubclass.fromJson(data) as T;
    }
    if (t == _i10.SharedModel) {
      return _i10.SharedModel.fromJson(data) as T;
    }
    if (t == _i11.SharedSealedChild) {
      return _i11.SharedSealedChild.fromJson(data) as T;
    }
    if (t == _i12.SharedNotFoundException) {
      return _i12.SharedNotFoundException.fromJson(data) as T;
    }
    if (t == _i12.SharedValidationException) {
      return _i12.SharedValidationException.fromJson(data) as T;
    }
    if (t == _i13.SharedObjectWithSealedException) {
      return _i13.SharedObjectWithSealedException.fromJson(data) as T;
    }
    if (t == _i14.SharedTableRecord) {
      return _i14.SharedTableRecord.fromJson(data) as T;
    }
    if (t == _i2.getType<_i3.SharedContainer?>()) {
      return (data != null ? _i3.SharedContainer.fromJson(data) : null) as T;
    }
    if (t == _i2.getType<_i4.DynamicOnShared?>()) {
      return (data != null ? _i4.DynamicOnShared.fromJson(data) : null) as T;
    }
    if (t == _i2.getType<_i5.SharedEnum?>()) {
      return (data != null ? _i5.SharedEnum.fromJson(data) : null) as T;
    }
    if (t == _i2.getType<_i6.SharedException?>()) {
      return (data != null ? _i6.SharedException.fromJson(data) : null) as T;
    }
    if (t == _i2.getType<_i7.SharedExtendedAppException?>()) {
      return (data != null
              ? _i7.SharedExtendedAppException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i2.getType<_i8.SharedBaseAppException?>()) {
      return (data != null ? _i8.SharedBaseAppException.fromJson(data) : null)
          as T;
    }
    if (t == _i2.getType<_i9.SharedSubclass?>()) {
      return (data != null ? _i9.SharedSubclass.fromJson(data) : null) as T;
    }
    if (t == _i2.getType<_i10.SharedModel?>()) {
      return (data != null ? _i10.SharedModel.fromJson(data) : null) as T;
    }
    if (t == _i2.getType<_i11.SharedSealedChild?>()) {
      return (data != null ? _i11.SharedSealedChild.fromJson(data) : null) as T;
    }
    if (t == _i2.getType<_i12.SharedNotFoundException?>()) {
      return (data != null ? _i12.SharedNotFoundException.fromJson(data) : null)
          as T;
    }
    if (t == _i2.getType<_i12.SharedValidationException?>()) {
      return (data != null
              ? _i12.SharedValidationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i2.getType<_i13.SharedObjectWithSealedException?>()) {
      return (data != null
              ? _i13.SharedObjectWithSealedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i2.getType<_i14.SharedTableRecord?>()) {
      return (data != null ? _i14.SharedTableRecord.fromJson(data) : null) as T;
    }
    if (t == dynamic) {
      return deserializeDynamicFieldValue(data) as T;
    }
    if (t == List<_i15.SharedSealedAppException>) {
      return (data as List)
              .map((e) => deserialize<_i15.SharedSealedAppException>(e))
              .toList()
          as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i3.SharedContainer => 'SharedContainer',
      _i4.DynamicOnShared => 'DynamicOnShared',
      _i5.SharedEnum => 'SharedEnum',
      _i6.SharedException => 'SharedException',
      _i7.SharedExtendedAppException => 'SharedExtendedAppException',
      _i8.SharedBaseAppException => 'SharedBaseAppException',
      _i9.SharedSubclass => 'SharedSubclass',
      _i10.SharedModel => 'SharedModel',
      _i11.SharedSealedChild => 'SharedSealedChild',
      _i12.SharedNotFoundException => 'SharedNotFoundException',
      _i12.SharedValidationException => 'SharedValidationException',
      _i13.SharedObjectWithSealedException => 'SharedObjectWithSealedException',
      _i14.SharedTableRecord => 'SharedTableRecord',
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
      case _i3.SharedContainer():
        return 'SharedContainer';
      case _i4.DynamicOnShared():
        return 'DynamicOnShared';
      case _i5.SharedEnum():
        return 'SharedEnum';
      case _i6.SharedException():
        return 'SharedException';
      case _i7.SharedExtendedAppException():
        return 'SharedExtendedAppException';
      case _i8.SharedBaseAppException():
        return 'SharedBaseAppException';
      case _i9.SharedSubclass():
        return 'SharedSubclass';
      case _i10.SharedModel():
        return 'SharedModel';
      case _i11.SharedSealedChild():
        return 'SharedSealedChild';
      case _i12.SharedNotFoundException():
        return 'SharedNotFoundException';
      case _i12.SharedValidationException():
        return 'SharedValidationException';
      case _i13.SharedObjectWithSealedException():
        return 'SharedObjectWithSealedException';
      case _i14.SharedTableRecord():
        return 'SharedTableRecord';
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
      return deserialize<_i3.SharedContainer>(data['data']);
    }
    if (dataClassName == 'DynamicOnShared') {
      return deserialize<_i4.DynamicOnShared>(data['data']);
    }
    if (dataClassName == 'SharedEnum') {
      return deserialize<_i5.SharedEnum>(data['data']);
    }
    if (dataClassName == 'SharedException') {
      return deserialize<_i6.SharedException>(data['data']);
    }
    if (dataClassName == 'SharedExtendedAppException') {
      return deserialize<_i7.SharedExtendedAppException>(data['data']);
    }
    if (dataClassName == 'SharedBaseAppException') {
      return deserialize<_i8.SharedBaseAppException>(data['data']);
    }
    if (dataClassName == 'SharedSubclass') {
      return deserialize<_i9.SharedSubclass>(data['data']);
    }
    if (dataClassName == 'SharedModel') {
      return deserialize<_i10.SharedModel>(data['data']);
    }
    if (dataClassName == 'SharedSealedChild') {
      return deserialize<_i11.SharedSealedChild>(data['data']);
    }
    if (dataClassName == 'SharedNotFoundException') {
      return deserialize<_i12.SharedNotFoundException>(data['data']);
    }
    if (dataClassName == 'SharedValidationException') {
      return deserialize<_i12.SharedValidationException>(data['data']);
    }
    if (dataClassName == 'SharedObjectWithSealedException') {
      return deserialize<_i13.SharedObjectWithSealedException>(data['data']);
    }
    if (dataClassName == 'SharedTableRecord') {
      return deserialize<_i14.SharedTableRecord>(data['data']);
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
          ? _i2.SerializationManager.toEncodableForProtocol(wrapped)
          : _i2.SerializationManager.toEncodable(wrapped);
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
  _i1.Table? getTableForType(Type t) {
    switch (t) {
      case _i14.SharedTableRecord:
        return _i14.SharedTableRecord.t;
    }
    return null;
  }

  @override
  List<_i1.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

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
