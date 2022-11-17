import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

part 'freezed_custom_class.freezed.dart';
part 'freezed_custom_class.g.dart';

@freezed
class FreezedCustomClass with _$FreezedCustomClass {
  const factory FreezedCustomClass({
    required String firstName,
    required String lastName,
    required int age,
  }) = _FreezedCustomClass;

  factory FreezedCustomClass.fromJson(
    Map<String, Object?> json,
    SerializationManager serializationManager,
  ) =>
      _$FreezedCustomClassFromJson(json);
}
