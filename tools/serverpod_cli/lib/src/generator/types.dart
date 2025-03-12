import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart' as code_builder;
import 'package:code_builder/code_builder.dart' hide RecordType;
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/keywords.dart';
import 'package:serverpod_cli/src/generator/shared.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/string_manipulation.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../config/config.dart';

const _moduleRef = 'module:';
const _projectRef = 'project:';
const _packageRef = 'package:';

/// Contains information about the type of fields, arguments and return values.
class TypeDefinition {
  /// The class name of the type.
  final String className;

  /// The generics the type has.
  ///
  /// For record types this contains the fields.
  /// Positional fields are defined by their index in this list, and named
  /// field have a non-`null` [recordFieldName]
  final List<TypeDefinition> generics;

  final String? url;

  /// The name of the field when used as a named record field.
  ///
  /// Only set for [TypeDefinition]s used inside [generics].
  final String? recordFieldName;

  /// Populated if type is a model that is defined in the project. I.e. not a
  /// module or serverpod model.
  final SerializableModelDefinition? projectModelDefinition;

  /// Whether this type is nullable.
  final bool nullable;

  final DartType? dartType;

  /// True if this type references a custom class.
  final bool customClass;

  EnumDefinition? enumDefinition;

  /// Creates an [TypeDefinition] from a given [DartType].
  /// throws [FromDartTypeClassNameException] if the class name could not be
  /// determined.
  factory TypeDefinition.fromDartType(
    DartType type, {
    String? recordFieldName,
  }) {
    var nullable = type.nullabilitySuffix == NullabilitySuffix.question;
    var url = type.element?.librarySource?.uri.toString();

    if (type is RecordType) {
      var positionalField = type.positionalFields
          .map((f) => TypeDefinition.fromDartType(f.type))
          .toList();
      var namedFields = type.namedFields
          .map((f) =>
              TypeDefinition.fromDartType(f.type, recordFieldName: f.name))
          .toList();

      return TypeDefinition(
        className: RecordKeyword.className,
        nullable: nullable,
        dartType: type,
        generics: [...positionalField, ...namedFields],
        url: url,
        recordFieldName: recordFieldName,
      );
    }

    var generics = (type is ParameterizedType)
        ? type.typeArguments.map((e) => TypeDefinition.fromDartType(e)).toList()
        : <TypeDefinition>[];

    var className = type is! VoidType ? type.element?.displayName : 'void';

    if (className == null) {
      throw FromDartTypeClassNameException(type);
    }

    return TypeDefinition(
      className: className,
      nullable: nullable,
      dartType: type,
      generics: generics,
      url: url,
      recordFieldName: recordFieldName,
    );
  }

  TypeDefinition({
    required this.className,
    this.generics = const [],
    required this.nullable,
    this.url,
    this.dartType,
    this.customClass = false,
    this.enumDefinition,
    this.projectModelDefinition,
    this.recordFieldName,
  });

  bool get isSerializedValue => autoSerializedTypes.contains(className);

  bool get isSerializedByExtension =>
      extensionSerializedTypes.contains(className);

  bool get isListType => className == ListKeyword.className;

  bool get isSetType => className == SetKeyword.className;

  bool get isMapType => className == MapKeyword.className;

  bool get isRecordType => className == RecordKeyword.className;

  bool get isIdType => SupportedIdType.all.any((e) => e.className == className);

  bool get isVoidType => className == 'void';

  bool get isStreamType => className == 'Stream';

  bool get isFutureType => className == 'Future';

  bool get isModuleType =>
      url == 'serverpod' || (url?.startsWith(_moduleRef) ?? false);

  bool get isEnumType => enumDefinition != null;

  String? get moduleAlias {
    if (url == defaultModuleAlias) return url;
    if (url == 'serverpod') return url;
    if (url?.startsWith(_moduleRef) ?? false) {
      return url?.substring(_moduleRef.length);
    }
    if (url?.startsWith(_projectRef) ?? false) {
      return null;
    }
    if (url?.startsWith(_packageRef) ?? false) {
      return null;
    }
    return url;
  }

