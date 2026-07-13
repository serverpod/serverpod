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
import 'shared/enum.dart' as _i3;
import 'shared/subclass.dart' as _i4;
import 'shared/model.dart' as _i5;
import 'shared/shared_table_record.dart' as _i6;
import 'package:serverpod_database/serverpod_database.dart' as _i7;
export 'shared/enum.dart';
export 'shared/subclass.dart';
export 'shared/model.dart';
export 'shared/shared_table_record.dart';

class Protocol extends _i1.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i1.TableDefinition> targetTableDefinitions = [
    _i1.TableDefinition(
      name: 'shared_table_record',
      dartName: 'SharedTableRecord',
      schema: 'public',
      module: 'serverpod_test_sqlite',
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

  final Set<_i2.SerializationManager> _hostProtocols = {};

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

    if (t == _i3.SharedEnum) {
      return _i3.SharedEnum.fromJson(data) as T;
    }
    if (t == _i4.SharedSubclass) {
      return _i4.SharedSubclass.fromJson(data) as T;
    }
    if (t == _i5.SharedModel) {
      return _i5.SharedModel.fromJson(data) as T;
    }
    if (t == _i6.SharedTableRecord) {
      return _i6.SharedTableRecord.fromJson(data) as T;
    }
    if (t == _i2.getType<_i3.SharedEnum?>()) {
      return (data != null ? _i3.SharedEnum.fromJson(data) : null) as T;
    }
    if (t == _i2.getType<_i4.SharedSubclass?>()) {
      return (data != null ? _i4.SharedSubclass.fromJson(data) : null) as T;
    }
    if (t == _i2.getType<_i5.SharedModel?>()) {
      return (data != null ? _i5.SharedModel.fromJson(data) : null) as T;
    }
    if (t == _i2.getType<_i6.SharedTableRecord?>()) {
      return (data != null ? _i6.SharedTableRecord.fromJson(data) : null) as T;
    }
    try {
      return _i7.Protocol().deserialize<T>(data, t);
    } on _i2.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i3.SharedEnum => 'SharedEnum',
      _i4.SharedSubclass => 'SharedSubclass',
      _i5.SharedModel => 'SharedModel',
      _i6.SharedTableRecord => 'SharedTableRecord',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'serverpod_test_sqlite.',
        '',
      );
    }

    switch (data) {
      case _i3.SharedEnum():
        return 'SharedEnum';
      case _i4.SharedSubclass():
        return 'SharedSubclass';
      case _i5.SharedModel():
        return 'SharedModel';
      case _i6.SharedTableRecord():
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
    if (dataClassName == 'SharedEnum') {
      return deserialize<_i3.SharedEnum>(data['data']);
    }
    if (dataClassName == 'SharedSubclass') {
      return deserialize<_i4.SharedSubclass>(data['data']);
    }
    if (dataClassName == 'SharedModel') {
      return deserialize<_i5.SharedModel>(data['data']);
    }
    if (dataClassName == 'SharedTableRecord') {
      return deserialize<_i6.SharedTableRecord>(data['data']);
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
      case _i6.SharedTableRecord:
        return _i6.SharedTableRecord.t;
    }
    return null;
  }

  @override
  List<_i1.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_test_sqlite';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i7.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
