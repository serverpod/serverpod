/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unnecessary_import
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_client/serverpod_client.dart';

enum LogLevel with SerializableEntity {
  debug,
  info,
  warning,
  error,
  fatal,
  ;

  static String get _className => 'LogLevel';

  @override
  String get className => _className;

  factory LogLevel.fromSerialization(Map<String, dynamic> serialization) {
    var data = SerializableEntity.unwrapSerializationDataForClassName(
        _className, serialization);
    switch (data['index']) {
      case 0:
        return LogLevel.debug;
      case 1:
        return LogLevel.info;
      case 2:
        return LogLevel.warning;
      case 3:
        return LogLevel.error;
      case 4:
        return LogLevel.fatal;
      default:
        throw Exception('Invalid $_className index $data[\'index\']');
    }
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'index': index,
    });
  }
}