  /// Creates an [TypeDefinition] from [mixed] where the [url]
  /// and [className] is separated by ':'.
  factory TypeDefinition.mixedUrlAndClassName({
    required String mixed,
    List<TypeDefinition> generics = const [],
    required bool nullable,
    bool customClass = false,
  }) {
    var parts = mixed.split(':');
    var classname = parts.last;
    var url = mixed != 'ByteData'
        ? (parts..removeLast()).join(':')
        : 'dart:typed_data';

    return TypeDefinition(
      className: classname,
      nullable: nullable,
      generics: generics,
      url: url.isNotEmpty ? url : null,
      customClass: customClass,
    );
  }

  /// A convenience variable for getting a [TypeDefinition] of a non null int
  /// quickly.
  static TypeDefinition int = TypeDefinition(className: 'int', nullable: false);

  /// Get this [TypeDefinition], but nullable.
  TypeDefinition get asNullable => TypeDefinition(
        className: className,
        url: url,
        nullable: true,
        customClass: customClass,
        dartType: dartType,
        generics: generics,
        enumDefinition: enumDefinition,
        projectModelDefinition: projectModelDefinition,
        recordFieldName: recordFieldName,
      );

  /// Get this [TypeDefinition], but non nullable.
  TypeDefinition get asNonNullable => TypeDefinition(
        className: className,
        url: url,
        nullable: false,
        customClass: customClass,
        dartType: dartType,
        generics: generics,
        enumDefinition: enumDefinition,
        projectModelDefinition: projectModelDefinition,
        recordFieldName: recordFieldName,
      );

  static String getRef(SerializableModelDefinition model) {
    if (model is ModelClassDefinition) {
      var sealedTopNode = model.sealedTopNode;
      if (sealedTopNode != null) {
        return sealedTopNode.fileRef();
      }
    }
    return model.fileRef();
  }

  /// Generate a [Reference] from this definition.
  ///
  /// For classes this will be a [TypeReference],
  /// while records return a [RecordType].
  Reference reference(
    bool serverCode, {
    bool? nullable,
    List<String> subDirParts = const [],
    required GeneratorConfig config,
    String? typeSuffix,
  }) {
    if (isRecordType) {
      return code_builder.RecordType((b) {
        b.positionalFieldTypes.addAll(
          generics
              .where((f) => f.recordFieldName == null)
              .map((f) => f.reference(serverCode, config: config)),
        );

        b.namedFieldTypes.addAll({
          for (var namedField
              in generics.where((f) => f.recordFieldName != null))
            namedField.recordFieldName!: namedField.reference(
              serverCode,
              config: config,
            ),
        });

        b.isNullable = nullable ?? this.nullable;
      });
    }
    assert(dartType is! RecordType);

    return TypeReference(
      (t) {
        if (url?.startsWith('${_moduleRef}serverpod') ?? false) {
          // module:serverpod reference
          t.url = serverpodUrl(serverCode);
        } else if (url?.startsWith(_moduleRef) ?? false) {
          // module:nickname: reference
          var moduleName = url?.substring(_moduleRef.length);
          var module = config.modules.cast<ModuleConfig?>().firstWhere(
                (m) => m?.nickname == moduleName,
                orElse: () => null,
              );
          if (module == null) {
            throw FormatException(
                'Module with nickname $moduleName not found in config!');
          }
          var packageName =
              serverCode ? module.serverPackage : module.dartClientPackage;
          t.url = 'package:$packageName/$packageName.dart';
        } else if (url == 'serverpod' ||
            (url == null && ['UuidValue'].contains(className))) {
          // serverpod: reference
          t.url = serverpodUrl(serverCode);
        } else if (url?.startsWith('project:') ?? false) {
          // project:path:reference
          var split = url!.split(':');
          t.url = 'package:'
              '${serverCode ? config.serverPackage : config.dartClientPackage}'
              '/${split[1]}';
        } else if (url == defaultModuleAlias) {
          // protocol: reference
          var localProjectModelDefinition = projectModelDefinition;
          String reference = switch (localProjectModelDefinition) {
            // Import model directly
            SerializableModelDefinition modelDefinition =>
              getRef(modelDefinition),
            // Import model through generated protocol file
            null => 'protocol.dart',
          };

          t.url = p.posix.joinAll([...subDirParts.map((e) => '..'), reference]);
        } else if (!serverCode &&
            (url?.startsWith('package:${config.serverPackage}') ?? false)) {
          // import from the server package
          t.url = url
              ?.replaceFirst('package:${config.serverPackage}',
                  'package:${config.dartClientPackage}')
              .replaceFirst('src/generated/', 'src/protocol/');
        } else if (config.modules.any(
            (m) => url?.startsWith('package:${m.serverPackage}') ?? false)) {
          // endpoint definition references from an module
          var module = config.modules.firstWhere(
              (m) => url?.startsWith('package:${m.serverPackage}') ?? false);
          var packageName =
              serverCode ? module.serverPackage : module.dartClientPackage;
          t.url = url!.contains('/src/generated/')
              ? 'package:$packageName/$packageName.dart'
              : serverCode
                  ? url
                  : url?.replaceFirst('package:${module.serverPackage}',
                      'package:${module.dartClientPackage}');
        } else {
          t.url = url;
        }
        t.isNullable = nullable ?? this.nullable;
        t.symbol = typeSuffix != null ? '$className$typeSuffix' : className;
        t.types.addAll(generics.map(
          (e) => e.reference(
            serverCode,
            subDirParts: subDirParts,
            config: config,
          ),
        ));
      },
    );
  }

