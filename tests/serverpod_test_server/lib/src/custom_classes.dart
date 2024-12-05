// ignore: depend_on_referenced_packages
import 'package:serverpod_client/serverpod_client.dart';

// Usually such a class should be placed in a common package.
// But since this is only a test project, it should be fine.
// Just be careful while importing, since the serialization
// system treats the two implementations this classes differently.

class CustomClass implements SerializableModel {
  final String value;

  CustomClass(this.value);

  @override
  String toJson() => value;

  factory CustomClass.fromJson(dynamic data) {
    return CustomClass(data);
  }
}

class CustomClass2 {
  final String value;

  const CustomClass2(this.value);

  factory CustomClass2.fromJson(dynamic data) {
    return CustomClass2(data['text']);
  }

  dynamic toJson() => {'text': value};
}

/// Custom class that does not implement ProtocolSerialization.
class CustomClassWithoutProtocolSerialization {
  final String? serverSideValue;
  final String? value;

  CustomClassWithoutProtocolSerialization({
    this.serverSideValue,
    this.value,
  });

  Map<String, dynamic> toJson() => {
        'serverSideValue': serverSideValue,
        'value': value,
      };

  CustomClassWithoutProtocolSerialization copyWith() => this;

  factory CustomClassWithoutProtocolSerialization.fromJson(
    Map<String, dynamic> data,
  ) {
    return CustomClassWithoutProtocolSerialization(
      serverSideValue: data['serverSideValue'] as String?,
      value: data['value'] as String?,
    );
  }
}

/// Custom class that implements ProtocolSerialization.
class CustomClassWithProtocolSerialization implements ProtocolSerialization {
  final String? serverSideValue;
  final String? value;

  CustomClassWithProtocolSerialization({
    this.serverSideValue,
    this.value,
  });

  Map<String, dynamic> toJson() => {'serverSideValue': serverSideValue};

  Map<String, dynamic> toJsonForProtocol() => {'value': value};

  CustomClassWithProtocolSerialization copyWith() => this;

  factory CustomClassWithProtocolSerialization.fromJson(
    Map<String, dynamic> data,
  ) {
    return CustomClassWithProtocolSerialization(
      serverSideValue: data['serverSideValue'] as String?,
      value: data['value'] as String?,
    );
  }
}

/// Custom class that does not implement ProtocolSerialization but has the
/// "toJsonForProtocol" method.
class CustomClassWithProtocolSerializationMethod {
  final String? serverSideValue;
  final String? value;

  CustomClassWithProtocolSerializationMethod({
    this.serverSideValue,
    this.value,
  });

  Map<String, dynamic> toJson() => {'serverSideValue': serverSideValue};

  Map<String, dynamic> toJsonForProtocol() => {'value': value};

  CustomClassWithProtocolSerializationMethod copyWith() => this;

  factory CustomClassWithProtocolSerializationMethod.fromJson(
    Map<String, dynamic> data,
  ) {
    return CustomClassWithProtocolSerializationMethod(
      serverSideValue: data['serverSideValue'] as String?,
      value: data['value'] as String?,
    );
  }
}
