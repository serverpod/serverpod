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
import 'generated/polymorphism/grandchild.dart' as _i2;
import 'generated/polymorphism/child.dart' as _i3;
import 'generated/polymorphism/parent.dart' as _i4;
import 'module_class.dart' as _i5;
import 'module_feature/models/my_feature_model.dart' as _i6;
import 'module_streaming_class.dart' as _i7;
import 'project_streaming_class.dart' as _i8;
import 'package:serverpod_test_module_client/src/protocol/module_streaming_class.dart'
    as _i9;
export 'generated/polymorphism/grandchild.dart';
export 'generated/polymorphism/child.dart';
export 'generated/polymorphism/parent.dart';
export 'module_class.dart';
export 'module_feature/models/my_feature_model.dart';
export 'module_streaming_class.dart';
export 'project_streaming_class.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

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

    if (t == _i2.ModulePolymorphicGrandChild) {
      return _i2.ModulePolymorphicGrandChild.fromJson(data) as T;
    }
    if (t == _i3.ModulePolymorphicChild) {
      return _i3.ModulePolymorphicChild.fromJson(data) as T;
    }
    if (t == _i4.ModulePolymorphicParent) {
      return _i4.ModulePolymorphicParent.fromJson(data) as T;
    }
    if (t == _i5.ModuleClass) {
      return _i5.ModuleClass.fromJson(data) as T;
    }
    if (t == _i6.MyModuleFeatureModel) {
      return _i6.MyModuleFeatureModel.fromJson(data) as T;
    }
    if (t == _i7.ModuleStreamingClass) {
      return _i7.ModuleStreamingClass.fromJson(data) as T;
    }
    if (t == _i8.ProjectStreamingClass) {
      return _i8.ProjectStreamingClass.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ModulePolymorphicGrandChild?>()) {
      return (data != null
              ? _i2.ModulePolymorphicGrandChild.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i3.ModulePolymorphicChild?>()) {
      return (data != null ? _i3.ModulePolymorphicChild.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i4.ModulePolymorphicParent?>()) {
      return (data != null ? _i4.ModulePolymorphicParent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.ModuleClass?>()) {
      return (data != null ? _i5.ModuleClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.MyModuleFeatureModel?>()) {
      return (data != null ? _i6.MyModuleFeatureModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.ModuleStreamingClass?>()) {
      return (data != null ? _i7.ModuleStreamingClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.ProjectStreamingClass?>()) {
      return (data != null ? _i8.ProjectStreamingClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<(bool,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<bool>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(int?, _i9.ModuleStreamingClass?)>()) {
      return (
            ((data as Map)['p'] as List)[0] == null
                ? null
                : deserialize<int>(data['p'][0]),
            ((data)['p'] as List)[1] == null
                ? null
                : deserialize<_i9.ModuleStreamingClass>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<(bool,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<bool>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(int?, _i9.ModuleStreamingClass?)>()) {
      return (
            ((data as Map)['p'] as List)[0] == null
                ? null
                : deserialize<int>(data['p'][0]),
            ((data)['p'] as List)[1] == null
                ? null
                : deserialize<_i9.ModuleStreamingClass>(data['p'][1]),
          )
          as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ModulePolymorphicGrandChild => 'ModulePolymorphicGrandChild',
      _i3.ModulePolymorphicChild => 'ModulePolymorphicChild',
      _i4.ModulePolymorphicParent => 'ModulePolymorphicParent',
      _i5.ModuleClass => 'ModuleClass',
      _i6.MyModuleFeatureModel => 'MyModuleFeatureModel',
      _i7.ModuleStreamingClass => 'ModuleStreamingClass',
      _i8.ProjectStreamingClass => 'ProjectStreamingClass',
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
      case _i2.ModulePolymorphicGrandChild():
        return 'ModulePolymorphicGrandChild';
      case _i3.ModulePolymorphicChild():
        return 'ModulePolymorphicChild';
      case _i4.ModulePolymorphicParent():
        return 'ModulePolymorphicParent';
      case _i5.ModuleClass():
        return 'ModuleClass';
      case _i6.MyModuleFeatureModel():
        return 'MyModuleFeatureModel';
      case _i7.ModuleStreamingClass():
        return 'ModuleStreamingClass';
      case _i8.ProjectStreamingClass():
        return 'ProjectStreamingClass';
    }
    if (data is (int?, _i9.ModuleStreamingClass?)) {
      return '(int?,ModuleStreamingClass?)';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ModulePolymorphicGrandChild') {
      return deserialize<_i2.ModulePolymorphicGrandChild>(data['data']);
    }
    if (dataClassName == 'ModulePolymorphicChild') {
      return deserialize<_i3.ModulePolymorphicChild>(data['data']);
    }
    if (dataClassName == 'ModulePolymorphicParent') {
      return deserialize<_i4.ModulePolymorphicParent>(data['data']);
    }
    if (dataClassName == 'ModuleClass') {
      return deserialize<_i5.ModuleClass>(data['data']);
    }
    if (dataClassName == 'MyModuleFeatureModel') {
      return deserialize<_i6.MyModuleFeatureModel>(data['data']);
    }
    if (dataClassName == 'ModuleStreamingClass') {
      return deserialize<_i7.ModuleStreamingClass>(data['data']);
    }
    if (dataClassName == 'ProjectStreamingClass') {
      return deserialize<_i8.ProjectStreamingClass>(data['data']);
    }
    if (dataClassName == '(int?,ModuleStreamingClass?)') {
      return deserialize<(int?, _i9.ModuleStreamingClass?)>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

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
  if (record is (int?, _i9.ModuleStreamingClass?)) {
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