  /// Get the pgsql type that represents this [TypeDefinition] in the database.
  String get databaseType {
    // TODO: add all supported types here
    var enumSerialization = enumDefinition?.serialized;
    if (enumSerialization != null && isEnumType) {
      switch (enumSerialization) {
        case EnumSerialization.byName:
          return 'text';
        case EnumSerialization.byIndex:
          return 'bigint';
      }
    }
    if (className == 'int') return 'bigint';
    if (className == 'double') return 'double precision';
    if (className == 'bool') return 'boolean';
    if (className == 'String') return 'text';
    if (className == 'DateTime') return 'timestamp without time zone';
    if (className == 'ByteData') return 'bytea';
    if (className == 'Duration') return 'bigint';
    if (className == 'UuidValue') return 'uuid';
    if (className == 'Uri') return 'text';
    if (className == 'BigInt') return 'text';

    return 'json';
  }

  /// Get the enum name of the [ColumnType], representing this [TypeDefinition]
  /// in the database.
  String get databaseTypeEnum {
    return databaseTypeToLowerCamelCase(databaseType);
  }

  /// Get the [Column] extending class name representing this [TypeDefinition].
  String get columnType {
    if (isEnumType) return 'ColumnEnum';
    if (className == 'int') return 'ColumnInt';
    if (className == 'double') return 'ColumnDouble';
    if (className == 'bool') return 'ColumnBool';
    if (className == 'String') return 'ColumnString';
    if (className == 'DateTime') return 'ColumnDateTime';
    if (className == 'ByteData') return 'ColumnByteData';
    if (className == 'Duration') return 'ColumnDuration';
    if (className == 'UuidValue') return 'ColumnUuid';
    if (className == 'Uri') return 'ColumnUri';
    if (className == 'BigInt') return 'ColumnBigInt';

    return 'ColumnSerializable';
  }

  /// Retrieves the generic from this type.
  /// Throws a [FormatException] if no generic is found.
  TypeDefinition retrieveGenericType() {
    var genericType = generics.firstOrNull;
    if (genericType == null) {
      throw FormatException('$this does not have a generic type to retrieve.');
    }

    return genericType;
  }

