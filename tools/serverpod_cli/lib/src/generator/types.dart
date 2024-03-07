import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/shared.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/string_manipulation.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../config/config.dart';

const _moduleRef = 'module:';

/// Contains information about the type of fields, arguments and return values.
class TypeDefinition {
  /// The class name of the type.
  final String className;

  /// The generics the type has.
  final List<TypeDefinition> generics;

  final String? url;

  /// Whether this type is nullable.
  final bool nullable;

  final DartType? dartType;

  /// True if this type references a custom class.
  final bool customClass;

  EnumSerialization? serializeEnum;

  TypeDefinition({
    required this.className,
    this.generics = const [],
    required this.nullable,
    this.url,
    this.dartType,
    this.customClass = false,
    this.serializeEnum,
  });

  bool get isSerializedValue => autoSerializedTypes.contains(className);

  bool get isSerializedByExtension =>
      extensionSerializedTypes.contains(className);

  bool get isListType => className == 'List';

  bool get isMapType => className == 'Map';

  bool get isIdType => className == 'int';

  bool get isModuleType =>
      url == 'serverpod' || (url?.startsWith(_moduleRef) ?? false);

  bool get isEnumType => serializeEnum != null;

  String? get moduleAlias {
    if (url == defaultModuleAlias) return url;
    if (url == 'serverpod') return url;
    if (url?.startsWith(_moduleRef) ?? false) {
      return url?.substring(_moduleRef.length);
    }
    return null;
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

  /// Creates an [TypeDefinition] from a given [DartType].
  /// throws [FromDartTypeClassNameException] if the class name could not be
  /// determined.
  factory TypeDefinition.fromDartType(DartType type) {
    var generics = (type is ParameterizedType)
        ? type.typeArguments.map((e) => TypeDefinition.fromDartType(e)).toList()
        : <TypeDefinition>[];
    var url = type.element?.librarySource?.uri.toString();
    var nullable = type.nullabilitySuffix == NullabilitySuffix.question;

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
    );
  }

  /// A convenience variable for getting a [TypeDefinition] of an non null int
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
        serializeEnum: serializeEnum,
      );

  /// Generate a [TypeReference] from this definition.
  TypeReference reference(
    bool serverCode, {
    bool? nullable,
    List<String> subDirParts = const [],
    required GeneratorConfig config,
    String? typeSuffix,
  }) {
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
          t.url = p.posix
              .joinAll([...subDirParts.map((e) => '..'), 'protocol.dart']);
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
        t.types.addAll(generics.map((e) => e.reference(
              serverCode,
              subDirParts: subDirParts,
              config: config,
            )));
      },
    );
  }

  /// Get the qgsql type that represents this [TypeDefinition] in the database.
  String get databaseType {
    // TODO: add all suported types here
    var enumSerialization = serializeEnum;
    if (enumSerialization != null && isEnumType) {
      switch (enumSerialization) {
        case EnumSerialization.byName:
          return 'text';
        case EnumSerialization.byIndex:
          return 'integer';
      }
    }
    if (className == 'int') return 'integer';
    if (className == 'double') return 'double precision';
    if (className == 'bool') return 'boolean';
    if (className == 'String') return 'text';
    if (className == 'DateTime') return 'timestamp without time zone';
    if (className == 'ByteData') return 'bytea';
    if (className == 'Duration') return 'bigint';
    if (className == 'UuidValue') return 'uuid';

    return 'json';
  }

  /// Get the enum name of the [ColumnType], representing this [TypeDefinition]
  /// in the database.
  String get databaseTypeEnum {
    return databaseTypeToLowerCamelCase(databaseType);
  }

  /// Get the [Column] extending class name representing this [TypeDefinition].
  String get columnType {
    // TODO: add all suported types here
    if (isEnumType) return 'ColumnEnum';
    if (className == 'int') return 'ColumnInt';
    if (className == 'double') return 'ColumnDouble';
    if (className == 'bool') return 'ColumnBool';
    if (className == 'String') return 'ColumnString';
    if (className == 'DateTime') return 'ColumnDateTime';
    if (className == 'ByteData') return 'ColumnByteData';
    if (className == 'Duration') return 'ColumnDuration';
    if (className == 'UuidValue') return 'ColumnUuid';

    return 'ColumnSerializable';
  }

  /// Strip the outer most future of this type.
  /// Throws, if this type is not a future.
  TypeDefinition stripFuture() {
    if (dartType?.isDartAsyncFuture ?? className == 'Future') {
      return generics.first;
    } else {
      throw FormatException(
          '$this is not a Future, so Future cant be stripped.');
    }
  }

  /// Generates the constructors for List and Map types
  List<MapEntry<Expression, Code>> generateDeserialization(
    bool serverCode, {
    required GeneratorConfig config,
  }) {
    if ((className == 'List' || className == 'Set') && generics.length == 1) {
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
                        ':null) as dynamic')
                  ])
                : Block.of([
                    const Code('(data as List).map((e) =>'
                        'deserialize<'),
                    generics.first.reference(serverCode, config: config).code,
                    Code(
                        '>(e))${className == 'Set' ? '.toSet()' : '.toList()'} as dynamic'),
                  ])
          ]),
        ),
        ...generics.first.generateDeserialization(serverCode, config: config),
      ];
    } else if (className == 'Map' && generics.length == 2) {
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
                        const Code('>(v)))' ':null) as dynamic')
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
                        const Code('>(v))) as dynamic')
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
                        const Code('>(e[\'v\']))))' ':null) as dynamic')
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
                        const Code('>(e[\'v\'])))) as dynamic')
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
                    '.fromJson(data,this):null)as T'
                : '${a(reference(serverCode, config: config))}'
                    '.fromJson(data,this) as T'))
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
      List<SerializableModelDefinition> classDefinitions) {
    return TypeDefinition(
        className: className,
        nullable: nullable,
        customClass: customClass,
        dartType: dartType,
        generics: generics
            .map((e) => e.applyProtocolReferences(classDefinitions))
            .toList(),
        serializeEnum: serializeEnum,
        url:
            url == null && classDefinitions.any((c) => c.className == className)
                ? defaultModuleAlias
                : url);
  }

  @override
  String toString() {
    var genericsString = generics.isNotEmpty ? '<${generics.join(',')}>' : '';
    var nullableString = nullable ? '?' : '';
    var urlString = url != null ? '$url:' : '';
    return '$urlString$className$genericsString$nullableString';
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

    var genericsInputs = splitIgnoringBrackets(internalTypes);

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
