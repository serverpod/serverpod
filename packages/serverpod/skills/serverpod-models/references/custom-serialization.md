# Custom serialization

Reference for the [Serverpod Models](../SKILL.md) skill.

To use serializable models not in YAML: implement `toJson()`, `fromJson`, `copyWith()`. Register in `config/generator.yaml` under `extraClasses` with full URI (e.g. `package:my_shared/my_shared.dart:ClassName`). Both server and client must depend on the package. Freezed classes with `fromJson` work the same way. Implement `ProtocolSerialization` with `toJsonForProtocol()` to omit fields when sending to client.