  /// Generates the constructors for List and Map types
  List<MapEntry<Expression, Code>> generateDeserialization(
    bool serverCode, {
    required GeneratorConfig config,
  }) {
    if (isRecordType) {
      var positionalFields =
          generics.where((f) => f.recordFieldName == null).toList();
      var namedFields =
          generics.where((f) => f.recordFieldName != null).toList();

      return [
        MapEntry(
          refer('getType', serverpodUrl(serverCode))
              .call([], {}, [reference(serverCode, config: config)]),
          Block.of(
            [
              if (nullable) const Code(' (data == null) ? null as T : '),
              const Code('('),
              for (final (i, positionalField) in positionalFields.indexed) ...[
                if (positionalField.nullable)
                  Code(
                      "((data ${i == 0 ? 'as Map' : ''})['p'] as List)[$i] == null ? null : "),
                const Code('deserialize<'),
                positionalField
                    .reference(serverCode, config: config, nullable: false)
                    .code,
                const Code('>('),
                if (i == 0 && !positionalField.nullable) ...[
                  Code("((data as Map)['p'] as List)[$i]"),
                ] else
                  Code("data['p'][$i]"),
                const Code(')'),
                const Code(','),
              ],
              if (namedFields.isNotEmpty) ...[
                for (final (i, namedField) in namedFields.indexed) ...[
                  Code(namedField.recordFieldName!),
                  const Code(':'),
                  if (namedField.nullable)
                    Code(
                        "((data ${i == 0 && positionalFields.isEmpty ? 'as Map' : ''})['n'] as Map)['${namedField.recordFieldName!}'] == null ? null : "),
                  const Code('deserialize<'),
                  namedField
                      .reference(serverCode, config: config, nullable: false)
                      .code,
                  const Code('>('),
                  if (i == 0 &&
                      positionalFields.isEmpty &&
                      !namedField.nullable)
                    Code(
                        "((data as Map)['n'] as Map)['${namedField.recordFieldName!}']")
                  else
                    Code("data['n']['${namedField.recordFieldName!}']"),
                  const Code(')'),
                  const Code(','),
                ],
              ],
              const Code(') as T'),
            ],
          ),
        ),
      ];
    } else if ((className == ListKeyword.className ||
            className == SetKeyword.className) &&
        generics.length == 1) {
      return [
        MapEntry(
          nullable
              ? refer('getType', serverpodUrl(serverCode))
                  .call([], {}, [reference(serverCode, config: config)])
              : reference(serverCode, config: config),
          Block.of([
            nullable
                ? Block.of([
                    // using Code.scope only sets the generic to List
                    const Code('(data!=null?'
                        '(data as List).map((e) =>'
                        'deserialize<'),
                    generics.first.reference(serverCode, config: config).code,
                    Code('>(e))${className == 'Set' ? '.toSet()' : '.toList()'}'
                        ':null) as T')
                  ])
                : Block.of([
                    const Code('(data as List).map((e) =>'
                        'deserialize<'),
                    generics.first.reference(serverCode, config: config).code,
                    Code(
                        '>(e))${className == 'Set' ? '.toSet()' : '.toList()'} as T'),
                  ])
          ]),
        ),
        ...generics.first.generateDeserialization(serverCode, config: config),
      ];
    } else if (className == MapKeyword.className && generics.length == 2) {
      return [
        MapEntry(
          nullable
              ? refer('getType', serverpodUrl(serverCode))
                  .call([], {}, [reference(serverCode, config: config)])
              : reference(serverCode, config: config),
          Block.of([
            generics.first.className == 'String'
                ? nullable
                    ? Block.of([
                        // using Code.scope only sets the generic to List
                        const Code('(data!=null?'
                            '(data as Map).map((k,v) =>'
                            'MapEntry(deserialize<'),
                        generics.first
                            .reference(serverCode, config: config)
                            .code,
                        const Code('>(k),deserialize<'),
                        generics[1].reference(serverCode, config: config).code,
                        const Code('>(v)))' ':null) as T')
                      ])
                    : Block.of([
                        // using Code.scope only sets the generic to List
                        const Code('(data as Map).map((k,v) =>'
                            'MapEntry(deserialize<'),
                        generics.first
                            .reference(serverCode, config: config)
                            .code,
                        const Code('>(k),deserialize<'),
                        generics[1].reference(serverCode, config: config).code,
                        const Code('>(v))) as T')
                      ])
                : // Key is not String -> stored as list of map entries
                nullable
                    ? Block.of([
                        // using Code.scope only sets the generic to List
                        const Code('(data!=null?'
                            'Map.fromEntries((data as List).map((e) =>'
                            'MapEntry(deserialize<'),
                        generics.first
                            .reference(serverCode, config: config)
                            .code,
                        const Code('>(e[\'k\']),deserialize<'),
                        generics[1].reference(serverCode, config: config).code,
                        const Code('>(e[\'v\']))))' ':null) as T')
                      ])
                    : Block.of([
                        // using Code.scope only sets the generic to List
                        const Code('Map.fromEntries((data as List).map((e) =>'
                            'MapEntry(deserialize<'),
                        generics.first
                            .reference(serverCode, config: config)
                            .code,
                        const Code('>(e[\'k\']),deserialize<'),
                        generics[1].reference(serverCode, config: config).code,
                        const Code('>(e[\'v\'])))) as T')
                      ])
          ]),
        ),
        ...generics.first.generateDeserialization(serverCode, config: config),
        ...generics[1].generateDeserialization(serverCode, config: config),
      ];
    } else if (customClass) {
      // This is the only place the customClass bool is used.
      // It could be moved as we already know that we are working on custom classes
      // when we generate the deserialization.
      // But the additional functionality we get here is that we generate resolves for lists and maps
      // if the custom class is used as a generic type. The day we create a more generic way to resolve generics
      // in lists, maps, etc the customClass bool can be removed which will simplify the code.
      return [
        MapEntry(
            nullable
                ? refer('getType', serverpodUrl(serverCode))
                    .call([], {}, [reference(serverCode, config: config)])
                : reference(serverCode, config: config),
            Code.scope((a) => nullable
                ? '(data!=null?'
                    '${a(reference(serverCode, config: config))}'
                    '.fromJson(data):null)as T'
                : '${a(reference(serverCode, config: config))}'
                    '.fromJson(data) as T'))
      ];
    } else {
      return [];
    }
  }

