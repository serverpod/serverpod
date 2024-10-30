extension PrependSlashes on String {
  String prependSlashes() {
    return split('\n').map((String line) => '/// $line').join('\n');
  }
}

String buildDocComment({
  required String generalDescription,
  required Map<String, String> docByParameter,
  required List<String> parameters,
  String? parameterHeader,
}) {
  var index = 0;
  var numberOfParameters = parameters.length;
  var parameterDocComments =
      parameters.fold('', (String previousValue, parameter) {
    var parameterDoc = docByParameter[parameter];
    if (parameterDoc == null) {
      throw StateError('No documentation for parameter $parameter');
    }

    var formattedParameterDoc = '[$parameter] $parameterDoc';

    var isLastParameter = index == numberOfParameters - 1;
    index++;
    return '$previousValue$formattedParameterDoc${isLastParameter ? '' : '\n\n'}';
  });

  return '$generalDescription\n'
          '\n'
          '${parameterHeader == null ? '' : '**$parameterHeader** \n\n'}'
          '$parameterDocComments'
      .prependSlashes();
}
