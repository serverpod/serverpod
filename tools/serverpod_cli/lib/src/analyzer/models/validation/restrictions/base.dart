import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/converter/converter.dart';
import 'package:source_span/source_span.dart';

abstract class ValueRestriction<T> {
  List<SourceSpanSeverityException> validate(
    String parentNodeName,
    T value,
    SourceSpan? span,
  );
}

abstract class CustomEnumValueRestriction<T extends Enum>
    extends ValueRestriction<T> {
  @override
  List<SourceSpanSeverityException> validate(
    String parentNodeName,
    T value,
    SourceSpan? span,
  );
}

class EnumValueRestriction<T extends Enum> extends ValueRestriction {
  final List<T> enums;
  final CustomEnumValueRestriction<T>? additionalRestriction;

  EnumValueRestriction({
    required this.enums,
    this.additionalRestriction,
  });

  @override
  List<SourceSpanSeverityException> validate(
    String parentNodeName,
    dynamic value,
    SourceSpan? span,
  ) {
    var options = enums.map((v) => v.name);

    var errors = <SourceSpanSeverityException>[
      SourceSpanSeverityException(
        '"$value" is not a valid property. Valid properties are $options.',
        span,
      )
    ];

    if (value is! String) return errors;

    var isEnumValue = enums.any(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
    );

    if (!isEnumValue) return errors;

    var restriction = additionalRestriction;
    if (restriction == null) return [];

    var enumValue = unsafeConvertToEnum(value: value, enumValues: enums);
    return restriction.validate(parentNodeName, enumValue, span);
  }
}

class BooleanValueRestriction extends ValueRestriction {
  @override
  List<SourceSpanSeverityException> validate(
    String parentNodeName,
    dynamic value,
    SourceSpan? span,
  ) {
    if (value is bool) return [];

    var errors = [
      SourceSpanSeverityException(
        'The value must be a boolean.',
        span,
      )
    ];

    if (value is! String) return errors;

    var boolValue = value.toLowerCase();
    if (!(boolValue == 'true' || boolValue == 'false')) {
      return errors;
    }

    return [];
  }
}

class StringValueRestriction extends ValueRestriction {
  @override
  List<SourceSpanSeverityException> validate(
    String parentNodeName,
    dynamic value,
    SourceSpan? span,
  ) {
    if (value is! String) {
      return [
        SourceSpanSeverityException(
          'The property must be a String.',
          span,
        )
      ];
    }

    return [];
  }
}
