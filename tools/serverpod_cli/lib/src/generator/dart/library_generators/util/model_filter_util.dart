import 'package:serverpod_cli/analyzer.dart';

bool isBaseClass(
  SerializableModelDefinition protocolFile,
  List<SerializableModelDefinition> models,
) {
  var subClasses = models
      .whereType<ClassDefinition>()
      .where((element) => element.extendsClass == protocolFile.className);

  return subClasses.isNotEmpty;
}

ClassDefinition? getBaseClassOrNull(
  SerializableModelDefinition protocolFile,
  List<SerializableModelDefinition> models,
) {
  if (protocolFile is! ClassDefinition) {
    return null;
  }

  try {
    return models.whereType<ClassDefinition>().firstWhere(
        (element) => element.className == protocolFile.extendsClass);
  } catch (e) {
    return null;
  }
}