  /// Applies protocol references. This makes the protocol: prefix optional.
  /// First, the protocol definition is parsed, then it's check for the
  /// protocol: prefix in types. Whenever no url is set and user specified a
  /// class/enum with the same symbol name it defaults to the protocol: prefix.
  TypeDefinition applyProtocolReferences(
    List<SerializableModelDefinition> classDefinitions,
  ) {
    var modelDefinition = classDefinitions
        .where((c) => c.className == className)
        .where((c) => c.type.moduleAlias == defaultModuleAlias)
        .firstOrNull;
    bool isProjectModel =
        url == defaultModuleAlias || (url == null && modelDefinition != null);
    return TypeDefinition(
      className: className,
      nullable: nullable,
      customClass: customClass,
      dartType: dartType,
      projectModelDefinition: isProjectModel ? modelDefinition : null,
      generics: generics
          .map((e) => e.applyProtocolReferences(classDefinitions))
          .toList(),
      enumDefinition: enumDefinition,
      url: isProjectModel ? defaultModuleAlias : url,
      recordFieldName: recordFieldName,
    );
  }

  /// converts '[className]' string value to [ValueType]
  ValueType get valueType {
    if (className == 'int') return ValueType.int;
    if (className == 'double') return ValueType.double;
    if (className == 'String') return ValueType.string;
    if (className == 'bool') return ValueType.bool;
    if (className == 'DateTime') return ValueType.dateTime;
    if (className == 'Duration') return ValueType.duration;
    if (className == 'Uri') return ValueType.uri;
    if (className == 'ByteData') return ValueType.byteData;
    if (className == 'UuidValue') return ValueType.uuidValue;
    if (className == 'BigInt') return ValueType.bigInt;
    if (className == 'List') return ValueType.list;
    if (className == 'Set') return ValueType.set;
    if (className == 'Map') return ValueType.map;
    if (isEnumType) return ValueType.isEnum;
    return ValueType.classType;
  }

  /// Returns [DefaultValueAllowedType] only for fields that are allowed to have defaults
  DefaultValueAllowedType? get defaultValueType {
    switch (valueType) {
      case ValueType.dateTime:
        return DefaultValueAllowedType.dateTime;
      case ValueType.bool:
        return DefaultValueAllowedType.bool;
      case ValueType.int:
        return DefaultValueAllowedType.int;
      case ValueType.double:
        return DefaultValueAllowedType.double;
      case ValueType.string:
        return DefaultValueAllowedType.string;
      case ValueType.uri:
        return DefaultValueAllowedType.uri;
      case ValueType.uuidValue:
        return DefaultValueAllowedType.uuidValue;
      case ValueType.bigInt:
        return DefaultValueAllowedType.bigInt;
      case ValueType.duration:
        return DefaultValueAllowedType.duration;
      case ValueType.isEnum:
        return DefaultValueAllowedType.isEnum;
      default:
        return null;
    }
  }

