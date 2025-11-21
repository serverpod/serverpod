/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'admin/admin_column.dart' as _i3;
import 'admin/admin_resource.dart' as _i4;
import 'module_class.dart' as _i5;
import 'package:serverpod_admin_server/src/generated/admin/admin_resource.dart'
    as _i6;
export 'admin/admin_column.dart';
export 'admin/admin_resource.dart';
export 'module_class.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i3.AdminColumn) {
      return _i3.AdminColumn.fromJson(data) as T;
    }
    if (t == _i4.AdminResource) {
      return _i4.AdminResource.fromJson(data) as T;
    }
    if (t == _i5.ModuleClass) {
      return _i5.ModuleClass.fromJson(data) as T;
    }
    if (t == _i1.getType<_i3.AdminColumn?>()) {
      return (data != null ? _i3.AdminColumn.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AdminResource?>()) {
      return (data != null ? _i4.AdminResource.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.ModuleClass?>()) {
      return (data != null ? _i5.ModuleClass.fromJson(data) : null) as T;
    }
    if (t == List<_i3.AdminColumn>) {
      return (data as List).map((e) => deserialize<_i3.AdminColumn>(e)).toList()
          as T;
    }
    if (t == List<_i6.AdminResource>) {
      return (data as List)
          .map((e) => deserialize<_i6.AdminResource>(e))
          .toList() as T;
    }
    if (t == List<Map<String, String>>) {
      return (data as List)
          .map((e) => deserialize<Map<String, String>>(e))
          .toList() as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String>(v))) as T;
    }
    if (t == _i1.getType<Map<String, dynamic>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<dynamic>(v)))
          : null) as T;
    }
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i3.AdminColumn) {
      return 'AdminColumn';
    }
    if (data is _i4.AdminResource) {
      return 'AdminResource';
    }
    if (data is _i5.ModuleClass) {
      return 'ModuleClass';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AdminColumn') {
      return deserialize<_i3.AdminColumn>(data['data']);
    }
    if (dataClassName == 'AdminResource') {
      return deserialize<_i4.AdminResource>(data['data']);
    }
    if (dataClassName == 'ModuleClass') {
      return deserialize<_i5.ModuleClass>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_admin';
}
