import 'package:intl/intl.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/utils/duration_utils.dart';
import 'package:serverpod_cli/src/analyzer/models/utils/quote_utils.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/base.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:source_span/source_span.dart';

class DefaultValueRestriction extends ValueRestriction {
  final String key;
  final SerializableModelDefinition? documentDefinition;

  DefaultValueRestriction(
    this.key,
    this.documentDefinition,
  );

  @override
  List<SourceSpanSeverityException> validate(
    String parentNodeName,
    dynamic value,
    SourceSpan? span,
  ) {
    var definition = documentDefinition;
    if (definition is! ClassDefinition) return [];

    var field = definition.findField(parentNodeName);
    if (field == null) return [];

    var defaultValueType = field.type.defaultValueType;
    if (defaultValueType == null) return [];

    if ((definition is ModelClassDefinition) &&
        (definition.tableName != null) &&
        (parentNodeName == defaultPrimaryKeyName)) {
      return _idTypeDefaultValidation(
        definition.tableName!,
        field.type,
        value,
        span,
      );
    }

    switch (defaultValueType) {
      case DefaultValueAllowedType.dateTime:
        return _dateDateValidation(value, span);
      case DefaultValueAllowedType.bool:
        return _booleanValidation(value, span);
      case DefaultValueAllowedType.int:
        return _integerValidation(value, span);
      case DefaultValueAllowedType.double:
        return _doubleValidation(value, span);
      case DefaultValueAllowedType.string:
        return _stringValidation(value, span);
      case DefaultValueAllowedType.uuidValue:
        return _uuidValueValidation(value, span);
      case DefaultValueAllowedType.bigInt:
        return _bigIntValueValidation(value, span);
      case DefaultValueAllowedType.duration:
        return _durationValidation(value, span);
      case DefaultValueAllowedType.isEnum:
        return _enumValidation(value, span, field);
      case DefaultValueAllowedType.uri:
        return _uriValueValidation(value, span);
    }
  }

  List<SourceSpanSeverityException> _idTypeDefaultValidation(
    String tableName,
    TypeDefinition idType,
    dynamic value,
    SourceSpan? span,
  ) {
    var typeClassName = idType.className;
    var errors = <SourceSpanSeverityException>[];

    if ((value == defaultIntSerial) && (key == Keyword.defaultModelKey)) {
      return [
        SourceSpanSeverityException(
          'The default value "$defaultIntSerial" can not be set for the '
          '"int" $defaultPrimaryKeyName field using the "$key" keyword. '
          'Use the "${Keyword.defaultPersistKey}" keyword instead.',
          span,
        ),
      ];
    }

    if ((key == Keyword.defaultModelKey) && idType.nullable) {
      errors.add(
        SourceSpanSeverityException(
          'The "$defaultPrimaryKeyName" field is nullable, but the keyword '
          '"${Keyword.defaultModelKey}" ensures that it will always have a '
          'value, unless explicitly removed. Consider making it non-nullable '
          'to avoid unnecessary null checks.',
          span,
          severity: SourceSpanSeverity.hint,
        ),
      );
    }

    var supportedDefaults = SupportedIdType.all
        .where((e) => e.type.className == typeClassName)
        .map((e) => e.defaultValue);

    if (!supportedDefaults.contains(value)) {
      var options = supportedDefaults.map((e) => '"$e"').join(', ');
      errors.add(
        SourceSpanSeverityException(
          'The default value "$value" is not supported for the id type '
          '"$typeClassName". Valid options are: $options.',
          span,
        ),
      );
    }

    return errors;
  }

  List<SourceSpanSeverityException> _dateDateValidation(
    dynamic value,
    SourceSpan? span,
  ) {
    if (value is DateTime) return [];

    var errors = <SourceSpanSeverityException>[];

    if (value is! String || value.isEmpty) {
      errors.add(
        SourceSpanSeverityException(
          'The "$key" value must be a valid UTC DateTime String or "now"',
          span,
        ),
      );
      return errors;
    }

    if (value == defaultDateTimeValueNow) return [];

    var format = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

    DateTime? dateTime = DateFormat(format).tryParseStrict(value);

    if (dateTime == null) {
      errors.add(
        SourceSpanSeverityException(
          'The "$key" value must be a valid UTC ($format) DateTime String or "now"',
          span,
        ),
      );
    }

    return errors;
  }

