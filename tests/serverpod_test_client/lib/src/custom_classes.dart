// ignore: depend_on_referenced_packages
import 'package:serverpod_client/serverpod_client.dart';

class CustomClass {
  final String value;

  const CustomClass(this.value);

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
