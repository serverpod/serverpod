// TODO: Put public facing types in this file.

import 'package:serverpod_serialization/serverpod_serialization.dart';

class ExternalCustomClass {
  final String value;

  const ExternalCustomClass(this.value);

  String toJson() => value;

  static ExternalCustomClass fromJson(
      dynamic data, SerializationManager serializationManager) {
    return ExternalCustomClass(data);
  }
}
