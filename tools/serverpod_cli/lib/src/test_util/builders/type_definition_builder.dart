import 'package:analyzer/dart/element/type.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

class TypeDefinitionBuilder {
  String _className;
  List<TypeDefinition> _generics;
  bool _nullable;
  String? _url;
  DartType? _dartType;
  bool _customClass;
  EnumSerialization? _serialized;

  TypeDefinitionBuilder()
      : _className = 'DefaultClassName',
        _generics = [],
        _nullable = false,
        _url = null,
        _dartType = null,
        _customClass = false;

  TypeDefinitionBuilder withClassName(String className) {
    _className = className;
    return this;
  }

  TypeDefinitionBuilder withGenerics(List<TypeDefinition> generics) {
    _generics = generics;
    return this;
  }

  TypeDefinitionBuilder withListOf(String className, [bool nullable = false]) {
    _className = 'List';
    _generics.add(TypeDefinitionBuilder()
        .withClassName(className)
        .withNullable(nullable)
        .build());
    return this;
  }

  TypeDefinitionBuilder withMapOf(String keyClassName, String valueClassName,
      [bool nullable = false]) {
    _className = 'Map';
    _generics.add(TypeDefinitionBuilder().withClassName(keyClassName).build());
    _generics.add(TypeDefinitionBuilder()
        .withClassName(valueClassName)
        .withNullable(nullable)
        .build());
    return this;
  }

  TypeDefinitionBuilder withNullable(bool nullable) {
    _nullable = nullable;
    return this;
  }

  TypeDefinitionBuilder withUrl(String? url) {
    _url = url;
    return this;
  }

  TypeDefinitionBuilder withDartType(DartType? dartType) {
    _dartType = dartType;
    return this;
  }

  TypeDefinitionBuilder withCustomClass(bool customClass) {
    _customClass = customClass;
    return this;
  }

  TypeDefinitionBuilder withEnumSerialized(EnumSerialization serialized) {
    _serialized = serialized;
    return this;
  }

  TypeDefinition build() {
    return TypeDefinition(
      className: _className,
      generics: _generics,
      nullable: _nullable,
      url: _url,
      dartType: _dartType,
      customClass: _customClass,
      serializeEnumAs: _serialized,
    );
  }
}
