import 'package:path/path.dart' as p;

import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/config/config.dart';

List<ClassDefinition> getSealedClasses(
  List<SerializableModelDefinition> models,
) {
  return models
      .whereType<ClassDefinition>()
      .where((element) => element.sealedTopNode == element)
      .toList();
}

List<List<ClassDefinition>> getSealedHierarchies(
  List<SerializableModelDefinition> models,
) {
  var sealedClasses = getSealedClasses(models);

  return sealedClasses.map(
    (element) {
      return [...element.descendantClasses, element];
    },
  ).toList();
}

List<ClassDefinition> getSealedHierarchyClasses(
  List<SerializableModelDefinition> models,
) {
  return getSealedHierarchies(models).expand((e) => e).toList();
}

List<SerializableModelDefinition> getClassesWithoutSealedHierarchies(
  List<SerializableModelDefinition> models,
) {
  return models
      .where((e) => !getSealedHierarchyClasses(models).contains(e))
      .toList();
}

String createFilePath(
  GeneratorConfig config,
  SerializableModelDefinition model,
  bool serverCode,
) {
  return p.joinAll(
    [
      if (serverCode)
        ...config.generatedServeModelPathParts
      else
        ...config.generatedDartClientModelPathParts,
      ...model.subDirParts,
      '${model.fileName}.dart'
    ],
  );
}
