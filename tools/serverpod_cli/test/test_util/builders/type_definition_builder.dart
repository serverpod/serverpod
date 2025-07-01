import 'package:analyzer/dart/element/type.dart';
import 'package:serverpod_cli/analyzer.dart';

class TypeDefinitionBuilder {
  String _className;
  List<TypeDefinition> _generics;
  bool _nullable;
  String? _url;
  DartType? _dartType;
  bool _customClass;
  EnumDefinition? _enumDefinition;
  SerializableModelDefinition? _modelDefinition;
  int? _vectorDimension;

  TypeDefinitionBuilder()
      : _className = 'DefaultClassName',
        _generics = [],
        _nullable = false,
        _url = null,
        _dartType = null,
        _customClass = false,
        _modelDefinition = null,
        _vectorDimension = null;

  TypeDefinitionBuilder withClassName(String className) {
    _className = className;
    return this;
  }

  TypeDefinitionBuilder withGenerics(List<TypeDefinition> generics) {
    _generics = generics;
    return this;
  }

  TypeDefinitionBuilder withFutureOf(
    String className, [
    bool nullable = false,
  ]) {
    _className = 'Future';
    _generics.add(TypeDefinitionBuilder()
        .withClassName(className)
        .withNullable(nullable)
        .build());
    return this;
  }

  TypeDefinitionBuilder withStreamOf(
    String className,
  ) {
    _className = 'Stream';
    _generics.add(TypeDefinitionBuilder().withClassName(className).build());
    return this;
  }

  TypeDefinitionBuilder withRecordOf(
    List<TypeDefinition> fields,
  ) {
    _className = '_Record';
    _generics.addAll(fields);
    return this;
  }

  TypeDefinitionBuilder withListOf(
    String className, {
    bool nullable = false,
    String? url,
    SerializableModelDefinition? modelInfo,
  }) {
    _className = 'List';
    var generic = TypeDefinitionBuilder()
        .withClassName(className)
        .withNullable(nullable)
        .withUrl(url);

    if (modelInfo != null) {
      generic.withModelDefinition(modelInfo);
    }

    _generics.add(generic.build());
    return this;
  }

  TypeDefinitionBuilder withMapOf(
    String keyClassName,
    String valueClassName, [
    bool nullable = false,
  ]) {
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

  TypeDefinitionBuilder withEnumSerialized(EnumDefinition definition) {
    _enumDefinition = definition;
    return this;
  }

  TypeDefinitionBuilder withModelDefinition(
    SerializableModelDefinition modelDefinition,
  ) {
    _modelDefinition = modelDefinition;
    return this;
  }

  TypeDefinitionBuilder withVectorDimension(int dimension) {
    _vectorDimension = dimension;
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
      enumDefinition: _enumDefinition,
      projectModelDefinition: _modelDefinition,
      vectorDimension: _vectorDimension,
    );
  }
}
