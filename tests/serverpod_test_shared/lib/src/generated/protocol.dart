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
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _ilwf0zl1;
import 'shared/container.dart' as _is2cqpjk;
import 'shared/dynamic_on_shared.dart' as _ifwqhlpv;
import 'shared/enum.dart' as _i1mrs6ww;
import 'shared/exception.dart' as _i20a36el;
import 'shared/exception/shared_base_app_exception.dart' as _ir5o94j1;
import 'shared/exception/shared_extended_app_exception.dart' as _iw04p5m5;
import 'shared/model.dart' as _iwajn61k;
import 'shared/sealed/exception/shared_sealed_app_exception.dart' as _ieg0jtrp;
import 'shared/sealed/parent.dart' as _iag9521n;
import 'shared/shared_object_with_sealed_exception.dart' as _i4mzuyso;
import 'shared/shared_table_record.dart' as _itms6rpy;
import 'shared/subclass.dart' as _iuvt222f;
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

class Protocol extends _isd.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  final Set<_iss.SerializationManager> _hostProtocols = {};

  static List<_isd.TableDefinition> get targetTableDefinitions => [
    _isd.TableDefinition(
      name: 'shared_table_record',
      dartName: 'SharedTableRecord',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'sharedEnum',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'serverpod_test_shared:SharedEnum',
        ),
        _isd.ColumnDefinition(
          name: 'sharedSubclass',
          columnType: _isd.ColumnType.json,
          isNullable: true,
          dartType: 'serverpod_test_shared:SharedSubclass?',
        ),
        _isd.ColumnDefinition(
          name: 'itemCount',
          columnType: _isd.ColumnType.bigint,
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
    _iss.SerializationManager protocol,
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

    if (t == _is2cqpjk.SharedContainer) {
      return _is2cqpjk.SharedContainer.fromJson(data) as T;
    }
    if (t == _ifwqhlpv.DynamicOnShared) {
      return _ifwqhlpv.DynamicOnShared.fromJson(data) as T;
    }
    if (t == _i1mrs6ww.SharedEnum) {
      return _i1mrs6ww.SharedEnum.fromJson(data) as T;
    }
    if (t == _i20a36el.SharedException) {
      return _i20a36el.SharedException.fromJson(data) as T;
    }
    if (t == _iw04p5m5.SharedExtendedAppException) {
      return _iw04p5m5.SharedExtendedAppException.fromJson(data) as T;
    }
    if (t == _ir5o94j1.SharedBaseAppException) {
      return _ir5o94j1.SharedBaseAppException.fromJson(data) as T;
    }
    if (t == _iuvt222f.SharedSubclass) {
      return _iuvt222f.SharedSubclass.fromJson(data) as T;
    }
    if (t == _iwajn61k.SharedModel) {
      return _iwajn61k.SharedModel.fromJson(data) as T;
    }
    if (t == _iag9521n.SharedSealedChild) {
      return _iag9521n.SharedSealedChild.fromJson(data) as T;
    }
    if (t == _ieg0jtrp.SharedNotFoundException) {
      return _ieg0jtrp.SharedNotFoundException.fromJson(data) as T;
    }
    if (t == _ieg0jtrp.SharedValidationException) {
      return _ieg0jtrp.SharedValidationException.fromJson(data) as T;
    }
    if (t == _i4mzuyso.SharedObjectWithSealedException) {
      return _i4mzuyso.SharedObjectWithSealedException.fromJson(data) as T;
    }
    if (t == _itms6rpy.SharedTableRecord) {
      return _itms6rpy.SharedTableRecord.fromJson(data) as T;
    }
    if (t == _iss.getType<_is2cqpjk.SharedContainer?>()) {
      return (data != null ? _is2cqpjk.SharedContainer.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_ifwqhlpv.DynamicOnShared?>()) {
      return (data != null ? _ifwqhlpv.DynamicOnShared.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_i1mrs6ww.SharedEnum?>()) {
      return (data != null ? _i1mrs6ww.SharedEnum.fromJson(data) : null) as T;
    }
    if (t == _iss.getType<_i20a36el.SharedException?>()) {
      return (data != null ? _i20a36el.SharedException.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_iw04p5m5.SharedExtendedAppException?>()) {
      return (data != null
              ? _iw04p5m5.SharedExtendedAppException.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_ir5o94j1.SharedBaseAppException?>()) {
      return (data != null
              ? _ir5o94j1.SharedBaseAppException.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_iuvt222f.SharedSubclass?>()) {
      return (data != null ? _iuvt222f.SharedSubclass.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_iwajn61k.SharedModel?>()) {
      return (data != null ? _iwajn61k.SharedModel.fromJson(data) : null) as T;
    }
    if (t == _iss.getType<_iag9521n.SharedSealedChild?>()) {
      return (data != null ? _iag9521n.SharedSealedChild.fromJson(data) : null)
          as T;
    }
    if (t == _iss.getType<_ieg0jtrp.SharedNotFoundException?>()) {
      return (data != null
              ? _ieg0jtrp.SharedNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_ieg0jtrp.SharedValidationException?>()) {
      return (data != null
              ? _ieg0jtrp.SharedValidationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_i4mzuyso.SharedObjectWithSealedException?>()) {
      return (data != null
              ? _i4mzuyso.SharedObjectWithSealedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _iss.getType<_itms6rpy.SharedTableRecord?>()) {
      return (data != null ? _itms6rpy.SharedTableRecord.fromJson(data) : null)
          as T;
    }
    if (t == dynamic) {
      return deserializeDynamicFieldValue(data) as T;
    }
    if (t == List<_ilwf0zl1.SharedSealedAppException>) {
      return (data as List)
              .map((e) => deserialize<_ilwf0zl1.SharedSealedAppException>(e))
              .toList()
          as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _is2cqpjk.SharedContainer => 'SharedContainer',
      _ifwqhlpv.DynamicOnShared => 'DynamicOnShared',
      _i1mrs6ww.SharedEnum => 'SharedEnum',
      _i20a36el.SharedException => 'SharedException',
      _iw04p5m5.SharedExtendedAppException => 'SharedExtendedAppException',
      _ir5o94j1.SharedBaseAppException => 'SharedBaseAppException',
      _iuvt222f.SharedSubclass => 'SharedSubclass',
      _iwajn61k.SharedModel => 'SharedModel',
      _iag9521n.SharedSealedChild => 'SharedSealedChild',
      _ieg0jtrp.SharedNotFoundException => 'SharedNotFoundException',
      _ieg0jtrp.SharedValidationException => 'SharedValidationException',
      _i4mzuyso.SharedObjectWithSealedException =>
        'SharedObjectWithSealedException',
      _itms6rpy.SharedTableRecord => 'SharedTableRecord',
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
      case _is2cqpjk.SharedContainer():
        return 'SharedContainer';
      case _ifwqhlpv.DynamicOnShared():
        return 'DynamicOnShared';
      case _i1mrs6ww.SharedEnum():
        return 'SharedEnum';
      case _i20a36el.SharedException():
        return 'SharedException';
      case _iw04p5m5.SharedExtendedAppException():
        return 'SharedExtendedAppException';
      case _ir5o94j1.SharedBaseAppException():
        return 'SharedBaseAppException';
      case _iuvt222f.SharedSubclass():
        return 'SharedSubclass';
      case _iwajn61k.SharedModel():
        return 'SharedModel';
      case _iag9521n.SharedSealedChild():
        return 'SharedSealedChild';
      case _ieg0jtrp.SharedNotFoundException():
        return 'SharedNotFoundException';
      case _ieg0jtrp.SharedValidationException():
        return 'SharedValidationException';
      case _i4mzuyso.SharedObjectWithSealedException():
        return 'SharedObjectWithSealedException';
      case _itms6rpy.SharedTableRecord():
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
      return deserialize<_is2cqpjk.SharedContainer>(data['data']);
    }
    if (dataClassName == 'DynamicOnShared') {
      return deserialize<_ifwqhlpv.DynamicOnShared>(data['data']);
    }
    if (dataClassName == 'SharedEnum') {
      return deserialize<_i1mrs6ww.SharedEnum>(data['data']);
    }
    if (dataClassName == 'SharedException') {
      return deserialize<_i20a36el.SharedException>(data['data']);
    }
    if (dataClassName == 'SharedExtendedAppException') {
      return deserialize<_iw04p5m5.SharedExtendedAppException>(data['data']);
    }
    if (dataClassName == 'SharedBaseAppException') {
      return deserialize<_ir5o94j1.SharedBaseAppException>(data['data']);
    }
    if (dataClassName == 'SharedSubclass') {
      return deserialize<_iuvt222f.SharedSubclass>(data['data']);
    }
    if (dataClassName == 'SharedModel') {
      return deserialize<_iwajn61k.SharedModel>(data['data']);
    }
    if (dataClassName == 'SharedSealedChild') {
      return deserialize<_iag9521n.SharedSealedChild>(data['data']);
    }
    if (dataClassName == 'SharedNotFoundException') {
      return deserialize<_ieg0jtrp.SharedNotFoundException>(data['data']);
    }
    if (dataClassName == 'SharedValidationException') {
      return deserialize<_ieg0jtrp.SharedValidationException>(data['data']);
    }
    if (dataClassName == 'SharedObjectWithSealedException') {
      return deserialize<_i4mzuyso.SharedObjectWithSealedException>(
        data['data'],
      );
    }
    if (dataClassName == 'SharedTableRecord') {
      return deserialize<_itms6rpy.SharedTableRecord>(data['data']);
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
          ? _iss.SerializationManager.toEncodableForProtocol(wrapped)
          : _iss.SerializationManager.toEncodable(wrapped);
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
  _isd.Table? getTableForType(Type t) {
    switch (t) {
      case _itms6rpy.SharedTableRecord:
        return _itms6rpy.SharedTableRecord.t;
    }
    return null;
  }

  @override
  List<_isd.TableDefinition> getTargetTableDefinitions() =>
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
