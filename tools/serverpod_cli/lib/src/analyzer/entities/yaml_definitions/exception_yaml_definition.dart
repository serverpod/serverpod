import '../validation/keywords.dart';
import '../validation/restrictions.dart';
import '../validation/validate_node.dart';

class ExceptionYamlDefinition {
  late Set<ValidateNode> documentStructure;

  ValidateNode get fieldStructure {
    return documentStructure
        .firstWhere((element) => element.key == Keyword.fields)
        .nested
        .first;
  }

  ExceptionYamlDefinition(Restrictions restrictions) {
    documentStructure = {
      ValidateNode(
        Keyword.exceptionType,
        isRequired: true,
        valueRestriction: restrictions.validateClassName,
      ),
      ValidateNode(
        Keyword.serverOnly,
        valueRestriction: restrictions.validateBoolType,
      ),
      ValidateNode(
        Keyword.fields,
        isRequired: true,
        nested: {
          ValidateNode(
            Keyword.any,
            keyRestriction: restrictions.validateFieldName,
            allowStringifiedNestedValue: true,
            nested: {
              ValidateNode(
                Keyword.type,
                isRequired: true,
                valueRestriction: restrictions.validateFieldDataType,
              ),
            },
          ),
        },
      ),
    };
  }
}
