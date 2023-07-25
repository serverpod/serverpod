import 'package:analyzer/dart/element/type.dart';
import 'package:serverpod_cli/src/generator/types.dart';

class TypeDefinitionBuilder {
  TypeDefinition _definition;

  TypeDefinitionBuilder() : _definition = TypeDefinition(
          className: 'DefaultClassName',
          generics: [],
          nullable: false,
          customClass: false,
          isEnum: false,
        );

  TypeDefinitionBuilder withClassName(String className) {
    _definition = _definition.copyWith(className: className);
    return this;
  }

  TypeDefinitionBuilder withGenerics(List<TypeDefinition> generics) {
    _definition = _definition.copyWith(generics: generics);
    return this;
  }

  TypeDefinitionBuilder withNullable(bool nullable) {
    _definition = _definition.copyWith(nullable: nullable);
    return this;
  }

  TypeDefinitionBuilder withUrl(String? url) {
    _definition = _definition.copyWith(url: url);
    return this;
  }

  TypeDefinitionBuilder withDartType(DartType? dartType) {
    _definition = _definition.copyWith(dartType: dartType);
    return this;
  }

  TypeDefinitionBuilder withCustomClass(bool customClass) {
    _definition = _definition.copyWith(customClass: customClass);
    return this;
  }

  TypeDefinitionBuilder withIsEnum(bool isEnum) {
    _definition = _definition.copyWith(isEnum: isEnum);
    return this;
  }

  TypeDefinition build() {
    return _definition;
  }
}
