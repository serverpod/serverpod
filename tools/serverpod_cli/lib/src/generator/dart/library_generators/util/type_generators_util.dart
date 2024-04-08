import 'package:code_builder/code_builder.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/shared.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

enum ValueType {
  int,
  double,
  string,
  bool,
  dateTime,
  duration,
  byteData,
  uuidValue,
  list,
  set,
  map,
  isEnum,
  classType,
}

Expression expressionFromJsonBuilder(
  SerializableModelFieldDefinition field,
  bool serverCode,
  GeneratorConfig config,
  ClassDefinition classDefinition,
) {
  return _expressionTypeBuilder(
    field.type,
    serverCode,
    config,
    classDefinition,
    fieldName: field.name,
  );
}

ValueType _getValueType(TypeDefinition type) {
  if (type.className == 'int') return ValueType.int;
  if (type.className == 'double') return ValueType.double;
  if (type.className == 'String') return ValueType.string;
  if (type.className == 'bool') return ValueType.bool;
  if (type.className == 'DateTime') return ValueType.dateTime;
  if (type.className == 'Duration') return ValueType.duration;
  if (type.className == 'ByteData') return ValueType.byteData;
  if (type.className == 'UuidValue') return ValueType.uuidValue;
  if (type.className == 'List') return ValueType.list;
  if (type.className == 'Set') return ValueType.set;
  if (type.className == 'Map') return ValueType.map;
  if (type.isEnumType) return ValueType.isEnum;
  return ValueType.classType;
}

Expression _expressionTypeBuilder(
  TypeDefinition type,
  bool serverCode,
  GeneratorConfig config,
  ClassDefinition classDefinition, {
  String? fieldName,
  Expression? mapExpression,
}) {
  Reference jsonReference = refer('jsonSerialization');
  Expression? containsKeyExpression = mapExpression != null ||
          type.nullable == false
      ? null
      : jsonReference.property('containsKey').call([literalString(fieldName!)]);

  Expression valueExpression =
      mapExpression ?? jsonReference.index(literalString(fieldName!));

  switch (_getValueType(type)) {
    case ValueType.int:
    case ValueType.double:
    case ValueType.string:
    case ValueType.bool:
      return _expressionPrimitiveTypeBuilder(
        type,
        valueExpression,
      );
    case ValueType.dateTime:
      return _expressionDateTimeTypeBuilder(
        type,
        valueExpression,
      );
    case ValueType.duration:
      return _expressionDurationTypeBuilder(
        type,
        valueExpression,
        containsKeyExpression,
      );
    case ValueType.byteData:
      return _expressionByteDataBuilder(
        type,
        valueExpression,
        containsKeyExpression,
      );
    case ValueType.uuidValue:
      return _expressionUuidValueTypeBuilder(
        type,
        valueExpression,
        containsKeyExpression,
      );
    case ValueType.isEnum:
      return _expressionEnumTypeBuilder(
        type,
        valueExpression,
        containsKeyExpression,
        serverCode,
        config,
        classDefinition,
      );
    case ValueType.list:
      return _expressionListTypeBuilder(
        type,
        jsonReference,
        valueExpression,
        serverCode,
        config,
        classDefinition,
      );
    case ValueType.set:
      return _expressionSetTypeBuilder(
        type,
        valueExpression,
        serverCode,
        config,
        classDefinition,
      );
    case ValueType.map:
      return _expressionMapTypeBuilder(
        type,
        valueExpression,
        serverCode,
        config,
        classDefinition,
      );
    default:
      return _expressionClassTypeBuilder(
        type,
        valueExpression,
        containsKeyExpression,
        serverCode,
        config,
        classDefinition,
      );
  }
}

List<Code> _containsKeyWrapper(
  Expression? containsKeyExpression,
  List<Code> body,
) {
  if (containsKeyExpression == null) return body;
  return [
    containsKeyExpression.code,
    const Code('?'),
    ...body,
    const Code(': null'),
  ];
}

Expression _expressionPrimitiveTypeBuilder(
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

Expression _expressionDateTimeTypeBuilder(
  TypeDefinition type,
  Expression valueExpression,
) {
  return CodeExpression(
    refer('DateTime')
        .property(type.nullable ? 'tryParse' : 'parse')
        .call(
          [
            type.nullable
                ? valueExpression
                : valueExpression.asA(const CodeExpression(Code('String')))
          ],
        )
        .checkIfNull(type, valueExpression: valueExpression)
        .code,
  );
}

Expression _expressionDurationTypeBuilder(
  TypeDefinition type,
  Expression valueExpression,
  Expression? containsKeyExpression,
) {
  return CodeExpression(
    Block.of(
      _containsKeyWrapper(
        containsKeyExpression,
        [
          refer('Duration')
              .call([], {'milliseconds': valueExpression})
              .checkIfNull(type, valueExpression: valueExpression)
              .code
        ],
      ),
    ),
  );
}

Expression _expressionByteDataBuilder(
  TypeDefinition type,
  Expression valueExpression,
  Expression? containsKeyExpression,
) {
  return CodeExpression(
    Block.of(
      _containsKeyWrapper(
        containsKeyExpression,
        [
          if (!type.nullable) const Code('('),
          if (!type.nullable) valueExpression.code,
          if (!type.nullable) const Code('!= null &&'),
          valueExpression.code,
          const Code('is'),
          refer('Uint8List', byteDataUrl).code,
          const Code('?'),
          refer('ByteData', byteDataUrl).property('view').call([
            valueExpression.property('buffer'),
            valueExpression.property('offsetInBytes'),
            valueExpression.property('lengthInBytes'),
          ]).code,
          const Code(': ('),
          valueExpression.code,
          const Code(' as String?)?.base64DecodedByteData()'),
          if (!type.nullable) const Code(')!'),
        ],
      ),
    ),
  );
}

Expression _expressionUuidValueTypeBuilder(
  TypeDefinition type,
  Expression valueExpression,
  Expression? containsKeyExpression,
) {
  return CodeExpression(
    Block.of(
      _containsKeyWrapper(
        containsKeyExpression,
        [
          refer('UuidValue', uuidValueUrl)
              .property('fromString')
              .call([valueExpression])
              .checkIfNull(type, valueExpression: valueExpression)
              .code,
        ],
      ),
    ),
  );
}

Expression _expressionEnumTypeBuilder(
  TypeDefinition type,
  Expression valueExpression,
  Expression? containsKeyExpression,
  bool serverCode,
  GeneratorConfig config,
  ClassDefinition classDefinition,
) {
  Reference typRef = type.asNonNullable.reference(serverCode,
      subDirParts: classDefinition.subDirParts, config: config);

  EnumSerialization? enumSerialization = type.serializeEnum;
  if (enumSerialization == null) {
    throw TypeError();
  }

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
    Block.of(
      _containsKeyWrapper(
        containsKeyExpression,
        [
          typRef
              .property('fromJson')
              .call([valueExpression.asA(asReference)])
              .checkIfNull(type, valueExpression: valueExpression)
              .code,
        ],
      ),
    ),
  );
}