  List<SourceSpanSeverityException> _booleanValidation(
    dynamic value,
    SourceSpan? span,
  ) {
    if (value is bool) return [];

    var errors = <SourceSpanSeverityException>[];

    if (value is! String ||
        value.isEmpty ||
        (value != defaultBooleanTrue && value != defaultBooleanFalse)) {
      errors.add(
        SourceSpanSeverityException(
          'The "$key" value must be a valid boolean: "true" or "false"',
          span,
        ),
      );
      return errors;
    }

    return errors;
  }

  List<SourceSpanSeverityException> _integerValidation(
    dynamic value,
    SourceSpan? span,
  ) {
    if (value is int) return [];

    var errors = <SourceSpanSeverityException>[];

    if (value is! String || value.isEmpty) {
      errors.add(
        SourceSpanSeverityException(
          'The "$key" value must be a valid integer (e.g., "$key"=10).',
          span,
        ),
      );
      return errors;
    }

    int? parsedValue = int.tryParse(value);
    if (parsedValue == null) {
      errors.add(
        SourceSpanSeverityException(
          'The "$key" value must be a valid integer (e.g., "$key"=10).',
          span,
        ),
      );
    }
    return errors;
  }

  List<SourceSpanSeverityException> _doubleValidation(
    dynamic value,
    SourceSpan? span,
  ) {
    if (value is double) return [];

    var errors = <SourceSpanSeverityException>[];

    if (value is! String || value.isEmpty) {
      errors.add(
        SourceSpanSeverityException(
          'The "$key" value must be a valid double (e.g., "$key"=10.5).',
          span,
        ),
      );
      return errors;
    }

    double? parsedValue = double.tryParse(value);
    if (parsedValue == null) {
      errors.add(
        SourceSpanSeverityException(
          'The "$key" value must be a valid double (e.g., "$key"=10.5).',
          span,
        ),
      );
    }

    return errors;
  }

  List<SourceSpanSeverityException> _stringValidation(
    dynamic value,
    SourceSpan? span,
  ) {
    var errors = <SourceSpanSeverityException>[];

    if (value is! String || value.isEmpty) {
      errors.add(
        SourceSpanSeverityException(
          'The "$key" must be a quoted string (e.g., "$key"=\'This is a string\' or "$key"="This is a string").',
          span,
        ),
      );
      return errors;
    }

    bool validDoubleQuote = isValidDoubleQuote(value);
    bool validSingleQuote = isValidSingleQuote(value);

    if (validDoubleQuote || validSingleQuote) {
      return errors;
    }

    if (value.startsWith('\'') && !validSingleQuote) {
      errors.add(
        SourceSpanSeverityException(
          'For single quoted "$key" string values, single quotes must be escaped or use double quotes (e.g., "$key"=\'This "is" a string\' or "$key"=\'This \\\'is\\\' a string\').',
          span,
        ),
      );
    } else if (value.startsWith('"') && !validDoubleQuote) {
      errors.add(
        SourceSpanSeverityException(
          'For double quoted "$key" string values, double quotes must be escaped or use single quotes (e.g., "$key"="This \'is\' a string" or "$key"="This \\"is\\" a string").',
          span,
        ),
      );
    } else {
      errors.add(
        SourceSpanSeverityException(
          'The "$key" must be a quoted string (e.g., "$key"=\'This is a string\' or "$key"="This is a string").',
          span,
        ),
      );
    }

    return errors;
  }

  List<SourceSpanSeverityException> _uuidValueValidation(
    dynamic value,
    SourceSpan? span,
  ) {
    var errors = <SourceSpanSeverityException>[];

    if (value is UuidValue) {
      try {
        value.validate();
        return [];
      } catch (e) {
        errors.add(
          SourceSpanSeverityException(
            'The "$key" contains an invalid UUID value.',
            span,
          ),
        );
        return errors;
      }
    }

    String invalidValueError =
        'The "$key" value must be "random", "random_v7" or valid UUID string (e.g., "$key"=random or "$key"=\'550e8400-e29b-41d4-a716-446655440000\').';

    if (value is! String || value.isEmpty) {
      errors.add(
        SourceSpanSeverityException(
          invalidValueError,
          span,
        ),
      );
      return errors;
    }

    if ((value == defaultUuidValueRandom) ||
        (value == defaultUuidValueRandomV7)) {
      return [];
    }

    if (!value.startsWith("'") && !value.startsWith('"')) {
      errors.add(
        SourceSpanSeverityException(
          invalidValueError,
          span,
        ),
      );
      return errors;
    }

    bool validSingleQuote = isValidSingleQuote(value);
    bool validDoubleQuote = isValidDoubleQuote(value);

    if (value.startsWith("'") && !validSingleQuote) {
      errors.add(
        SourceSpanSeverityException(
          'The "$key" must be a quoted string (e.g., "$key"=\'550e8400-e29b-41d4-a716-446655440000\').',
          span,
        ),
      );
      return errors;
    } else if (value.startsWith('"') && !validDoubleQuote) {
      errors.add(
        SourceSpanSeverityException(
          'The "$key" must be a quoted string (e.g., "$key"="550e8400-e29b-41d4-a716-446655440000").',
          span,
        ),
      );
      return errors;
    }

    /// Extract the actual UUID string by removing quotes
    String uuidString = value.substring(1, value.length - 1);
    UuidValue uuidValue = UuidValue.fromString(uuidString);
    try {
      uuidValue.validate();
    } catch (_) {
      errors.add(
        SourceSpanSeverityException(
          'The "$key" value must be a valid UUID (e.g., \'550e8400-e29b-41d4-a716-446655440000\').',
          span,
        ),
      );
    }

    return errors;
  }

