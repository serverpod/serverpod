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
import 'shared/enum.dart' as _i2;
import 'shared/exception.dart' as _i3;
import 'shared/subclass.dart' as _i4;
import 'shared/model.dart' as _i5;
import 'shared/sealed/parent.dart' as _i6;
export 'shared/enum.dart';
export 'shared/exception.dart';
export 'shared/subclass.dart';
export 'shared/model.dart';
export 'shared/sealed/parent.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

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

    if (t == _i2.SharedEnum) {
      return _i2.SharedEnum.fromJson(data) as T;
    }
    if (t == _i3.SharedException) {
      return _i3.SharedException.fromJson(data) as T;
    }
    if (t == _i4.SharedSubclass) {
      return _i4.SharedSubclass.fromJson(data) as T;
    }
    if (t == _i5.SharedModel) {
      return _i5.SharedModel.fromJson(data) as T;
    }
    if (t == _i6.SharedSealedChild) {
      return _i6.SharedSealedChild.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.SharedEnum?>()) {
      return (data != null ? _i2.SharedEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.SharedException?>()) {
      return (data != null ? _i3.SharedException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.SharedSubclass?>()) {
      return (data != null ? _i4.SharedSubclass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.SharedModel?>()) {
      return (data != null ? _i5.SharedModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.SharedSealedChild?>()) {
      return (data != null ? _i6.SharedSealedChild.fromJson(data) : null) as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.SharedEnum => 'SharedEnum',
      _i3.SharedException => 'SharedException',
      _i4.SharedSubclass => 'SharedSubclass',
      _i5.SharedModel => 'SharedModel',
      _i6.SharedSealedChild => 'SharedSealedChild',
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
      case _i2.SharedEnum():
        return 'SharedEnum';
      case _i3.SharedException():
        return 'SharedException';
      case _i4.SharedSubclass():
        return 'SharedSubclass';
      case _i5.SharedModel():
        return 'SharedModel';
      case _i6.SharedSealedChild():
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
    if (dataClassName == 'SharedEnum') {
      return deserialize<_i2.SharedEnum>(data['data']);
    }
    if (dataClassName == 'SharedException') {
      return deserialize<_i3.SharedException>(data['data']);
    }
    if (dataClassName == 'SharedSubclass') {
      return deserialize<_i4.SharedSubclass>(data['data']);
    }
    if (dataClassName == 'SharedModel') {
      return deserialize<_i5.SharedModel>(data['data']);
    }
    if (dataClassName == 'SharedSealedChild') {
      return deserialize<_i6.SharedSealedChild>(data['data']);
    }
    return super.deserializeByClassName(data);
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
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
