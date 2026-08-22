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
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_module_server/src/generated/module_streaming_class.dart'
    as _irv1xa50;
import 'dynamic_on_module.dart' as _ircaal6o;
import 'generated/polymorphism/child.dart' as _in13ph1t;
import 'generated/polymorphism/grandchild.dart' as _i3gtzugh;
import 'generated/polymorphism/parent.dart' as _is5pt2rl;
import 'module_class.dart' as _izah8b1s;
import 'module_feature/models/my_feature_model.dart' as _iya6t7ee;
import 'module_streaming_class.dart' as _idp5674x;
import 'project_streaming_class.dart' as _iqrw583n;
export 'dynamic_on_module.dart';
export 'generated/polymorphism/grandchild.dart';
export 'generated/polymorphism/child.dart';
export 'generated/polymorphism/parent.dart';
export 'module_class.dart';
export 'module_feature/models/my_feature_model.dart';
export 'module_streaming_class.dart';
export 'project_streaming_class.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  final Set<_is.SerializationManager> _hostProtocols = {};

  static List<_isp.TableDefinition> get targetTableDefinitions => [];

  void registerHostProtocol(
    String projectName,
    _is.SerializationManager protocol,
  ) {
    _hostProtocols.add(protocol);
  }

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    if (className == null) return null;
    if (!className.startsWith('serverpod_test_module.')) return className;
    return className.substring(22);
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

    if (t == _ircaal6o.DynamicOnModule) {
      return _ircaal6o.DynamicOnModule.fromJson(data) as T;
    }
    if (t == _i3gtzugh.ModulePolymorphicGrandChild) {
      return _i3gtzugh.ModulePolymorphicGrandChild.fromJson(data) as T;
    }
    if (t == _in13ph1t.ModulePolymorphicChild) {
      return _in13ph1t.ModulePolymorphicChild.fromJson(data) as T;
    }
    if (t == _is5pt2rl.ModulePolymorphicParent) {
      return _is5pt2rl.ModulePolymorphicParent.fromJson(data) as T;
    }
    if (t == _izah8b1s.ModuleClass) {
      return _izah8b1s.ModuleClass.fromJson(data) as T;
    }
    if (t == _iya6t7ee.MyModuleFeatureModel) {
      return _iya6t7ee.MyModuleFeatureModel.fromJson(data) as T;
    }
    if (t == _idp5674x.ModuleStreamingClass) {
      return _idp5674x.ModuleStreamingClass.fromJson(data) as T;
    }
    if (t == _iqrw583n.ProjectStreamingClass) {
      return _iqrw583n.ProjectStreamingClass.fromJson(data) as T;
    }
    if (t == _is.getType<_ircaal6o.DynamicOnModule?>()) {
      return (data != null ? _ircaal6o.DynamicOnModule.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i3gtzugh.ModulePolymorphicGrandChild?>()) {
      return (data != null
              ? _i3gtzugh.ModulePolymorphicGrandChild.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_in13ph1t.ModulePolymorphicChild?>()) {
      return (data != null
              ? _in13ph1t.ModulePolymorphicChild.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_is5pt2rl.ModulePolymorphicParent?>()) {
      return (data != null
              ? _is5pt2rl.ModulePolymorphicParent.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_izah8b1s.ModuleClass?>()) {
      return (data != null ? _izah8b1s.ModuleClass.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iya6t7ee.MyModuleFeatureModel?>()) {
      return (data != null
              ? _iya6t7ee.MyModuleFeatureModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_idp5674x.ModuleStreamingClass?>()) {
      return (data != null
              ? _idp5674x.ModuleStreamingClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iqrw583n.ProjectStreamingClass?>()) {
      return (data != null
              ? _iqrw583n.ProjectStreamingClass.fromJson(data)
              : null)
          as T;
    }
    if (t == dynamic) {
      return deserializeDynamicFieldValue(data) as T;
    }
    if (t == _is.getType<(bool,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<bool>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(int?, _irv1xa50.ModuleStreamingClass?)>()) {
      return (
            ((data as Map)['p'] as List)[0] == null
                ? null
                : deserialize<int>(data['p'][0]),
            ((data)['p'] as List)[1] == null
                ? null
                : deserialize<_irv1xa50.ModuleStreamingClass>(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<(bool,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<bool>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(int?, _irv1xa50.ModuleStreamingClass?)>()) {
      return (
            ((data as Map)['p'] as List)[0] == null
                ? null
                : deserialize<int>(data['p'][0]),
            ((data)['p'] as List)[1] == null
                ? null
                : deserialize<_irv1xa50.ModuleStreamingClass>(data['p'][1]),
          )
          as T;
    }
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ircaal6o.DynamicOnModule => 'DynamicOnModule',
      _i3gtzugh.ModulePolymorphicGrandChild => 'ModulePolymorphicGrandChild',
      _in13ph1t.ModulePolymorphicChild => 'ModulePolymorphicChild',
      _is5pt2rl.ModulePolymorphicParent => 'ModulePolymorphicParent',
      _izah8b1s.ModuleClass => 'ModuleClass',
      _iya6t7ee.MyModuleFeatureModel => 'MyModuleFeatureModel',
      _idp5674x.ModuleStreamingClass => 'ModuleStreamingClass',
      _iqrw583n.ProjectStreamingClass => 'ProjectStreamingClass',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'serverpod_test_module.',
        '',
      );
    }

    switch (data) {
      case _ircaal6o.DynamicOnModule():
        return 'DynamicOnModule';
      case _i3gtzugh.ModulePolymorphicGrandChild():
        return 'ModulePolymorphicGrandChild';
      case _in13ph1t.ModulePolymorphicChild():
        return 'ModulePolymorphicChild';
      case _is5pt2rl.ModulePolymorphicParent():
        return 'ModulePolymorphicParent';
      case _izah8b1s.ModuleClass():
        return 'ModuleClass';
      case _iya6t7ee.MyModuleFeatureModel():
        return 'MyModuleFeatureModel';
      case _idp5674x.ModuleStreamingClass():
        return 'ModuleStreamingClass';
      case _iqrw583n.ProjectStreamingClass():
        return 'ProjectStreamingClass';
    }
    if (data is (int?, _irv1xa50.ModuleStreamingClass?)) {
      return '(int?,ModuleStreamingClass?)';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'DynamicOnModule') {
      return deserialize<_ircaal6o.DynamicOnModule>(data['data']);
    }
    if (dataClassName == 'ModulePolymorphicGrandChild') {
      return deserialize<_i3gtzugh.ModulePolymorphicGrandChild>(data['data']);
    }
    if (dataClassName == 'ModulePolymorphicChild') {
      return deserialize<_in13ph1t.ModulePolymorphicChild>(data['data']);
    }
    if (dataClassName == 'ModulePolymorphicParent') {
      return deserialize<_is5pt2rl.ModulePolymorphicParent>(data['data']);
    }
    if (dataClassName == 'ModuleClass') {
      return deserialize<_izah8b1s.ModuleClass>(data['data']);
    }
    if (dataClassName == 'MyModuleFeatureModel') {
      return deserialize<_iya6t7ee.MyModuleFeatureModel>(data['data']);
    }
    if (dataClassName == 'ModuleStreamingClass') {
      return deserialize<_idp5674x.ModuleStreamingClass>(data['data']);
    }
    if (dataClassName == 'ProjectStreamingClass') {
      return deserialize<_iqrw583n.ProjectStreamingClass>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    if (dataClassName == '(int?,ModuleStreamingClass?)') {
      return deserialize<(int?, _irv1xa50.ModuleStreamingClass?)>(data['data']);
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
          ? _is.SerializationManager.toEncodableForProtocol(wrapped)
          : _is.SerializationManager.toEncodable(wrapped);
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
  _is.Table? getTableForType(Type t) {
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_test_module';

  /// Wraps serialized data with its class name so that it can be deserialized
  /// with [deserializeByClassName].
  ///
  /// Records and containers containing records will be return in their JSON representation in the returned map.
  @override
  Map<String, dynamic> wrapWithClassName(Object? data) {
    /// In case the value (to be streamed) contains a record or potentially empty non-String-keyed Map, we need to map it before it reaches the underlying JSON encode
    if (data != null && (data is Iterable || data is Map)) {
      return {
        'className': getClassNameForObject(data)!,
        'data': mapContainerToJson(data),
      };
    } else if (data is Record) {
      return {
        'className': getClassNameForObject(data)!,
        'data': mapRecordToJson(data),
      };
    }

    return super.wrapWithClassName(data);
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
    if (record is (int?, _irv1xa50.ModuleStreamingClass?)) {
      return {
        "p": [
          record.$1,
          record.$2?.toJson(),
        ],
      };
    }
    if (record is (bool,)) {
      return {
        "p": [
          record.$1,
        ],
      };
    }
    try {
      return _isp.Protocol().mapRecordToJson(record);
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
