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
  Reference? reference,
}) {
  Reference jsonReference = refer('jsonSerialization');
  Expression valueExpression =
      reference ?? jsonReference.index(literalString(fieldName!));

  switch (_getValueType(type)) {
    case ValueType.int:
    case ValueType.double:
    case ValueType.string:
    case ValueType.bool:
      return _expressionPrimitiveTypeBuilder(
        type,
        jsonReference,
        valueExpression,
      );
    case ValueType.dateTime:
      return _expressionDateTimeTypeBuilder(
        type,
        jsonReference,
        valueExpression,
      );
    case ValueType.duration:
      return _expressionDurationTypeBuilder(
        type,
        jsonReference,
        valueExpression,
        fieldName: fieldName,
        reference: reference,
      );
    case ValueType.byteData:
      return _expressionByteDataBuilder(
        type,
        jsonReference,
        valueExpression,
        fieldName: fieldName,
        reference: reference,
      );
    case ValueType.uuidValue:
      return _expressionUuidValueTypeBuilder(
        type,
        jsonReference,
        valueExpression,
        fieldName: fieldName,
        reference: reference,
      );
    case ValueType.isEnum:
      return _expressionEnumTypeBuilder(
        type,
        jsonReference,
        valueExpression,
        serverCode,
        config,
        classDefinition,
        fieldName: fieldName,
        reference: reference,
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
        jsonReference,
        valueExpression,
        serverCode,
        config,
        classDefinition,
      );
    case ValueType.map:
      return _expressionMapTypeBuilder(
        type,
        jsonReference,
        valueExpression,
        serverCode,
        config,
        classDefinition,
      );
    default:
      return _expressionClassTypeBuilder(
        type,
        jsonReference,
        valueExpression,
        serverCode,
        config,
        classDefinition,
        fieldName: fieldName,
        reference: reference,
      );
  }
}

List<Code> _nullCheckWrapper(
  bool shouldWrap,
  String? fieldName,
  Reference jsonReference,
  List<Code> body,
) {
  if (!shouldWrap) return body;
  return [
    jsonReference
        .property('containsKey')
        .call([literalString(fieldName!)]).code,
    const Code('?'),
    ...body,
    const Code(': null'),
  ];
}

Expression _expressionPrimitiveTypeBuilder(
  TypeDefinition type,
  Reference jsonReference,
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
  Reference jsonReference,
  Expression valueExpression,
) {
  return CodeExpression(
    refer('DateTime').property(type.nullable ? 'tryParse' : 'parse').call(
      [
        type.nullable
            ? valueExpression.ifNullThen(const CodeExpression(Code('\'\'')))
            : valueExpression.asA(const CodeExpression(Code('String'))),
      ],
    ).code,
  );
}

Expression _expressionDurationTypeBuilder(
  TypeDefinition type,
  Reference jsonReference,
  Expression valueExpression, {
  String? fieldName,
  Reference? reference,
}) {
  return CodeExpression(
    Block.of(
      _nullCheckWrapper(
        type.nullable && reference == null,
        fieldName,
        jsonReference,
        [
          refer('Duration').call([], {'milliseconds': valueExpression}).code
        ],
      ),
    ),
  );
}

Expression _expressionByteDataBuilder(
  TypeDefinition type,
  Reference jsonReference,
  Expression valueExpression, {
  String? fieldName,
  Reference? reference,
}) {
  return CodeExpression(
    Block.of(
      _nullCheckWrapper(
        type.nullable && reference == null,
        fieldName,
        jsonReference,
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
  Reference jsonReference,
  Expression valueExpression, {
  String? fieldName,
  Reference? reference,
}) {
  return CodeExpression(
    Block.of(
      _nullCheckWrapper(
        type.nullable && reference == null,
        fieldName,
        jsonReference,
        [
          refer('UuidValue', uuidValueUrl)
              .property('fromString')
              .call([valueExpression]).code,
        ],
      ),
    ),
  );
}

Expression _expressionEnumTypeBuilder(
  TypeDefinition type,
  Reference jsonReference,
  Expression valueExpression,
  bool serverCode,
  GeneratorConfig config,
  ClassDefinition classDefinition, {
  String? fieldName,
  Reference? reference,
}) {
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
      _nullCheckWrapper(
        type.nullable && reference == null,
        fieldName,
        jsonReference,
        [
          typRef
              .property('fromJson')
              .call([valueExpression.asA(asReference)]).code,
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
        reference: refer('e'),
      ).code,
      const Code(').toList()'),
    ]),
  );
}

Expression _expressionSetTypeBuilder(
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
        ' as Set<dynamic>${type.nullable ? '?)?' : ')'}.map((e) => ',
      ),
      _expressionTypeBuilder(
        type.generics.first,
        serverCode,
        config,
        classDefinition,
        reference: refer('e'),
      ).code,
      const Code(')'),
    ]),
  );
}

Expression _expressionMapTypeBuilder(
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
        'as Map<dynamic, dynamic> ${type.nullable ? '?)?' : ')'}.map((k, v) =>',
      ),
      refer('MapEntry').call([
        _expressionTypeBuilder(
          type.generics.first,
          serverCode,
          config,
          classDefinition,
          reference: refer('k'),
        ),
        _expressionTypeBuilder(
          type.generics.last,
          serverCode,
          config,
          classDefinition,
          reference: refer('v'),
        ),
      ]).code,
      const Code(')'),
    ]),
  );
}

Expression _expressionClassTypeBuilder(
  TypeDefinition type,
  Reference jsonReference,
  Expression valueExpression,
  bool serverCode,
  GeneratorConfig config,
  ClassDefinition classDefinition, {
  String? fieldName,
  Reference? reference,
}) {
  Reference typeRef = type.asNonNullable.reference(serverCode,
      subDirParts: classDefinition.subDirParts, config: config);

  return CodeExpression(
    Block.of(
      _nullCheckWrapper(
        type.nullable && reference == null,
        fieldName,
        jsonReference,
        [
          typeRef.property('fromJson').call([
            CodeExpression(
              Block.of(
                [
                  valueExpression.code,
                  const Code('as Map<String, dynamic>'),
                ],
              ),
            )
          ]).code,
        ],
      ),
    ),
  );
}
