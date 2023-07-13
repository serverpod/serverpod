import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/generator/shared.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:source_span/source_span.dart';
import 'package:path/path.dart' as p;

import '../config/config.dart';

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

  /// True if this type references a enum.
  bool isEnum;

  TypeDefinition({
    required this.className,
    this.generics = const [],
    required this.nullable,
    this.url,
    this.dartType,
    this.customClass = false,
    this.isEnum = false,
  });

  bool get isList => className == 'List';

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
  factory TypeDefinition.fromDartType(DartType type) {
    var generics = (type is ParameterizedType)
        ? type.typeArguments.map((e) => TypeDefinition.fromDartType(e)).toList()
        : <TypeDefinition>[];
    var url = type.element?.librarySource?.uri.toString();
    var nullable = type.nullabilitySuffix == NullabilitySuffix.question;

    var className = type is! VoidType ? type.element!.displayName : 'void';

    return TypeDefinition(
      className: className,
      nullable: nullable,
      dartType: type,
      generics: generics,
      isEnum: type.isDartCoreEnum,
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
        isEnum: isEnum,
      );

  /// Generate a [TypeReference] from this definition.
  TypeReference reference(
    bool serverCode, {
    bool? nullable,
    List<String> subDirParts = const [],
    required GeneratorConfig config,
  }) {
    return TypeReference(
      (t) {
        if (url?.startsWith('module:') ?? false) {
          // module:nickname: reference
          var moduleName = url?.substring(7);
          var module = config.modules.cast<ModuleConfig?>().firstWhere(
                (m) => m?.nickname == moduleName,
                orElse: () => null,
              );
          if (module == null) {
            throw FormatException(
                'Module with nickname $moduleName not found in config!');
          }
          t.url = 'package:'
              '${serverCode ? module.serverPackage : module.dartClientPackage}'
              '/module.dart';
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
        } else if (url == 'protocol') {
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
          t.url = url!.contains('/src/generated/')
              ? 'package:'
                  '${serverCode ? module.serverPackage : module.dartClientPackage}'
                  '/module.dart'
              : serverCode
                  ? url
                  : url?.replaceFirst('package:${module.serverPackage}',
                      'package:${module.dartClientPackage}');
        } else {
          t.url = url;
        }
        t.isNullable = nullable ?? this.nullable;
        t.symbol = className;
        t.types.addAll(generics.map((e) => e.reference(
              serverCode,
              subDirParts: subDirParts,
              config: config,
            )));
      },
    );
  }

  /// Get the pgsql type that represents this [TypeDefinition] in the database.
  String get databaseType {
    // TODO: add all supported types here
    var serializeEnumValuesAsStrings =
        GeneratorConfig.instance!.serializeEnumValuesAsStrings;
    if (className == 'String' || (isEnum && serializeEnumValuesAsStrings)) {
      return 'text';
    }
    if (className == 'bool') return 'boolean';
    if (className == 'int' || (isEnum && !serializeEnumValuesAsStrings)) {
      return 'integer';
    }
    if (className == 'double') return 'double precision';
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
    if (className == 'int') return 'ColumnInt';
    if (isEnum) return 'ColumnEnum';
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
      List<SerializableEntityDefinition> classDefinitions) {
    return TypeDefinition(
        className: className,
        nullable: nullable,
        customClass: customClass,
        dartType: dartType,
        generics: generics
            .map((e) => e.applyProtocolReferences(classDefinitions))
            .toList(),
        isEnum: isEnum,
        url:
            url == null && classDefinitions.any((c) => c.className == className)
                ? 'protocol'
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

/// Analyze the type at the start of [input].
/// [input] must not contain spaces.
/// Returns a [_TypeResult] containing the type,
/// as well as the position of the last parsed character.
/// So when calling with "List<List<String?>?>,database",
/// the position will point at the ','.
/// If [analyzingExtraClasses] is true, the root element might be marked as
/// [TypeDefinition.customClass].
TypeParseResult parseAndAnalyzeType(
  String input, {
  bool analyzingExtraClasses = false,
  required SourceSpan sourceSpan,
}) {
  String classname = '';
  for (var i = 0; i < input.length; i++) {
    switch (input[i]) {
      case '<':
        var generics = <TypeDefinition>[];
        while (true) {
          i++;
          var result = parseAndAnalyzeType(
            input.substring(i),
            sourceSpan: sourceSpan.subspan(i),
          );
          generics.add(result.type);
          i += result.parsedPosition;
          if (input[i] == '>') {
            var nullable = (i + 1 < input.length) && input[i + 1] == '?';
            return TypeParseResult(
                i + 1,
                TypeDefinition.mixedUrlAndClassName(
                  mixed: classname,
                  nullable: nullable,
                  generics: generics,
                ));
          } else if (i >= input.length - 1) {
            throw SourceSpanException('Invalid Type', sourceSpan);
          }
        }
      case '>':
      case ',':
        return TypeParseResult(
            i,
            TypeDefinition.mixedUrlAndClassName(
                mixed: classname,
                nullable: false,
                customClass: analyzingExtraClasses));
      case '?':
        return TypeParseResult(
            i + 1,
            TypeDefinition.mixedUrlAndClassName(
                mixed: classname,
                nullable: true,
                customClass: analyzingExtraClasses));
      default:
        classname += input[i];
        break;
    }
  }
  return TypeParseResult(
      input.length - 1,
      TypeDefinition.mixedUrlAndClassName(
          mixed: classname,
          nullable: false,
          customClass: analyzingExtraClasses));
}

/// The result when running [parseAndAnalyzeType].
class TypeParseResult {
  /// The position of the next unparsed character.
  final int parsedPosition;

  /// The type that was parsed.
  final TypeDefinition type;

  /// Create a new [TypeParseResult].
  const TypeParseResult(this.parsedPosition, this.type);
}
