import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';

import 'class_generator_dart.dart';
import 'config.dart';

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

  const TypeDefinition({
    required this.className,
    this.generics = const [],
    required this.nullable,
    this.url,
    this.dartType,
  });

  /// Creates an [TypeDefinition] from [mixed] where the [url]
  /// and [className] is separated by ':'.
  factory TypeDefinition.mixedUrlAndClassName({
    required String mixed,
    List<TypeDefinition> generics = const [],
    required bool nullable,
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
        url: url.isNotEmpty ? url : null);
  }

  factory TypeDefinition.fromDartType(DartType type) {
    var generics = (type is ParameterizedType)
        ? type.typeArguments.map((e) => TypeDefinition.fromDartType(e)).toList()
        : <TypeDefinition>[];
    var url = type.element2?.librarySource?.uri.toString();
    var nullable = type.nullabilitySuffix == NullabilitySuffix.question;

    var className = !type.isVoid ? type.element2!.displayName : 'void';

    return TypeDefinition(
      className: className,
      nullable: nullable,
      dartType: type,
      generics: generics,
      url: url,
    );
  }

  static const TypeDefinition int =
      TypeDefinition(className: 'int', nullable: false);

  TypeDefinition get asNullable =>
      TypeDefinition(className: className, url: url, nullable: true);

  /// Generate a [TypeReference] from this definition.
  TypeReference reference(bool serverCode) => TypeReference(
        (t) {
          // print(url);
          if (url?.startsWith('module:') ?? false) {
            // module:nickname: reference
            var moduleName = url?.substring(7);
            var module = config.modules.cast<ModuleConfig?>().firstWhere(
                  (m) => m?.nickname == moduleName,
                  orElse: () => null,
                );
            if (module == null) {
              //TODO: add to collector
              throw 'Module with nickname $moduleName not found in config!';
            }
            t.url =
                'package:${serverCode ? module.serverPackage : module.clientPackage}/module.dart';
          } else if (url == 'serverpod') {
            // serverpod: reference
            t.url = serverPodUrl(serverCode);
          } else if (url == 'protocol') {
            // protocol: reference
            t.url = 'protocol.dart';
          } else if (!serverCode &&
              (url?.startsWith('package:${config.serverPackage}') ?? false)) {
            // import from the server package
            t.url = url
                ?.replaceFirst('package:${config.serverPackage}',
                    'package:${config.clientPackage}')
                .replaceFirst('src/generated/', 'src/protocol/');
          } else if (config.modules.any(
              (m) => url?.startsWith('package:${m.serverPackage}') ?? false)) {
            // endpoint definition references from an module
            var module = config.modules.firstWhere(
                (m) => url?.startsWith('package:${m.serverPackage}') ?? false);
            t.url = url!.contains('/src/generated/')
                ? 'package:${serverCode ? module.serverPackage : module.clientPackage}/module.dart'
                : serverCode
                    ? url
                    : url?.replaceFirst('package:${module.serverPackage}',
                        'package:${module.clientPackage}');
          } else {
            t.url = url;
          }
          t.isNullable = nullable;
          t.symbol = className;
          t.types.addAll(generics.map((e) => e.reference(serverCode)));
        },
      );

  String get databaseType {
    //TODO: add all suported types here
    //TODO: enums as int
    if (className == 'String') return 'text';
    if (className == 'bool') return 'boolean';
    if (className == 'int') return 'integer';
    if (className == 'double') return 'double precision';
    if (className == 'DateTime') return 'timestamp without time zone';
    if (className == 'ByteData') return 'bytea';

    return 'json';
  }

  String get columnType {
    //TODO: add all suported types here
    //TODO: enums as int
    if (className == 'int') return 'ColumnInt';
    if (className == 'double') return 'ColumnDouble';
    if (className == 'bool') return 'ColumnBool';
    if (className == 'String') return 'ColumnString';
    if (className == 'DateTime') return 'ColumnDateTime';
    if (className == 'ByteData') return 'ColumnByteData';
    return 'ColumnSerializable';
  }

  TypeDefinition stripFuture() {
    if (dartType?.isDartAsyncFuture ?? className == 'Future') {
      return generics.first;
    } else {
      //TODO: better error
      throw 'Not a Future';
    }
  }

  /// Generates the constructors for List and Map types
  List<MapEntry<Expression, Code>> generateDeserialization(bool serverCode) {
    if ((className == 'List' || className == 'Set') && generics.length == 1) {
      return [
        MapEntry(
          nullable
              ? refer('getType', serverPodUrl(serverCode))
                  .call([], {}, [reference(serverCode)])
              : reference(serverCode),
          Block.of([
            nullable
                ? Block.of([
                    // using Code.scope only sets the generic to List
                    const Code('(data!=null?'
                        '(data as List).map((e) =>'
                        'deserializeJson<'),
                    generics.first.reference(serverCode).code,
                    Code('>(e))${className == 'Set' ? '.toSet()' : '.toList()'}'
                        ':null) as dynamic')
                  ])
                : Block.of([
                    const Code('(data as List).map((e) =>'
                        'deserializeJson<'),
                    generics.first.reference(serverCode).code,
                    Code(
                        '>(e))${className == 'Set' ? '.toSet()' : '.toList()'} as dynamic'),
                  ])
          ]),
        ),
        ...generics.first.generateDeserialization(serverCode),
      ];
    } else if (className == 'Map' && generics.length == 2) {
      return [
        MapEntry(
          nullable
              ? refer('getType', serverPodUrl(serverCode))
                  .call([], {}, [reference(serverCode)])
              : reference(serverCode),
          Block.of([
            generics.first.className == 'String'
                ? nullable
                    ? Block.of([
                        // using Code.scope only sets the generic to List
                        const Code('(data!=null?'
                            '(data as Map).map((k,v) =>'
                            'MapEntry(deserializeJson<'),
                        generics.first.reference(serverCode).code,
                        const Code('>(k),deserializeJson<'),
                        generics[1].reference(serverCode).code,
                        const Code('>(v)))' ':null) as dynamic')
                      ])
                    : Block.of([
                        // using Code.scope only sets the generic to List
                        const Code('(data as Map).map((k,v) =>'
                            'MapEntry(deserializeJson<'),
                        generics.first.reference(serverCode).code,
                        const Code('>(k),deserializeJson<'),
                        generics[1].reference(serverCode).code,
                        const Code('>(v))) as dynamic')
                      ])
                : // Key is not String -> stored as list of map entries
                nullable
                    ? Block.of([
                        // using Code.scope only sets the generic to List
                        const Code('(data!=null?'
                            'Map.fromEntries((data as List).map((e) =>'
                            'MapEntry(deserializeJson<'),
                        generics.first.reference(serverCode).code,
                        const Code('>(e[\'k\']),deserializeJson<'),
                        generics[1].reference(serverCode).code,
                        const Code('>(e[\'v\']))))' ':null) as dynamic')
                      ])
                    : Block.of([
                        // using Code.scope only sets the generic to List
                        const Code('Map.fromEntries((data as List).map((e) =>'
                            'MapEntry(deserializeJson<'),
                        generics.first.reference(serverCode).code,
                        const Code('>(e[\'k\']),deserializeJson<'),
                        generics[1].reference(serverCode).code,
                        const Code('>(e[\'v\'])))) as dynamic')
                      ])
          ]),
        ),
        ...generics.first.generateDeserialization(serverCode),
        ...generics[1].generateDeserialization(serverCode),
      ];
    } else {
      return [];
    }
  }
}

/// Analyze the type at the start of [input].
/// [input] must not contain spaces.
/// Returns a [_TypeResult] containing the type,
/// as well as the position of the last parsed character.
/// So when calling with "List<List<String?>?>,database",
/// the position will point at the ','.
TypeParseResult parseAndAnalyzeType(String input) {
  String classname = '';
  for (var i = 0; i < input.length; i++) {
    switch (input[i]) {
      case '<':
        var generics = <TypeDefinition>[];
        while (true) {
          i++;
          var result = parseAndAnalyzeType(input.substring(i));
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
            throw 'INVALID TYPE';
          }
        }
      case '>':
      case ',':
        return TypeParseResult(
            i,
            TypeDefinition.mixedUrlAndClassName(
                mixed: classname, nullable: false));
      case '?':
        return TypeParseResult(
            i + 1,
            TypeDefinition.mixedUrlAndClassName(
                mixed: classname, nullable: true));
      default:
        classname += input[i];
        break;
    }
  }
  return TypeParseResult(input.length - 1,
      TypeDefinition.mixedUrlAndClassName(mixed: classname, nullable: false));
}

class TypeParseResult {
  final int parsedPosition;
  final TypeDefinition type;

  const TypeParseResult(this.parsedPosition, this.type);
}
