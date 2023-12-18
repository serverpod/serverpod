// ignore: depend_on_referenced_packages
import 'package:serverpod_client/serverpod_client.dart';

// Usually such a class should be placed in a common package.
// But since this is only a test project, it should be fine.
// Just be careful while importing, since the serialization
// system treats the two implementations this classes differently.

class CustomClass extends SerializableModel {
  final String value;

  CustomClass(this.value);

  @override
  String toJson() => value;

  static CustomClass fromJson(
      dynamic data, SerializationManager serializationManager) {
    return CustomClass(data);
  }
}

class CustomClass2 {
  final String value;

  const CustomClass2(this.value);

  dynamic toJson() => {'text': value};
}
