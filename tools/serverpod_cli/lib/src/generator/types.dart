import 'dart:core' as d;
import 'dart:core';

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
import 'package:super_string/super_string.dart';

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

  /// Stores the dimension of Vector type (e.g., 1536 for Vector(1536)).
  /// Only populated for Vector types.
  final d.int? vectorDimension;

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
        className: recordTypeClassName,
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
    this.vectorDimension,
  });

  static const recordTypeClassName = '_Record';

  bool get isSerializedValue => autoSerializedTypes.contains(className);

  bool get isSerializedByExtension =>
      extensionSerializedTypes.contains(className);

  bool get isListType => className == ListKeyword.className;

  bool get isSetType => className == SetKeyword.className;

  bool get isMapType => className == MapKeyword.className;

  static List<String> get vectorClassNames =>
      ['Vector', 'HalfVector', 'SparseVector', 'Bit'];

  bool get isVectorType => vectorClassNames.contains(className);

  bool get isRecordType => className == recordTypeClassName;

  bool get isIdType =>
      SupportedIdType.all.any((e) => e.type.className == className);

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
    d.int? vectorDimension,
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
      vectorDimension: vectorDimension,
    );
  }

  /// A convenience variable for getting a [TypeDefinition] of a non null int
  /// quickly.
  static TypeDefinition int = TypeDefinition(className: 'int', nullable: false);

  /// A convenience variable for getting a [TypeDefinition] of a non null
  /// UuidValue quickly.
  static TypeDefinition uuid =
      TypeDefinition(className: 'UuidValue', nullable: false);

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
        vectorDimension: vectorDimension,
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
        vectorDimension: vectorDimension,
      );

  /// Returns this [TypeDefinition] as a named record field
  TypeDefinition asNamedRecordField(String recordFieldName) => TypeDefinition(
        className: className,
        url: url,
        nullable: nullable,
        customClass: customClass,
        dartType: dartType,
        generics: generics,
        enumDefinition: enumDefinition,
        projectModelDefinition: projectModelDefinition,
        recordFieldName: recordFieldName,
        vectorDimension: vectorDimension,
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
        b.positionalFieldTypes.addAll([
          for (final f in positionalRecordFields)
            f.reference(
              serverCode,
              subDirParts: subDirParts,
              config: config,
            ),
        ]);

        b.namedFieldTypes.addAll({
          for (final namedField in namedRecordFields)
            namedField.recordFieldName!: namedField.reference(
              serverCode,
              subDirParts: subDirParts,
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
            (url == null &&
                (['UuidValue', ...vectorClassNames]).contains(className))) {
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
    if (className == 'Vector') return 'vector';
    if (className == 'HalfVector') return 'halfvec';
    if (className == 'SparseVector') return 'sparsevec';
    if (className == 'Bit') return 'bit';

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
    if (className == 'Vector') return 'ColumnVector';
    if (className == 'HalfVector') return 'ColumnHalfVector';
    if (className == 'SparseVector') return 'ColumnSparseVector';
    if (className == 'Bit') return 'ColumnBit';

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
      return [
        MapEntry(
          refer('getType', serverpodUrl(serverCode))
              .call([], {}, [reference(serverCode, config: config)]),
          Block.of(
            [
              if (nullable) const Code(' (data == null) ? null as T : '),
              const Code('('),
              for (final (i, positionalField)
                  in positionalRecordFields.indexed) ...[
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
              if (namedRecordFields.isNotEmpty) ...[
                for (final (i, namedField) in namedRecordFields.indexed) ...[
                  Code(namedField.recordFieldName!),
                  const Code(':'),
                  if (namedField.nullable)
                    Code(
                        "((data ${i == 0 && positionalRecordFields.isEmpty ? 'as Map' : ''})['n'] as Map)['${namedField.recordFieldName!}'] == null ? null : "),
                  const Code('deserialize<'),
                  namedField
                      .reference(serverCode, config: config, nullable: false)
                      .code,
                  const Code('>('),
                  if (i == 0 &&
                      positionalRecordFields.isEmpty &&
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
      vectorDimension: vectorDimension,
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
    if (className == 'Vector') return ValueType.vector;
    if (className == 'HalfVector') return ValueType.halfVector;
    if (className == 'SparseVector') return ValueType.sparseVector;
    if (className == 'Bit') return ValueType.bit;
    if (className == 'List') return ValueType.list;
    if (className == 'Set') return ValueType.set;
    if (className == 'Map') return ValueType.map;
    if (className == '_Record') return ValueType.record;
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
      return [
        '(',
        positionalRecordFields.map((t) => t.toString()).join(', '),
        if (positionalRecordFields.isNotEmpty ||
            positionalRecordFields.length == 1)
          ',',
        if (namedRecordFields.isNotEmpty) ...[
          ' {',
          namedRecordFields.map((f) => '$f ${f.recordFieldName!}').join(', '),
          '}',
        ],
        ')',
        if (nullable) '?',
      ].join();
    }

    var genericsString = generics.isNotEmpty ? '<${generics.join(',')}>' : '';
    var nullableString = nullable ? '?' : '';
    var urlString = url != null ? '$url:' : '';
    var classRepr = isVectorType ? '$className($vectorDimension)' : className;
    return '$urlString$classRepr$genericsString$nullableString';
  }
}

/// Supported ID type definitions.
/// All configuration to support other types is done only on this class. A
/// supported id type is a combination of a type and a default value. It is
/// possible to support multiple default values for a same type (e.g. uuid type
/// with default of versions 4 and 7), with each having its getter. For new
/// entries, add a new static getter and update the [all] getter. If the entry
/// contains a type not yet used by existing id types, it's necessary to update
/// the `Table` constructor at `packages:serverpod/src/database/concepts/table.dart`.
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

  /// Id type that generates sequential integer values.
  static SupportedIdType get int => SupportedIdType(
        type: TypeDefinition.int,
        aliases: ['int'],
        defaultValue: defaultIntSerial,
      );

  /// Id type that generates UUID v4 values.
  static SupportedIdType get uuidV4 => SupportedIdType(
        type: TypeDefinition.uuid,
        aliases: ['uuidV4'],
        defaultValue: defaultUuidValueRandom,
      );

  /// Id type that generates UUID v7 values.
  static SupportedIdType get uuidV7 => SupportedIdType(
        type: TypeDefinition.uuid,
        aliases: ['uuidV7'],
        defaultValue: defaultUuidValueRandomV7,
      );

  /// All supported id types.
  static List<SupportedIdType> get all => [int, uuidV4, uuidV7];

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

  var maybeRecord = _RecordTypeDefinitionParsing.tryParseRecord(
    trimmedInput,
    extraClasses: extraClasses,
  );
  if (maybeRecord != null) {
    return maybeRecord;
  }

  var start = trimmedInput.indexOf('<');
  var end = trimmedInput.lastIndexOf('>');

  var generics = <TypeDefinition>[];
  if (start != -1 && end != -1) {
    var internalTypes = trimmedInput.substring(start + 1, end);

    var genericsInputs = splitIgnoringBracketsAndBracesAndQuotes(internalTypes);

    generics = genericsInputs
        .map((generic) => parseType(generic, extraClasses: extraClasses))
        .toList();
  }

  bool isNullable = trimmedInput[trimmedInput.length - 1] == '?';
  int terminatedAt = _findLastClassToken(start, trimmedInput, isNullable);

  String className = trimmedInput.substring(0, terminatedAt).trim();

  var vectorDimension = (TypeDefinition.vectorClassNames.contains(className) &&
          (trimmedInput.count('(') == 1 && trimmedInput.count(')') == 1))
      ? int.tryParse(
          trimmedInput.substring(terminatedAt + 1, trimmedInput.indexOf(')')))
      : null;

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
    vectorDimension: vectorDimension,
  );
}

int _findLastClassToken(int start, String input, bool isNullable) {
  if (start != -1) return start;
  if (input.first != '(' && input.contains('(')) return input.indexOf('(');
  if (input.first != '(' && input.contains(')')) return input.indexOf(')');
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
  record,
  isEnum,
  classType,
  vector,
  halfVector,
  sparseVector,
  bit,
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

extension _RecordTypeDefinitionParsing on TypeDefinition {
  /// Attempts to parse a record type from a field type definition
  ///
  /// Returns `null` in case the type does not describe a valid record
  static TypeDefinition? tryParseRecord(
    String trimmedRecordInput, {
    List<TypeDefinition>? extraClasses,
  }) {
    var recordDescription = _tryReadRecord(trimmedRecordInput);
    if (recordDescription == null) {
      return null;
    }

    if (recordDescription.positionalFieldTypes.isEmpty &&
        recordDescription.namedFields.isEmpty) {
      return null;
    }

    var recordFields = [
      for (var positionalFieldType in recordDescription.positionalFieldTypes)
        parseType(positionalFieldType, extraClasses: extraClasses),
      for (var MapEntry(key: name, value: type)
          in recordDescription.namedFields.entries)
        parseType(type, extraClasses: extraClasses).asNamedRecordField(name),
    ];

    return TypeDefinition(
      className: TypeDefinition.recordTypeClassName,
      generics: recordFields,
      nullable: recordDescription.nullable,
    );
  }

  static ({
    List<String> positionalFieldTypes,
    Map<String, String> namedFields,
    bool nullable,
  })? _tryReadRecord(
    String trimmedRecordInput,
  ) {
    if (!trimmedRecordInput.startsWith('(')) {
      return null;
    }

    if (!trimmedRecordInput.endsWith(')') &&
        !trimmedRecordInput.replaceAll(' ', '').endsWith(')?')) {
      return null;
    }

    var start = trimmedRecordInput.indexOf('(');
    var end = trimmedRecordInput.lastIndexOf(')');

    var nullable = trimmedRecordInput.endsWith('?');
    var recordBody = trimmedRecordInput.substring(start + 1, end);

    var recordParts = _parseRecordBody(recordBody);
    if (recordParts == null) {
      return null;
    }

    var namedFields = _tryParseNamedFieldsString(recordParts.namedFieldsString);
    if (namedFields == null) {
      return null;
    }

    var positionalFieldTypes = _getTypesFromPositionalFields(
      recordParts.positionalFieldStrings,
    );

    return (
      positionalFieldTypes: positionalFieldTypes,
      namedFields: namedFields,
      nullable: nullable,
    );
  }

  static ({
    List<String> positionalFieldStrings,
    String? namedFieldsString,
  })? _parseRecordBody(String recordBody) {
    var recordParts = splitIgnoringBracketsAndBracesAndQuotes(
      recordBody,
    );

    var positionalFieldStrings = <String>[];
    String? namedFieldsString;
    for (var part in recordParts) {
      if (namedFieldsString != null) {
        // no more entries are allowed after the named part
        return null;
      }

      if (part.startsWith('{')) {
        namedFieldsString = part;
      } else {
        positionalFieldStrings.add(part);
      }
    }

    if (positionalFieldStrings.length == 1 &&
        namedFieldsString == null &&
        !recordBody.contains(',')) {
      return null;
    }

    return (
      positionalFieldStrings: positionalFieldStrings,
      namedFieldsString: namedFieldsString
    );
  }

  static List<String> _getTypesFromPositionalFields(
    List<String> positionalFieldStrings,
  ) {
    return positionalFieldStrings.map((positionalFieldStrings) {
      // could be either just a positional type, or a named positional type (like `int` or `int someNumber`, or even `Set<String> someSet`)
      var parts = splitIgnoringBracketsAndBracesAndQuotes(
        positionalFieldStrings,
        separator: ' ',
      );

      if (parts.length > 1 && !parts.last.startsWith('<')) {
        // if the last part is a name (and not a generic parameter), then we need to drop that
        positionalFieldStrings = parts.take(parts.length - 1).join();
      }

      return positionalFieldStrings;
    }).toList();
  }

  static Map<String, String>? _tryParseNamedFieldsString(
    String? namedFieldsString,
  ) {
    if (namedFieldsString == null) {
      return {};
    }

    var namedFields = <String, String>{};
    var start = namedFieldsString.indexOf('{');
    var end = namedFieldsString.lastIndexOf('}');

    if (start < 0 || end < 0 || end <= start) {
      return null;
    }

    var namedFieldWithTypes = splitIgnoringBracketsAndBracesAndQuotes(
      namedFieldsString.substring(start + 1, end),
    );

    for (var namedFieldWithType in namedFieldWithTypes) {
      namedFieldWithType = namedFieldWithType.trim();
      var lastWhitespaceIndex = namedFieldWithType.lastIndexOf(' ');
      if (lastWhitespaceIndex < 0) {
        return null;
      }

      var typeDescription =
          namedFieldWithType.substring(0, lastWhitespaceIndex).trim();
      var name = namedFieldWithType.substring(lastWhitespaceIndex).trim();

      namedFields[name] = typeDescription;
    }

    return namedFields;
  }
}

extension on TypeDefinition {
  Iterable<TypeDefinition> get positionalRecordFields {
    assert(isRecordType);
    return generics.where((f) => f.recordFieldName == null).toList();
  }

  Iterable<TypeDefinition> get namedRecordFields {
    assert(isRecordType);
    return generics.where((f) => f.recordFieldName != null).toList();
  }
}
