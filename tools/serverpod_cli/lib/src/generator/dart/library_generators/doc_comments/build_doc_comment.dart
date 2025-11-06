extension PrependSlashes on String {
  String prependSlashes() {
    return split('\n').map((String line) => '/// $line').join('\n');
  }
}

String buildDocComment({
  required String generalDescription,
  required Map<String, String> docByParameter,
}) {
  var index = 0;
  var numberOfParameters = docByParameter.length;
  var parameterDocComments = docByParameter.entries.fold('', (
    String previousValue,
    entry,
  ) {
    var formattedParameterDoc = '[${entry.key}] ${entry.value}';

    var isLastParameter = index == numberOfParameters - 1;
    index++;
    return '$previousValue$formattedParameterDoc${isLastParameter ? '' : '\n\n'}';
  });

  return '$generalDescription\n'
          '\n'
          '$parameterDocComments'
      .prependSlashes();
}
