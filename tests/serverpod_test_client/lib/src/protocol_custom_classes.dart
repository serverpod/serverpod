// ignore: depend_on_referenced_packages
import 'package:serverpod_client/serverpod_client.dart';

class ProtocolCustomClass extends SerializableEntity {
  final String? value;

  ProtocolCustomClass({
    required this.value,
  });

  factory ProtocolCustomClass.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProtocolCustomClass(
      value: json["value"] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "value": value,
    };
  }
}
