import 'package:serverpod_serialization/serverpod_serialization.dart';

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

class CustomClassWithProtocolSerialization implements ProtocolSerialization {
  final String? serverSideValue;
  final String? value;

  CustomClassWithProtocolSerialization({
    this.serverSideValue,
    this.value,
  });

  Map<String, dynamic> toJson() => {
        'serverSideValue': serverSideValue,
        'value': value,
      };

  @override
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

  Map<String, dynamic> toJson() => {
        'serverSideValue': serverSideValue,
        'value': value,
      };

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
