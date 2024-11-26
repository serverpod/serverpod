import 'dart:io';

import 'package:relic/src/headers/parser/headers_parser.dart';

extension HttpRequestExtension on HttpRequest {
  HeadersParser getHeadersParser({
    required bool strict,
    required void Function(String, List<String>) onHeaderFailedToParse,
  }) {
    return HeadersParser(
      headers: headers,
      strict: strict,
      onHeaderFailedToParse: onHeaderFailedToParse,
    );
  }
}
