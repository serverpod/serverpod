/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unnecessary_import

import 'package:serverpod_serialization/serverpod_serialization.dart';

class LogLevel extends SerializableEntity {
  @override
  String get className => 'LogLevel';

  late final int _index;
  int get index => _index;

  LogLevel._internal(this._index);

  LogLevel.fromSerialization(Map<String, dynamic> serialization) {
    Map<String, dynamic> data = unwrapSerializationData(serialization);
    _index = data['index'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData(<String, dynamic>{
      'index': _index,
    });
  }

  static final LogLevel debug = LogLevel._internal(0);
  static final LogLevel info = LogLevel._internal(1);
  static final LogLevel warning = LogLevel._internal(2);
  static final LogLevel error = LogLevel._internal(3);
  static final LogLevel fatal = LogLevel._internal(4);

  @override
  int get hashCode => _index.hashCode;
  @override
  bool operator ==(Object other) => other is LogLevel && other._index == _index;

  static final List<LogLevel> values = <LogLevel>[
    debug,
    info,
    warning,
    error,
    fatal,
  ];

  String get name {
    if (this == debug) return 'debug';
    if (this == info) return 'info';
    if (this == warning) return 'warning';
    if (this == error) return 'error';
    if (this == fatal) return 'fatal';
    throw const FormatException();
  }
}
