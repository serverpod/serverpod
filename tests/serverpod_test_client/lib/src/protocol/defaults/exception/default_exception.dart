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
import '../../defaults/enum/enums/by_name_enum.dart' as _i2;

abstract class DefaultException
    implements _i1.SerializableException, _i1.SerializableModel {
  DefaultException._({
    bool? defaultBoolean,
    DateTime? defaultDateTime,
    double? defaultDouble,
    Duration? defaultDuration,
    _i2.ByNameEnum? defaultEnum,
    int? defaultInteger,
    String? defaultString,
    _i1.UuidValue? defaultUuid,
    String? defaultModelField,
    String? defaultMixField,
  })  : defaultBoolean = defaultBoolean ?? true,
        defaultDateTime = defaultDateTime ?? DateTime.now(),
        defaultDouble = defaultDouble ?? 10.5,
        defaultDuration = defaultDuration ??
            Duration(
              days: 1,
              hours: 2,
              minutes: 30,
              seconds: 0,
              milliseconds: 0,
            ),
        defaultEnum = defaultEnum ?? _i2.ByNameEnum.byName1,
        defaultInteger = defaultInteger ?? 10,
        defaultString = defaultString ?? 'Default error message',
        defaultUuid = defaultUuid ?? _i1.Uuid().v4obj(),
        defaultModelField = defaultModelField ?? 'Model specific message',
        defaultMixField = defaultMixField ?? 'Model specific mix message';

  factory DefaultException({
    bool? defaultBoolean,
    DateTime? defaultDateTime,
    double? defaultDouble,
    Duration? defaultDuration,
    _i2.ByNameEnum? defaultEnum,
    int? defaultInteger,
    String? defaultString,
    _i1.UuidValue? defaultUuid,
    String? defaultModelField,
    String? defaultMixField,
  }) = _DefaultExceptionImpl;

  factory DefaultException.fromJson(Map<String, dynamic> jsonSerialization) {
    return DefaultException(
      defaultBoolean: jsonSerialization['defaultBoolean'] as bool,
      defaultDateTime: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['defaultDateTime']),
      defaultDouble: (jsonSerialization['defaultDouble'] as num).toDouble(),
      defaultDuration: _i1.DurationJsonExtension.fromJson(
          jsonSerialization['defaultDuration']),
      defaultEnum:
          _i2.ByNameEnum.fromJson((jsonSerialization['defaultEnum'] as String)),
      defaultInteger: jsonSerialization['defaultInteger'] as int,
      defaultString: jsonSerialization['defaultString'] as String,
      defaultUuid:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['defaultUuid']),
      defaultModelField: jsonSerialization['defaultModelField'] as String,
      defaultMixField: jsonSerialization['defaultMixField'] as String,
    );
  }

  bool defaultBoolean;

  DateTime defaultDateTime;

  double defaultDouble;

  Duration defaultDuration;

  _i2.ByNameEnum defaultEnum;

  int defaultInteger;

  String defaultString;

  _i1.UuidValue defaultUuid;

  String defaultModelField;

  String defaultMixField;

  /// Returns a shallow copy of this [DefaultException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DefaultException copyWith({
    bool? defaultBoolean,
    DateTime? defaultDateTime,
    double? defaultDouble,
    Duration? defaultDuration,
    _i2.ByNameEnum? defaultEnum,
    int? defaultInteger,
    String? defaultString,
    _i1.UuidValue? defaultUuid,
    String? defaultModelField,
    String? defaultMixField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'defaultBoolean': defaultBoolean,
      'defaultDateTime': defaultDateTime.toJson(),
      'defaultDouble': defaultDouble,
      'defaultDuration': defaultDuration.toJson(),
      'defaultEnum': defaultEnum.toJson(),
      'defaultInteger': defaultInteger,
      'defaultString': defaultString,
      'defaultUuid': defaultUuid.toJson(),
      'defaultModelField': defaultModelField,
      'defaultMixField': defaultMixField,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _DefaultExceptionImpl extends DefaultException {
  _DefaultExceptionImpl({
    bool? defaultBoolean,
    DateTime? defaultDateTime,
    double? defaultDouble,
    Duration? defaultDuration,
    _i2.ByNameEnum? defaultEnum,
    int? defaultInteger,
    String? defaultString,
    _i1.UuidValue? defaultUuid,
    String? defaultModelField,
    String? defaultMixField,
  }) : super._(
          defaultBoolean: defaultBoolean,
          defaultDateTime: defaultDateTime,
          defaultDouble: defaultDouble,
          defaultDuration: defaultDuration,
          defaultEnum: defaultEnum,
          defaultInteger: defaultInteger,
          defaultString: defaultString,
          defaultUuid: defaultUuid,
          defaultModelField: defaultModelField,
          defaultMixField: defaultMixField,
        );

  /// Returns a shallow copy of this [DefaultException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DefaultException copyWith({
    bool? defaultBoolean,
    DateTime? defaultDateTime,
    double? defaultDouble,
    Duration? defaultDuration,
    _i2.ByNameEnum? defaultEnum,
    int? defaultInteger,
    String? defaultString,
    _i1.UuidValue? defaultUuid,
    String? defaultModelField,
    String? defaultMixField,
  }) {
    return DefaultException(
      defaultBoolean: defaultBoolean ?? this.defaultBoolean,
      defaultDateTime: defaultDateTime ?? this.defaultDateTime,
      defaultDouble: defaultDouble ?? this.defaultDouble,
      defaultDuration: defaultDuration ?? this.defaultDuration,
      defaultEnum: defaultEnum ?? this.defaultEnum,
      defaultInteger: defaultInteger ?? this.defaultInteger,
      defaultString: defaultString ?? this.defaultString,
      defaultUuid: defaultUuid ?? this.defaultUuid,
      defaultModelField: defaultModelField ?? this.defaultModelField,
      defaultMixField: defaultMixField ?? this.defaultMixField,
    );
  }
}
