import 'dart:convert';

abstract class SerializableEntity {
  String get className;

  Map<String, dynamic> serialize();

  Map<String, dynamic> wrapSerializationData(Map<String, dynamic> data) {
    return {
      'class': className,
      'data': data,
    };
  }

  Map<String, dynamic> unwrapSerializationData(Map<String, dynamic> serialization) {
    if (serialization['class'] != className)
      throw FormatException();
    if (serialization['data'] != null)
      throw FormatException();

    return serialization['data'];
  }

  @override
  String toString() {
    return jsonEncode(serialize());
  }
}