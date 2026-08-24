import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/custom_allocators.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';

const generator = DartServerCodeGenerator();
final config = GeneratorConfigBuilder().withName('example_project').build();

/// Two URLs found by birthday search over [importPrefixFor] to share a prefix.
///
/// [laterCollidingUrl] is the one that sorts last, which is what decides which
/// of the two keeps the prefix they both hash to.
const collidingUrl = 'package:p173851/lib173851.dart';
const laterCollidingUrl = 'package:p271239/lib271239.dart';

/// A sealed parent with one part file per URL in [urls], each referencing a
/// type from the URL at its position.
List<SerializableModelDefinition> sealedHierarchyReferencing(
  List<String> urls,
) {
  var parent = ModelClassDefinitionBuilder()
      .withClassName('SealedParent')
      .withFileName('sealed_parent')
      .withSimpleField('name', 'String')
      .withIsSealed(true)
      .build();

  var children = [
    for (var (index, url) in urls.indexed)
      ModelClassDefinitionBuilder()
          .withClassName('Child$index')
          .withFileName('child_$index')
          .withField(
            FieldDefinitionBuilder()
                .withName('value$index')
                .withType(
                  TypeDefinition(
                    className: 'Colliding',
                    url: url,
                    nullable: true,
                  ),
                )
                .build(),
          )
          .withExtendsClass(parent)
          .build(),
  ];

  for (var child in children) {
    parent.childClasses.add(ResolvedInheritanceDefinition(child));
  }

  return [parent, ...children];
}

/// The prefix each import of the library owning the hierarchy is aliased with,
/// keyed by URL.
Map<String, String> importsOfOwningLibrary(
  List<SerializableModelDefinition> models,
) {
  var codeMap = generator.generateSerializableModelsCode(
    models: models,
    config: config,
  );
  var owningLibrary = codeMap.entries
      .firstWhere((entry) => entry.key.endsWith('sealed_parent.dart'))
      .value;

  return {
    for (var match in RegExp(
      r"import '([^']+)'\s*as (_i[a-z0-9]+);",
    ).allMatches(owningLibrary))
      match.group(1)!: match.group(2)!,
  };
}

void main() {
  group(
    'Given a sealed hierarchy whose part files reference two URLs that hash '
    'to the same import prefix,',
    () {
      late List<SerializableModelDefinition> models;

      setUp(() {
        models = sealedHierarchyReferencing([collidingUrl, laterCollidingUrl]);
      });

      test(
        'when the hierarchy is generated, '
        'then the library owning it imports both URLs.',
        () {
          expect(
            importsOfOwningLibrary(models).keys,
            containsAll([collidingUrl, laterCollidingUrl]),
          );
        },
      );

      test(
        'when the hierarchy is generated, '
        'then the two URLs are imported under different prefixes.',
        () {
          var imports = importsOfOwningLibrary(models);

          expect(imports[collidingUrl], isNot(imports[laterCollidingUrl]));
        },
      );

      test(
        'when the hierarchy is generated, '
        'then the URL that sorts first keeps the prefix it hashes to.',
        () {
          expect(
            importsOfOwningLibrary(models)[collidingUrl],
            importPrefixFor(collidingUrl),
          );
        },
      );
    },
  );

  group(
    'Given a sealed hierarchy whose part files reference two URLs that hash '
    'to the same import prefix, and the same hierarchy with those part files '
    'in the opposite order,',
    () {
      late List<SerializableModelDefinition> models;
      late List<SerializableModelDefinition> reorderedModels;

      setUp(() {
        models = sealedHierarchyReferencing([collidingUrl, laterCollidingUrl]);
        reorderedModels = sealedHierarchyReferencing([
          laterCollidingUrl,
          collidingUrl,
        ]);
      });

      test(
        'when both are generated, '
        'then each aliases the two URLs the same way.',
        () {
          expect(
            importsOfOwningLibrary(reorderedModels),
            importsOfOwningLibrary(models),
          );
        },
      );
    },
  );
}
