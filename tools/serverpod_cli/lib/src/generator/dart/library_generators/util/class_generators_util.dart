import 'package:code_builder/code_builder.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/shared.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

Expression createClassExpression(bool hasImplicitClass, String className) {
  return switch (hasImplicitClass) {
    true => refer('${className}Implicit').property('_'),
    false => refer(className),
  };
}

String createFieldName(
  bool serverCode,
  SerializableModelFieldDefinition field,
) {
  if (field.hiddenSerializableField(serverCode)) {
    return createImplicitFieldName(field.name);
  }

  return field.name;
}

String createForeignFieldName(ListRelationDefinition relation) {
  if (relation.implicitForeignField) {
    return createImplicitFieldName(relation.foreignFieldName);
  }

  return relation.foreignFieldName;
}

String createImplicitFieldName(String fieldName) {
  return '\$$fieldName';
}

TypeReference typeWhereExpressionBuilder(
  String className,
  bool serverCode, {
  nullable = true,
}) {
  return _typeWithTableCallback(
    className,
    'WhereExpressionBuilder',
    serverCode,
    nullable: nullable,
  );
}

TypeReference typeOrderByBuilder(
  String className,
  bool serverCode, {
  nullable = true,
}) {
  return _typeWithTableCallback(
    className,
    'OrderByBuilder',
    serverCode,
    nullable: nullable,
  );
}

TypeReference typeOrderByListBuilder(
  String className,
  bool serverCode, {
  nullable = true,
}) {
  return _typeWithTableCallback(
    className,
    'OrderByListBuilder',
    serverCode,
    nullable: nullable,
  );
}

Expression buildFromJsonForField(
  SerializableModelFieldDefinition field,
  bool serverCode,
  GeneratorConfig config,
  List<String> subDirParts,
) {
  Reference jsonReference = refer('jsonSerialization');
  return _buildFromJson(
    jsonReference,
    field.type,
    serverCode,
    config,
    fieldName: field.name,
    subDirParts: subDirParts,
  );
}

TypeReference _typeWithTableCallback(
  String className,
  String typeName,
  bool serverCode, {
  nullable = true,
}) {
  return TypeReference(
    (t) => t
      ..symbol = typeName
      ..types.addAll([
        refer('${className}Table'),
      ])
      ..url = serverpodUrl(serverCode)
      ..isNullable = nullable,
  );
}

Expression _buildFromJson(
  Reference jsonReference,
  TypeDefinition type,
  bool serverCode,
  GeneratorConfig config, {
  String? fieldName,
  Expression? mapExpression,
  required List<String> subDirParts,
}) {
  Expression valueExpression =
      mapExpression ?? jsonReference.index(literalString(fieldName!));

  ValueType valueType = type.valueType;
  switch (valueType) {
    case ValueType.string:
    case ValueType.bool:
    case ValueType.int:
      return _buildPrimitiveTypeFromJson(
        type,
        valueExpression,
      );
    case ValueType.double:
      return _buildDoubleTypeFromJson(
        type,
        valueExpression,
      );
    case ValueType.dateTime:
    case ValueType.duration:
    case ValueType.byteData:
    case ValueType.uuidValue:
    case ValueType.uri:
    case ValueType.vector:
    case ValueType.halfVector:
    case ValueType.sparseVector:
    case ValueType.bit:
      return _buildComplexTypeFromJson(
        type,
        valueExpression,
        serverCode,
      );
    case ValueType.bigInt:
      return _buildComplexTypeFromJson(
        type,
        valueExpression,
        serverCode,
      );
    case ValueType.isEnum:
      EnumSerialization? enumSerialization = type.enumDefinition?.serialized;
      if (enumSerialization == null) {
        throw StateError("Expected 'enumSerialization' not to be null!");
      }
      return _buildEnumTypeFromJson(
        enumSerialization,
        type,
        valueExpression,
        serverCode,
        config,
        subDirParts,
      );
    case ValueType.list:
    case ValueType.set:
      return _buildListOrSetTypeFromJson(
        jsonReference,
        type,
        valueExpression,
        serverCode,
        config,
        valueType == ValueType.list,
        subDirParts,
      );
    case ValueType.map:
      return _buildMapTypeFromJson(
        jsonReference,
        type,
        valueExpression,
        serverCode,
        config,
        subDirParts,
      );
    case ValueType.classType:
      return _buildClassTypeFromJson(
        type,
        valueExpression,
        serverCode,
        config,
        subDirParts,
      );
    case ValueType.record:
      return _buildRecordTypeFromJson(
        type,
        valueExpression,
        serverCode,
        config,
        subDirParts,
      );
  }
}

