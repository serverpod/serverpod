extension PrependSlashes on String {
  String prependSlashes() {
    return split('\n').map((String line) => '/// $line').join('\n');
  }
}

String buildDocComment(
  String generalDescription,
  Map<String, String> docByParameter,
  List<String> parameters,
) {
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
          '$parameterDocComments'
      .prependSlashes();
}