  @override
  String toString() {
    if (isRecordType) {
      var positionalFields =
          generics.where((f) => f.recordFieldName == null).toList();
      var namedFields =
          generics.where((f) => f.recordFieldName != null).toList();

      return [
        '(',
        positionalFields.map((t) => t.toString()).join(', '),
        if (positionalFields.isNotEmpty || positionalFields.length == 1) ',',
        if (namedFields.isNotEmpty) ...[
          ' {',
          namedFields.map((f) => '$f ${f.recordFieldName!}').join(', '),
          '}',
        ],
        ')',
        if (nullable) '?',
      ].join();
    }

    var genericsString = generics.isNotEmpty ? '<${generics.join(',')}>' : '';
    var nullableString = nullable ? '?' : '';
    var urlString = url != null ? '$url:' : '';
    return '$urlString$className$genericsString$nullableString';
  }
}

/// Supported ID type definitions.
/// All configuration to support other types is done only on this class. For
/// new variants of id types, add a new static getter and update the [all]
/// getter. For different types, it is necessary to also update the `Table`
/// constructor at `packages:serverpod/src/database/concepts/table.dart`.
class SupportedIdType {
  const SupportedIdType({
    required this.type,
    required this.aliases,
    required this.defaultValue,
  });

  /// The supported id type.
  final TypeDefinition type;

  /// The aliases for the id type as exposed to the user. Supports multiple,
  /// even though it is not recommended to use more than one to avoid confusion.
  final List<String> aliases;

  /// The default value for the column on the database definition. Must be one
  /// of the supported defaults for the type.
  final String defaultValue;

  /// The class name of the id type.
  String get className => type.className;

  /// If no id type is specified, the default id type is [int].
  static SupportedIdType get int => SupportedIdType(
        type: TypeDefinition.int,
        aliases: ['int'],
        defaultValue: defaultIntSerial,
      );

  /// All supported id types.
  static List<SupportedIdType> get all => [int];

  /// All aliases exposed to the user.
  static List<String> get userOptions => all.expand((e) => e.aliases).toList();

  /// Get the [SupportedIdType] from a valid string alias. If the input is
  /// invalid, will throw a [FormatException].
  static SupportedIdType fromString(String input) {
    for (var idType in all) {
      if (idType.aliases.contains(input)) return idType;
    }
    var options = all.map((e) => "'${e.aliases.join("'|'")}'").join(', ');
    throw FormatException('Invalid id type $input. Valid options: $options.');
  }
}

/// Parses a type from a string and deals with whitespace and generics.
/// If [analyzingExtraClasses] is true, the root element might be marked as
/// [TypeDefinition.customClass].
TypeDefinition parseType(
  String input, {
  required List<TypeDefinition>? extraClasses,
}) {
  var trimmedInput = input.trim();

  var start = trimmedInput.indexOf('<');
  var end = trimmedInput.lastIndexOf('>');

  var generics = <TypeDefinition>[];
  if (start != -1 && end != -1) {
    var internalTypes = trimmedInput.substring(start + 1, end);

    var genericsInputs = splitIgnoringBracketsAndQuotes(internalTypes);

    generics = genericsInputs
        .map((generic) => parseType(generic, extraClasses: extraClasses))
        .toList();
  }

  bool isNullable = trimmedInput[trimmedInput.length - 1] == '?';
  int terminatedAt = _findLastClassToken(start, trimmedInput, isNullable);

  String className = trimmedInput.substring(0, terminatedAt).trim();

  var extraClass = extraClasses
      ?.cast<TypeDefinition?>()
      .firstWhere((c) => c?.className == className, orElse: () => null);

  if (extraClass != null) {
    return isNullable ? extraClass.asNullable : extraClass;
  }

  return TypeDefinition.mixedUrlAndClassName(
    mixed: className,
    nullable: isNullable,
    generics: generics,
    customClass: extraClasses == null,
  );
}

int _findLastClassToken(int start, String input, bool isNullable) {
  if (start != -1) return start;
  if (isNullable) return input.length - 1;

  return input.length;
}

class FromDartTypeClassNameException implements Exception {
  final DartType type;

  FromDartTypeClassNameException(this.type);

  @override
  String toString() {
    return 'Failed to determine class name from type $type';
  }
}

enum ValueType {
  int,
  double,
  string,
  bool,
  dateTime,
  duration,
  byteData,
  uuidValue,
  bigInt,
  list,
  set,
  map,
  isEnum,
  classType,
  uri;
}

enum DefaultValueAllowedType {
  dateTime,
  bool,
  int,
  double,
  string,
  uuidValue,
  bigInt,
  duration,
  uri,
  isEnum,
}
