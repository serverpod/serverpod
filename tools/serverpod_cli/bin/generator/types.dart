import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';

import 'class_generator_dart.dart';

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
    var url = (parts..removeLast()).join(':');

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
    var className = type.element2!.displayName;
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
  TypeReference reference([bool serverCode = true]) => TypeReference(
        (t) {
          if (url?.startsWith('module:') ?? false) {
            var moduleName = url?.substring(7);
            t.url =
                'package:$moduleName${serverCode ? '_server' : '_client'}/module.dart';
          } else if (url == 'serverpod') {
            t.url = serverPodUrl(serverCode);
          } else if (url == 'protocol') {
            t.url = 'protocol.dart';
          } else {
            t.url = url;
          }
          t.isNullable = nullable;
          t.symbol = className;
          t.types.addAll(generics.map((e) => e.reference(serverCode)));
          // print('$className ${t.types.build()}');
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
  List<MapEntry<Expression, Code>> generateListSetMapConstructors(
      bool serverCode) {
    // print('constructors');
    if ((className == 'List' || className == 'Set') && generics.length == 1) {
      return [
        MapEntry(
          nullable
              ? refer('getType', serverPodUrl(serverCode))
                  .call([], {}, [reference(serverCode)])
              : reference(serverCode),
          Block.of([
            Code.scope((a) =>
                '(jsonSerialization,${a(refer('SerializationManager', serverPodUrl(serverCode)))}'
                ' serializationManager)=>'),
            nullable
                ? Block.of([
                    // using Code.scope only sets the generic to List
                    Code('jsonSerialization!=null?'
                        '${className == 'Set' ? 'Set.of(' : ''}'
                        '(jsonSerialization as List).map((e) =>'
                        'serializationManager.deserializeJson<'),
                    generics.first.reference(serverCode).code,
                    Code('>(e))${className == 'Set' ? ')' : ''}'
                        ':null')
                  ])
                : Block.of([
                    Code('${className == 'Set' ? 'Set.of(' : ''}'
                        '(jsonSerialization as List).map((e) =>'
                        'serializationManager.deserializeJson<'),
                    generics.first.reference(serverCode).code,
                    Code('>(e))${className == 'Set' ? ')' : ''}'),
                  ])
          ]),
        ),
        ...generics.first.generateListSetMapConstructors(serverCode),
      ];
    } else if (className == 'Map' && generics.length == 2) {
      return [
        MapEntry(
          nullable
              ? refer('getType', serverPodUrl(serverCode))
                  .call([], {}, [reference(serverCode)])
              : reference(serverCode),
          Block.of([
            Code.scope((a) =>
                '(jsonSerialization,${a(refer('SerializationManager', serverPodUrl(serverCode)))}'
                ' serializationManager)=>'),
            nullable
                ? Block.of([
                    // using Code.scope only sets the generic to List
                    const Code('jsonSerialization!=null?'
                        '(jsonSerialization as Map).map((k,v) =>'
                        'MapEntry(serializationManager.deserializeJson<'),
                    generics.first.reference(serverCode).code,
                    const Code('>(k),serializationManager.deserializeJson<'),
                    generics[1].reference(serverCode).code,
                    const Code('>(v)))' ':null')
                  ])
                : Block.of([
                    // using Code.scope only sets the generic to List
                    const Code('(jsonSerialization as Map).map((k,v) =>'
                        'MapEntry(serializationManager.deserializeJson<'),
                    generics.first.reference(serverCode).code,
                    const Code('>(k),serializationManager.deserializeJson<'),
                    generics[1].reference(serverCode).code,
                    const Code('>(v)))')
                  ])
          ]),
        ),
        ...generics.first.generateListSetMapConstructors(serverCode),
        ...generics[1].generateListSetMapConstructors(serverCode),
      ];
    } else {
      return [];
    }
  }
}