Expression _buildPrimitiveTypeFromJson(
  TypeDefinition type,
  Expression valueExpression,
) {
  return CodeExpression(
    Block.of([
      valueExpression.code,
      Code('as ${type.className}'),
      if (type.nullable) const Code('?'),
    ]),
  );
}

Expression _buildDoubleTypeFromJson(
  TypeDefinition type,
  Expression valueExpression,
) {
  return CodeExpression(
    Block.of([
      valueExpression.asA(refer('num${type.nullable ? '?' : ''}')).code,
      Code('${type.nullable ? '?.' : '.'}toDouble()'),
    ]),
  );
}

Expression _buildComplexTypeFromJson(
  TypeDefinition type,
  Expression valueExpression,
  bool serverCode,
) {
  return CodeExpression(
    refer('${type.className}JsonExtension', serverpodUrl(serverCode))
        .property('fromJson')
        .call([valueExpression])
        .checkIfNull(type, valueExpression: valueExpression)
        .code,
  );
}

Expression _buildEnumTypeFromJson(
  EnumSerialization enumSerialization,
  TypeDefinition type,
  Expression valueExpression,
  bool serverCode,
  GeneratorConfig config,
  List<String> subDirParts,
) {
  Reference typeRef = type.asNonNullable.reference(
    serverCode,
    subDirParts: subDirParts,
    config: config,
  );

  Reference asReference;
  switch (enumSerialization) {
    case EnumSerialization.byIndex:
      asReference = refer('int');
      break;
    case EnumSerialization.byName:
      asReference = refer('String');
      break;
  }

  return CodeExpression(
    typeRef
        .property('fromJson')
        .call([valueExpression.asA(asReference)])
        .checkIfNull(type, valueExpression: valueExpression)
        .code,
  );
}

Expression _buildListOrSetTypeFromJson(
  Reference jsonReference,
  TypeDefinition type,
  Expression valueExpression,
  bool serverCode,
  GeneratorConfig config,
  bool isList,
  List<String> subDirParts,
) {
  if (type.isSetType) {
    return CodeExpression(Block.of([
      if (type.nullable) ...[
        valueExpression.code,
        const Code(' == null ? null :'),
      ],
      refer('${type.className}JsonExtension', serverpodUrl(serverCode)).code,
      const Code('.fromJson('),
      valueExpression
          .asA(const CodeExpression(
            // in both the `Set` and `List` cases, the data is persisted as a `List<T>`
            Code('List'),
          ))
          .code,
      const Code(', itemFromJson: (e) =>'),
      _buildFromJson(
        jsonReference,
        type.generics.first,
        serverCode,
        config,
        mapExpression: refer('e'),
        subDirParts: subDirParts,
      ).code,
      const Code(')'),
      if (type.isSetType && !type.nullable) const Code('!'),
    ]));
  }

  return CodeExpression(
    Block.of([
      valueExpression
          .asA(CodeExpression(
            Code('List${type.nullable ? '?' : ''}'),
          ))
          .code,
      Code('${type.nullable ? '?' : ''}.map((e) => '),
      _buildFromJson(
        jsonReference,
        type.generics.first,
        serverCode,
        config,
        mapExpression: refer('e'),
        subDirParts: subDirParts,
      ).code,
      const Code(').toList()'),
    ]),
  );
}

