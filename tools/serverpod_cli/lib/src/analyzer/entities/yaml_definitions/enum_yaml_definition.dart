import '../validation/keywords.dart';
import '../validation/restrictions.dart';
import '../validation/validate_node.dart';

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
        valueRestriction: restrictions.validateBoolType,
      ),
      ValidateNode(
        Keyword.values,
        isRequired: true,
        valueRestriction: restrictions.validateEnumValues,
      ),
    };
  }
}
