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
  Expression valueExpression =
      mapExpression ?? jsonReference.index(literalString(fieldName!));

  ValueType valueType = _getValueType(type);
  switch (valueType) {
    case ValueType.int:
    case ValueType.double:
    case ValueType.string:
    case ValueType.bool:
      return _expressionPrimitiveTypeBuilder(
        type,
        valueExpression,
      );
    case ValueType.dateTime:
    case ValueType.duration:
    case ValueType.byteData:
    case ValueType.uuidValue:
      return _expressionOtherTypeBuilder(
        type,
        valueExpression,
        serverCode,
      );
    case ValueType.isEnum:
      return _expressionEnumTypeBuilder(
        type,
        valueExpression,
        serverCode,
        config,
        classDefinition,
      );
    case ValueType.list:
    case ValueType.set:
      return _expressionListOrSetTypeBuilder(
        type,
        valueExpression,
        serverCode,
        config,
        classDefinition,
        valueType == ValueType.list,
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
        serverCode,
        config,
        classDefinition,
      );
  }
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

Expression _expressionOtherTypeBuilder(
  TypeDefinition type,
  Expression valueExpression,
  bool serverCode,
) {
  return CodeExpression(
    refer('${type.className}Ext', serializationUrl(serverCode))
        .property('fromJson')
        .call([valueExpression])
        .checkIfNull(type, valueExpression: valueExpression)
        .code,
  );
}

Expression _expressionEnumTypeBuilder(
  TypeDefinition type,
  Expression valueExpression,
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
    typRef
        .property('fromJson')
        .call([valueExpression.asA(asReference)])
        .checkIfNull(type, valueExpression: valueExpression)
        .code,
  );
}

Expression _expressionListOrSetTypeBuilder(
  TypeDefinition type,
  Expression valueExpression,
  bool serverCode,
  GeneratorConfig config,
  ClassDefinition classDefinition,
  bool isList,
) {
  return CodeExpression(
    Block.of([
      valueExpression
          .asA(CodeExpression(
            Code('${isList ? 'List' : 'Set'}${type.nullable ? '?' : ''}'),
          ))
          .code,
      Code('${type.nullable ? '?' : ''}.map((e) => '),
      _expressionTypeBuilder(
        type.generics.first,
        serverCode,
        config,
        classDefinition,
        mapExpression: refer('e'),
      ).code,
      Code(')${isList ? '.toList()' : ''}'),
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
      valueExpression
          .asA(CodeExpression(Code('List${type.nullable ? '?' : ''}')))
          .code,
      Code('${type.nullable ? '?' : ''}.fold<Map<'),
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
  bool serverCode,
  GeneratorConfig config,
  ClassDefinition classDefinition,
) {
  return CodeExpression(
    type.asNonNullable
        .reference(
          serverCode,
          subDirParts: classDefinition.subDirParts,
          config: config,
        )
        .property('fromJson')
        .call([valueExpression.asA(refer('Map<String, dynamic>'))])
        .checkIfNull(type, valueExpression: valueExpression)
        .code,
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
          const Code('== null ? null : '),
          code,
        ],
      ),
    );
  }
}
