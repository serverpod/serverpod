import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/base.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/default.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/validate_node.dart';

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
        valueRestriction: BooleanValueRestriction().validate,
      ),
      ValidateNode(
        Keyword.isImplementing,
        valueRestriction: restrictions.validateImplementedInterfaceNames,
      ),
      ValidateNode(
        Keyword.fields,
        isRequired: false,
        nested: {
          ValidateNode(
            Keyword.any,
            keyRestriction: restrictions.validateFieldName,
            allowStringifiedNestedValue: const StringifiedNestedValues(
              isAllowed: true,
              hasImplicitFirstKey: true,
            ),
            nested: {
              ValidateNode(
                Keyword.type,
                isRequired: true,
                valueRestriction: restrictions.validateFieldType,
              ),
              ValidateNode(
                Keyword.defaultKey,
                keyRestriction: restrictions.validateDefaultKey,
                valueRestriction: DefaultValueRestriction(
                  Keyword.defaultKey,
                  restrictions.documentDefinition,
                ).validate,
              ),
              ValidateNode(
                Keyword.defaultModelKey,
                keyRestriction: restrictions.validateDefaultModelKey,
                valueRestriction: DefaultValueRestriction(
                  Keyword.defaultModelKey,
                  restrictions.documentDefinition,
                ).validate,
              ),
            },
          ),
        },
      ),
    };
  }
}
