import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/entity_dependency_resolver.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/builders/model_class_definition_builder.dart';
import '../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../test_util/compilation_unit_helpers.dart';

void main() {
  group('Given nullable collections and value types,', () {
    late ModelClassDefinition model;

    setUp(() {
      model = ModelClassDefinitionBuilder()
          .withField(_field('list', 'List<List<String?>>?'))
          .withField(_field('map', 'Map<String, int?>?'))
          .withField(_field('set', 'Set<int>?'))
          .withSimpleField('date', 'DateTime', nullable: true)
          .withSimpleField('uuid', 'UuidValue', nullable: true)
          .withSimpleField('duration', 'Duration', nullable: true)
          .withSimpleField('uri', 'Uri', nullable: true)
          .withField(_field('vector', 'Vector(3)?'))
          .withField(_field('halfVector', 'HalfVector(3)?'))
          .withField(_field('sparseVector', 'SparseVector(3)?'))
          .withField(_field('bit', 'Bit(3)?'))
          .withSimpleField('point', 'GeographyPoint', nullable: true)
          .withSimpleField('line', 'GeographyLineString', nullable: true)
          .withSimpleField('polygon', 'GeographyPolygon', nullable: true)
          .withSimpleField(
            'geometries',
            'GeographyGeometryCollection',
            nullable: true,
          )
          .build();
    });

    test(
      'when generating server code, '
      'then public and implementation copyWith parameters retain their types.',
      () {
        final code = const DartServerCodeGenerator()
            .generateSerializableModelsCode(
              models: [model],
              config: GeneratorConfigBuilder().build(),
            )
            .values
            .single;

        final expected = _typedParameters.replaceAll(
          '_iss.',
          '_is.',
        );

        expect(_parameters(code, 'Example'), expected);
        expect(_parameters(code, '_ExampleImpl'), expected);
      },
    );

    test(
      'when generating client code, '
      'then public and implementation copyWith parameters retain their types.',
      () {
        final code = const DartClientCodeGenerator()
            .generateSerializableModelsCode(
              models: [model],
              config: GeneratorConfigBuilder().build(),
            )
            .values
            .single;

        final expected = _typedParameters.replaceAll(
          '_iss.',
          '_isc.',
        );

        expect(_parameters(code, 'Example'), expected);
        expect(_parameters(code, '_ExampleImpl'), expected);
      },
    );

    test(
      'when generating shared code, '
      'then public and implementation copyWith parameters retain their types.',
      () {
        final sharedModel = ModelClassDefinitionBuilder()
            .withSharedPackageName('shared')
            .build();
        sharedModel.fields.addAll(model.fields);

        final code = const DartSharedCodeGenerator()
            .generateSerializableModelsCode(
              models: [sharedModel],
              config: GeneratorConfigBuilder().withSharedModelsSourcePathsParts(
                {
                  'shared': ['shared'],
                },
              ).build(),
            )
            .values
            .single;

        expect(_parameters(code, 'Example'), _typedParameters);
        expect(_parameters(code, '_ExampleImpl'), _typedParameters);
      },
    );

    test(
      'when generating a copyWith implementation, '
      'then only omitted arguments use the existing deep copy.',
      () {
        final code = const DartServerCodeGenerator()
            .generateSerializableModelsCode(
              models: [model],
              config: GeneratorConfigBuilder().build(),
            )
            .values
            .single;

        expect(
          _copyWith(code, '_ExampleImpl').body.toSource(),
          '{return Example('
          'list: list is _is.UndefinedSentinel ? this.list?.map((e0) => e0.map((e1) => e1).toList()).toList() : list, '
          'map: map is _is.UndefinedSentinel ? this.map?.map((key0, value0) => MapEntry(key0, value0)) : map, '
          'set: set is _is.UndefinedSentinel ? this.set?.map((e0) => e0).toSet() : set, '
          'date: date is _is.UndefinedSentinel ? this.date : date, '
          'uuid: uuid is _is.UndefinedSentinel ? this.uuid : uuid, '
          'duration: duration is _is.UndefinedSentinel ? this.duration : duration, '
          'uri: uri is _is.UndefinedSentinel ? this.uri : uri, '
          'vector: vector is _is.UndefinedSentinel ? this.vector?.clone() : vector, '
          'halfVector: halfVector is _is.UndefinedSentinel ? this.halfVector?.clone() : halfVector, '
          'sparseVector: sparseVector is _is.UndefinedSentinel ? this.sparseVector?.clone() : sparseVector, '
          'bit: bit is _is.UndefinedSentinel ? this.bit?.clone() : bit, '
          'point: point is _is.UndefinedSentinel ? this.point : point, '
          'line: line is _is.UndefinedSentinel ? this.line : line, '
          'polygon: polygon is _is.UndefinedSentinel ? this.polygon : polygon, '
          'geometries: geometries is _is.UndefinedSentinel ? this.geometries : geometries);}',
        );
        expect(code, isNot(contains('class _Undefined ')));
        expect(code, isNot(contains('extends _is.UndefinedSentinel')));
      },
    );
  });

  group('Given a nullable model field inherited by a child,', () {
    late ModelClassDefinition parent;
    late ModelClassDefinition child;

    setUp(() {
      final target = ModelClassDefinitionBuilder()
          .withClassName('Target')
          .withModuleAlias('protocol')
          .build();
      parent = ModelClassDefinitionBuilder()
          .withClassName('Parent')
          .withFileName('parent')
          .withModuleAlias('protocol')
          .withField(_field('value', 'Target?'))
          .build();
      child = ModelClassDefinitionBuilder()
          .withClassName('Child')
          .withFileName('child')
          .withExtendsClass(parent)
          .build();
      parent.childClasses.add(ResolvedInheritanceDefinition(child));

      ModelDependencyResolver.resolveModelDependencies([target, parent, child]);
    });

    test(
      'when generating server code, '
      'then both copyWith signatures use private typed defaults.',
      () {
        final files = const DartServerCodeGenerator()
            .generateSerializableModelsCode(
              models: [parent, child],
              config: GeneratorConfigBuilder().build(),
            );
        final parentCode =
            files[path.join('lib', 'src', 'generated', 'parent.dart')]!;
        final childCode =
            files[path.join('lib', 'src', 'generated', 'child.dart')]!;

        expect(
          _parameters(parentCode, 'Parent'),
          r'({_itx02h2p.Target? value = const _UndefinedParent$value()})',
        );
        expect(
          _parameters(childCode, 'Child'),
          r'({_itx02h2p.Target? value = const _UndefinedChild$value()})',
        );
        expect(
          _parameters(childCode, '_ChildImpl'),
          _parameters(childCode, 'Child'),
        );
        expect(
          _copyWith(childCode, '_ChildImpl').body.toSource(),
          '{return Child(value: value is _is.UndefinedSentinel ? this.value?.copyWith() : value);}',
        );
        final unit = parseString(content: childCode).unit;
        final sentinel = CompilationUnitHelpers.tryFindClassDeclaration(
          unit,
          name: r'_UndefinedChild$value',
        );
        expect(
          sentinel?.extendsClause?.superclass.toSource(),
          '_is.UndefinedSentinel',
        );
        expect(
          sentinel?.implementsClause?.interfaces.single.toSource(),
          '_itx02h2p.Target',
        );
      },
    );
  });

  test(
    'Given a nullable sealed model field, '
    'when generating copyWith, '
    'then its implementation retains the untyped omission sentinel.',
    () {
      final target = ModelClassDefinitionBuilder()
          .withClassName('Target')
          .withModuleAlias('protocol')
          .withIsSealed(true)
          .build();
      final model = ModelClassDefinitionBuilder()
          .withField(_field('value', 'Target?'))
          .build();
      ModelDependencyResolver.resolveModelDependencies([target, model]);

      final code = const DartServerCodeGenerator()
          .generateSerializableModelsCode(
            models: [model],
            config: GeneratorConfigBuilder().build(),
          )
          .values
          .single;

      expect(
        _parameters(code, '_ExampleImpl'),
        '({Object? value = _Undefined})',
      );
      expect(code, isNot(contains('extends _is.UndefinedSentinel')));
    },
  );

  test(
    'Given same-named local and sealed module models, '
    'when resolving the module field type, '
    'then the sealed restriction survives nullability and record conversions.',
    () {
      final local = ModelClassDefinitionBuilder()
          .withClassName('Target')
          .withModuleAlias('protocol')
          .build();
      final external = ModelClassDefinitionBuilder()
          .withClassName('Target')
          .withModuleAlias('module')
          .withIsSealed(true)
          .build();

      final type = parseType(
        'module:module:Target?',
        extraClasses: [],
      ).applyProtocolReferences([local, external]);

      expect(type.classDefinition, same(external));
      expect(type.asNonNullable.classDefinition, same(external));
      expect(type.asNullable.classDefinition, same(external));
      expect(type.asNamedRecordField('value').classDefinition, same(external));
      expect(type.projectModelDefinition, isNull);
    },
  );

  test(
    'Given a resolved nullable module model field, '
    'when future-call analysis resolves only project models again, '
    'then the imported class remains available for typed copyWith generation.',
    () {
      final external = ModelClassDefinitionBuilder()
          .withClassName('Target')
          .withModuleAlias('module')
          .build();
      final model = ModelClassDefinitionBuilder()
          .withField(_field('value', 'module:module:Target?'))
          .build();
      ModelDependencyResolver.resolveModelDependencies([external, model]);

      ModelDependencyResolver.resolveModelDependencies([model]);

      expect(model.fields.single.type.classDefinition, same(external));
    },
  );

  test(
    'Given a resolved nullable sealed module field, '
    'when future-call analysis resolves only project models again, '
    'then the sealed restriction remains available for copyWith generation.',
    () {
      final external = ModelClassDefinitionBuilder()
          .withClassName('Target')
          .withModuleAlias('module')
          .withIsSealed(true)
          .build();
      final model = ModelClassDefinitionBuilder()
          .withField(_field('value', 'module:module:Target?'))
          .build();
      ModelDependencyResolver.resolveModelDependencies([external, model]);

      ModelDependencyResolver.resolveModelDependencies([model]);

      expect(model.fields.single.type.classDefinition, same(external));
    },
  );
}

