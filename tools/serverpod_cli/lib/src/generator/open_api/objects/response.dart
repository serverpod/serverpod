import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/open_api/objects/content.dart';

/// An API specification needs to specify the responses for all API operations.
/// Each operation must have at least one response defined, usually a
/// successful response. A response is defined by its HTTP status code and the
/// data returned in the response body and/or headers.
class ResponseObject {
  final TypeDefinition responseType;
  ResponseObject({
    required this.responseType,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    // 200 response
    var content = ContentObject(responseType: responseType);
    map['200'] = <String, dynamic>{'description': 'Success'};
    map['200']['content'] = content.toJson();
    // 400 bad request
    map['400'] = {
      'description':
          'Bad request (the query passed to the server was incorrect).'
    };
    // 403 forbidden
    map['403'] = {
      'description':
          'Forbidden (the caller is trying to call a restricted endpoint, but doesn\'t have the correct credentials/scope).'
    };
    // 500 internal server error
    map['500'] = {'description': 'Internal server error.'};
    return map;
  }
}