Expression _expressionListTypeBuilder(
  TypeDefinition type,
  Reference jsonReference,
  Expression valueExpression,
  bool serverCode,
  GeneratorConfig config,
  ClassDefinition classDefinition,
) {
  return CodeExpression(
    Block.of([
      const Code('('),
      valueExpression.code,
      Code(
        ' as List<dynamic>${type.nullable ? '?)?' : ')'}.map((e) => ',
      ),
      _expressionTypeBuilder(
        type.generics.first,
        serverCode,
        config,
        classDefinition,
        mapExpression: refer('e'),
      ).code,
      const Code(').toList()'),
    ]),
  );
}

Expression _expressionSetTypeBuilder(
  TypeDefinition type,
  Expression valueExpression,
  bool serverCode,
  GeneratorConfig config,
  ClassDefinition classDefinition,
) {
  return CodeExpression(
    Block.of([
      const Code('('),
      valueExpression.code,
      Code(
        ' as Set<dynamic>${type.nullable ? '?)?' : ')'}.map((e) => ',
      ),
      _expressionTypeBuilder(
        type.generics.first,
        serverCode,
        config,
        classDefinition,
        mapExpression: refer('e'),
      ).code,
      const Code(')'),
    ]),
  );
}

Expression _expressionMapTypeBuilder(
  TypeDefinition type,
  Expression valueExpression,
  bool serverCode,
  GeneratorConfig config,
  ClassDefinition classDefinition,
) {
  if (_getValueType(type.generics.first) == ValueType.string) {
    return CodeExpression(
      Block.of([
        const Code('('),
        valueExpression.code,
        Code(
          'as Map<dynamic, dynamic> ${type.nullable ? '?)?' : ')'}.map((k, v) =>',
        ),
        refer('MapEntry').call([
          _expressionTypeBuilder(
            type.generics.first,
            serverCode,
            config,
            classDefinition,
            mapExpression: refer('k'),
          ),
          _expressionTypeBuilder(
            type.generics.last,
            serverCode,
            config,
            classDefinition,
            mapExpression: refer('v'),
          ),
        ]).code,
        const Code(')'),
      ]),
    );
  }

  return CodeExpression(
    Block.of([
      const Code('('),
      valueExpression.code,
      Code(
        'as List<dynamic> ${type.nullable ? '?)?' : ')'}'
        '.fold<Map<',
      ),
      type.generics.first
          .reference(
            serverCode,
            subDirParts: classDefinition.subDirParts,
            config: config,
          )
          .code,
      const Code(','),
      type.generics.last
          .reference(
            serverCode,
            subDirParts: classDefinition.subDirParts,
            config: config,
          )
          .code,
      const Code('>>({}, (t, e) => {...t, '),
      _expressionTypeBuilder(
        type.generics.first,
        serverCode,
        config,
        classDefinition,
        mapExpression: refer('e').index(literalString('k')),
      ).code,
      const Code(':'),
      _expressionTypeBuilder(
        type.generics.last,
        serverCode,
        config,
        classDefinition,
        mapExpression: refer('e').index(literalString('v')),
      ).code,
      const Code('})'),
    ]),
  );
}

Expression _expressionClassTypeBuilder(
  TypeDefinition type,
  Expression valueExpression,
  Expression? containsKeyExpression,
  bool serverCode,
  GeneratorConfig config,
  ClassDefinition classDefinition,
) {
  Reference typeRef = type.asNonNullable.reference(serverCode,
      subDirParts: classDefinition.subDirParts, config: config);

  return CodeExpression(
    Block.of(
      _containsKeyWrapper(
        containsKeyExpression,
        [
          typeRef
              .property('fromJson')
              .call([
                CodeExpression(
                  Block.of(
                    [
                      valueExpression.code,
                      const Code('as Map<String, dynamic>'),
                    ],
                  ),
                )
              ])
              .checkIfNull(type, valueExpression: valueExpression)
              .code,
        ],
      ),
    ),
  );
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
          const Code('!= null ?'),
          code,
          const Code(': null'),
        ],
      ),
    );
  }
}