const _typedParameters =
    r'({List<List<String?>>? list = const _iss.$UndefinedList<List<String?>>(), '
    r'Map<String, int?>? map = const _iss.$UndefinedMap<String, int?>(), '
    r'Set<int>? set = const _iss.$UndefinedSet<int>(), '
    r'DateTime? date = const _iss.$UndefinedDateTime(), '
    r'_iss.UuidValue? uuid = const _iss.$UndefinedUuidValue(), '
    r'Duration? duration = const _iss.$UndefinedDuration(), '
    r'Uri? uri = const _iss.$UndefinedUri(), '
    r'_iss.Vector? vector = const _iss.$UndefinedVector(), '
    r'_iss.HalfVector? halfVector = const _iss.$UndefinedHalfVector(), '
    r'_iss.SparseVector? sparseVector = const _iss.$UndefinedSparseVector(), '
    r'_iss.Bit? bit = const _iss.$UndefinedBit(), '
    r'_iss.GeographyPoint? point = const _iss.$UndefinedGeographyPoint(), '
    r'_iss.GeographyLineString? line = const _iss.$UndefinedGeographyLineString(), '
    r'_iss.GeographyPolygon? polygon = const _iss.$UndefinedGeographyPolygon(), '
    r'_iss.GeographyGeometryCollection? geometries = const _iss.$UndefinedGeographyGeometryCollection()})';

String _parameters(String code, String className) =>
    _copyWith(code, className).parameters!.toSource();

SerializableModelFieldDefinition _field(String name, String type) =>
    FieldDefinitionBuilder()
        .withName(name)
        .withType(parseType(type, extraClasses: []))
        .build();

MethodDeclaration _copyWith(String code, String className) {
  final unit = parseString(content: code).unit;
  final declaration = CompilationUnitHelpers.tryFindClassDeclaration(
    unit,
    name: className,
  )!;

  return CompilationUnitHelpers.tryFindMethodDeclaration(
    declaration,
    name: 'copyWith',
  )!;
}
