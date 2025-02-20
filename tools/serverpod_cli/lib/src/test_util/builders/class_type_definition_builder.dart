import 'package:analyzer/dart/element/type.dart';
import 'package:serverpod_cli/analyzer.dart';

class ClassTypeDefinitionBuilder {
  String _className;
  List<ClassTypeDefinition> _generics;
  bool _nullable;
  String? _url;
  DartType? _dartType;
  bool _customClass;
  EnumDefinition? _enumDefinition;
  SerializableModelDefinition? _modelDefinition;

  ClassTypeDefinitionBuilder()
      : _className = 'DefaultClassName',
        _generics = [],
        _nullable = false,
        _url = null,
        _dartType = null,
        _customClass = false,
        _modelDefinition = null;

  ClassTypeDefinitionBuilder withClassName(String className) {
    _className = className;
    return this;
  }

  ClassTypeDefinitionBuilder withGenerics(List<ClassTypeDefinition> generics) {
    _generics = generics;
    return this;
  }

  ClassTypeDefinitionBuilder withFutureOf(
    String className, [
    bool nullable = false,
  ]) {
    _className = 'Future';
    _generics.add(ClassTypeDefinitionBuilder()
        .withClassName(className)
        .withNullable(nullable)
        .build());
    return this;
  }

  ClassTypeDefinitionBuilder withStreamOf(
    String className,
  ) {
    _className = 'Stream';
    _generics
        .add(ClassTypeDefinitionBuilder().withClassName(className).build());
    return this;
  }

  ClassTypeDefinitionBuilder withListOf(
    String className, {
    bool nullable = false,
    String? url,
    SerializableModelDefinition? modelInfo,
  }) {
    _className = 'List';
    var generic = ClassTypeDefinitionBuilder()
        .withClassName(className)
        .withNullable(nullable)
        .withUrl(url);

    if (modelInfo != null) {
      generic.withModelDefinition(modelInfo);
    }

    _generics.add(generic.build());
    return this;
  }

  ClassTypeDefinitionBuilder withMapOf(
    String keyClassName,
    String valueClassName, [
    bool nullable = false,
  ]) {
    _className = 'Map';
    _generics
        .add(ClassTypeDefinitionBuilder().withClassName(keyClassName).build());
    _generics.add(ClassTypeDefinitionBuilder()
        .withClassName(valueClassName)
        .withNullable(nullable)
        .build());
    return this;
  }

  ClassTypeDefinitionBuilder withNullable(bool nullable) {
    _nullable = nullable;
    return this;
  }

  ClassTypeDefinitionBuilder withUrl(String? url) {
    _url = url;
    return this;
  }

  ClassTypeDefinitionBuilder withDartType(DartType? dartType) {
    _dartType = dartType;
    return this;
  }

  ClassTypeDefinitionBuilder withCustomClass(bool customClass) {
    _customClass = customClass;
    return this;
  }

  ClassTypeDefinitionBuilder withEnumSerialized(EnumDefinition definition) {
    _enumDefinition = definition;
    return this;
  }

  ClassTypeDefinitionBuilder withModelDefinition(
    SerializableModelDefinition modelDefinition,
  ) {
    _modelDefinition = modelDefinition;
    return this;
  }

  ClassTypeDefinition build() {
    return ClassTypeDefinition(
      className: _className,
      generics: _generics,
      nullable: _nullable,
      url: _url,
      dartType: _dartType,
      customClass: _customClass,
      enumDefinition: _enumDefinition,
      projectModelDefinition: _modelDefinition,
    );
  }
}
