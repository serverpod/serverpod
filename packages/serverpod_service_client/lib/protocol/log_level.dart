/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod_client/serverpod_client.dart';
class LogLevel extends SerializableEntity {
  String get className => 'LogLevel';

  int _index;
  int get index => _index;

  LogLevel._internal(this._index); 

  LogLevel.fromSerialization(Map<String, dynamic> serialization) {
    var data = unwrapSerializationData(serialization);
    _index = data['index'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'index': _index,
    });
  }
  static final debug = LogLevel._internal(0);
  static final info = LogLevel._internal(1);
  static final warning = LogLevel._internal(2);
  static final error = LogLevel._internal(3);
  static final fatal = LogLevel._internal(4);

  int get hashCode => _index.hashCode;
  bool operator == (other) => other._index == _index;

  static final values = <LogLevel>[
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
    return null;
  }
}
