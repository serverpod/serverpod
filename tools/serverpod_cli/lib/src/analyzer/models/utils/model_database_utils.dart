import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';

extension ModelClassDefinitionClientDatabase on ModelClassDefinition {
  /// Whether this host-owned model requires client-side database support.
  ///
  /// Shared-package and module models never count, even when [database] is
  /// [ModelDatabaseDefinition.client] or [ModelDatabaseDefinition.all].
  bool get isHostClientDatabaseTable {
    if (serverOnly || isSharedModel || !shouldGenerateTableCode(false)) {
      return false;
    }
    final alias = type.moduleAlias;
    return alias == null || alias == defaultModuleAlias;
  }
}

extension SerializableModelDefinitionsClientDatabase
    on Iterable<SerializableModelDefinition> {
  /// Whether the host project has models that require client-side database
  /// support.
  ///
  /// Only host-owned table models with [ModelDatabaseDefinition.client] or
  /// [ModelDatabaseDefinition.all] count. Shared-package and module models are
  /// merged into the client schema once this gate passes, but do not enable
  /// client-side database support on their own.
  bool get hasHostClientDatabaseTables => whereType<ModelClassDefinition>().any(
    (model) => model.isHostClientDatabaseTable,
  );
}
