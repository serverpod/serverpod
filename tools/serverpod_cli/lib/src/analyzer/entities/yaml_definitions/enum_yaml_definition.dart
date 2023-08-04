import 'package:serverpod_cli/src/analyzer/entities/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/restrictions.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/validate_node.dart';

class EnumYamlDefinition {
  late Set<ValidateNode> documentStructure;

  EnumYamlDefinition(Restrictions restrictions) {
    documentStructure = {
      ValidateNode(
        Keyword.enumType,
        isRequired: true,
        valueRestriction: restrictions.validateClassName,
      ),
      ValidateNode(
        Keyword.serverOnly,
        valueRestriction: BooleanValue().validate,
      ),
      ValidateNode(
        Keyword.values,
        isRequired: true,
        valueRestriction: restrictions.validateEnumValues,
      ),
    };
  }
}