  List<SourceSpanSeverityException> _bigIntValueValidation(
    dynamic value,
    SourceSpan? span,
  ) {
    if (value is BigInt) return [];

    if (value is! String || value.isEmpty || BigInt.tryParse(value) == null) {
      return [
        SourceSpanSeverityException(
          'The "$key" value must be a valid BigInt (e.g., "$key"=\'1234567890\').',
          span,
        ),
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> _durationValidation(
    dynamic value,
    SourceSpan? span,
  ) {
    if (value is Duration) return [];

    var errors = <SourceSpanSeverityException>[];

    if (value is! String || value.isEmpty || !isValidDuration(value)) {
      errors.add(
        SourceSpanSeverityException(
          'The "$key" value must be a valid duration in the format "Xd Xh Xmin Xs Xms" (e.g., "$key"=1d 2h 30min 45s 100ms).',
          span,
        ),
      );
      return errors;
    }

    return errors;
  }

  List<SourceSpanSeverityException> _uriValueValidation(
    dynamic value,
    SourceSpan? span,
  ) {
    if (value is Uri) {
      return [];
    }

    String invalidValueError =
        'The "$key" value must be a a valid Uri string (e.g., "$key"=\'http://serverpod.dev\').';

    if (value is! String || value.isEmpty) {
      return [
        SourceSpanSeverityException(
          invalidValueError,
          span,
        ),
      ];
    }

    bool invalidDefaultValue = value != defaultUuidValueRandom &&
        !value.startsWith("'") &&
        !value.startsWith('"');

    if (invalidDefaultValue) {
      return [
        SourceSpanSeverityException(
          invalidValueError,
          span,
        ),
      ];
    }

    if (value == defaultUuidValueRandom) return [];

    bool validSingleQuote = isValidSingleQuote(value);
    bool validDoubleQuote = isValidDoubleQuote(value);

    if (value.startsWith("'") && !validSingleQuote) {
      return [
        SourceSpanSeverityException(
          'The "$key" must be a quoted string (e.g., "$key"=\'http://serverpod.dev\').',
          span,
        ),
      ];
    } else if (value.startsWith('"') && !validDoubleQuote) {
      return [
        SourceSpanSeverityException(
          'The "$key" must be a quoted string (e.g., "$key"="http://serverpod.dev").',
          span,
        ),
      ];
    }

    /// Extract the actual Uri string by removing quotes
    String uriString = value.substring(1, value.length - 1);
    var isValid = Uri.tryParse(uriString) != null;
    if (!isValid) {
      return [
        SourceSpanSeverityException(
          'The "$key" value must be a valid Uri (e.g., \'http://serverpod.dev\').',
          span,
        ),
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> _enumValidation(
    dynamic value,
    SourceSpan? span,
    SerializableModelFieldDefinition field,
  ) {
    var errors = <SourceSpanSeverityException>[];

    var enumDefinition = field.type.enumDefinition;

    /// This check ensures that the field is indeed an enum type.
    /// Although this method should only be called for enum types,
    /// we include this check as a safeguard.
    if (enumDefinition == null) {
      errors.add(
        SourceSpanSeverityException(
          'The "${field.name}" field is not an enum type, but an enum value was expected.',
          span,
        ),
      );
      return errors;
    }

    var enumNameValues = enumDefinition.values.map((e) => e.name).toSet();

    if (value is! String || value.isEmpty || !enumNameValues.contains(value)) {
      errors.add(
        SourceSpanSeverityException(
          'The "$key" value must be a valid enum value from the set: (${enumNameValues.join(', ')}).',
          span,
        ),
      );
    }

    return errors;
  }
}
