import 'package:serverpod_cli/src/analyzer/models/definitions.dart';

import 'serializable_entity_field_definition_builder.dart';
import 'type_definition_builder.dart';

typedef _FieldBuilder = SerializableModelFieldDefinition Function();

class ExceptionClassDefinitionBuilder {
  String _fileName;
  String _sourceFileName;
  String _className;
  List<String> _subDirParts;
  bool _serverOnly;
  List<_FieldBuilder> _fields;
  List<String>? _documentation;
  bool _isSealed;
  InheritanceDefinition? _extendsClass;
  List<InheritanceDefinition> _childClasses;
  String? _sharedPackageName;
  String? _typeUrl;

  ExceptionClassDefinitionBuilder()
    : _fileName = 'example',
      _sourceFileName = 'example.yaml',
      _className = 'Example',
      _fields = [],
      _subDirParts = [],
      _serverOnly = false,
      _isSealed = false,
      _childClasses = [];

  ExceptionClassDefinition build() {
    return ExceptionClassDefinition(
      fileName: _fileName,
      sourceFileName: _sourceFileName,
      className: _className,
      fields: _fields.map((f) => f()).toList(),
      subDirParts: _subDirParts,
      serverOnly: _serverOnly,
      isSealed: _isSealed,
      extendsClass: _extendsClass,
      childClasses: _childClasses,
      documentation: _documentation,
      type: TypeDefinitionBuilder()
          .withClassName(_className)
          .withUrl(_typeUrl)
          .build(),
      sharedPackageName: _sharedPackageName,
    );
  }

  ExceptionClassDefinitionBuilder withFileName(String fileName) {
    _fileName = fileName;
    return this;
  }

  ExceptionClassDefinitionBuilder withSourceFileName(String sourceFileName) {
    _sourceFileName = sourceFileName;
    return this;
  }

  ExceptionClassDefinitionBuilder withClassName(String className) {
    _className = className;
    return this;
  }

  ExceptionClassDefinitionBuilder withSubDirParts(List<String> subDirParts) {
    _subDirParts = subDirParts;
    return this;
  }

  ExceptionClassDefinitionBuilder withServerOnly(bool serverOnly) {
    _serverOnly = serverOnly;
    return this;
  }

  ExceptionClassDefinitionBuilder withField(
    SerializableModelFieldDefinition field,
  ) {
    _fields.add(() => field);
    return this;
  }

  ExceptionClassDefinitionBuilder withFields(
    List<SerializableModelFieldDefinition> fields,
  ) {
    _fields = fields
        .map(
          (f) =>
              () => f,
        )
        .toList();
    return this;
  }

  ExceptionClassDefinitionBuilder withDocumentation(
    List<String>? documentation,
  ) {
    _documentation = documentation;
    return this;
  }

  ExceptionClassDefinitionBuilder withSharedPackageName(
    String? sharedPackageName,
  ) {
    _sharedPackageName = sharedPackageName;
    return this;
  }

  ExceptionClassDefinitionBuilder withTypeUrl(String? url) {
    _typeUrl = url;
    return this;
  }

  ExceptionClassDefinitionBuilder withSimpleField(
    String fieldName,
    String type, {
    dynamic defaultModelValue,
    dynamic defaultPersistValue,
    bool nullable = false,
  }) {
    _fields.add(
      () => FieldDefinitionBuilder()
          .withName(fieldName)
          .withTypeDefinition(type, nullable)
          .withDefaults(
            defaultModelValue: defaultModelValue,
            defaultPersistValue: defaultPersistValue,
          )
          .build(),
    );
    return this;
  }

  ExceptionClassDefinitionBuilder withIsSealed(bool isSealed) {
    _isSealed = isSealed;
    return this;
  }

  ExceptionClassDefinitionBuilder withExtendsClass(
    ExceptionClassDefinition parentClass,
  ) {
    _extendsClass = ResolvedInheritanceDefinition<ExceptionClassDefinition>(
      parentClass,
    );
    return this;
  }

  ExceptionClassDefinitionBuilder withChildClasses(
    List<ExceptionClassDefinition> childClasses,
  ) {
    _childClasses = [
      for (var child in childClasses)
        ResolvedInheritanceDefinition<ExceptionClassDefinition>(child),
    ];
    return this;
  }
}