Expression _buildMapTypeFromJson(
  Reference jsonReference,
  TypeDefinition type,
  Expression valueExpression,
  bool serverCode,
  GeneratorConfig config,
  List<String> subDirParts,
) {
  if (type.generics.first.valueType == ValueType.string) {
    return CodeExpression(
      Block.of([
        const Code('('),
        valueExpression.code,
        Code(
          'as Map${type.nullable ? '?)?' : ')'}.map((k, v) =>',
        ),
        refer('MapEntry').call([
          _buildFromJson(
            jsonReference,
            type.generics.first,
            serverCode,
            config,
            mapExpression: refer('k'),
            subDirParts: subDirParts,
          ),
          _buildFromJson(
            jsonReference,
            type.generics.last,
            serverCode,
            config,
            mapExpression: refer('v'),
            subDirParts: subDirParts,
          ),
        ]).code,
        const Code(')'),
      ]),
    );
  }

  return CodeExpression(
    Block.of([
      valueExpression
          .asA(CodeExpression(Code('List${type.nullable ? '?' : ''}')))
          .code,
      Code('${type.nullable ? '?' : ''}.fold<Map<'),
      type.generics.first
          .reference(
            serverCode,
            subDirParts: subDirParts,
            config: config,
          )
          .code,
      const Code(','),
      type.generics.last
          .reference(
            serverCode,
            subDirParts: subDirParts,
            config: config,
          )
          .code,
      const Code('>>({}, (t, e) => {...t, '),
      _buildFromJson(
        jsonReference,
        type.generics.first,
        serverCode,
        config,
        mapExpression: refer('e').index(literalString('k')),
        subDirParts: subDirParts,
      ).code,
      const Code(':'),
      _buildFromJson(
        jsonReference,
        type.generics.last,
        serverCode,
        config,
        mapExpression: refer('e').index(literalString('v')),
        subDirParts: subDirParts,
      ).code,
      const Code('})'),
    ]),
  );
}

Expression _buildClassTypeFromJson(
  TypeDefinition type,
  Expression valueExpression,
  bool serverCode,
  GeneratorConfig config,
  List<String> subDirParts,
) {
  return CodeExpression(
    type.asNonNullable
        .reference(
          serverCode,
          subDirParts: subDirParts,
          config: config,
        )
        .property('fromJson')
        .call([
          if (type.customClass)
            valueExpression
          else
            valueExpression.asA(refer('Map<String, dynamic>')),
        ])
        .checkIfNull(type, valueExpression: valueExpression)
        .code,
  );
}

Expression _buildRecordTypeFromJson(
  TypeDefinition type,
  Expression valueExpression,
  bool serverCode,
  GeneratorConfig config,
  List<String> subDirParts,
) {
  var protocolRef = refer(
    'Protocol',
    serverCode
        ? 'package:${config.serverPackage}/src/generated/protocol.dart'
        : 'package:${config.dartClientPackage}/src/protocol/protocol.dart',
  );

  return CodeExpression(Block.of([
    if (type.nullable) ...[
      valueExpression.code,
      const Code('== null ? null : '),
    ],
    protocolRef
        .newInstance([])
        .property('deserialize')
        .call(
          [valueExpression.asA(refer('Map<String, dynamic>'))],
          {},
          [
            type.reference(serverCode, config: config, subDirParts: subDirParts)
          ],
        )
        .code,
  ]));
}

extension ExpressionExtension on Expression {
  Expression checkIfNull(
    TypeDefinition type, {
    required Expression valueExpression,
  }) {
    if (!type.nullable) return this;
    return CodeExpression(
      Block.of(
        [
          valueExpression.code,
          const Code('== null ? null : '),
          code,
        ],
      ),
    );
  }
}
