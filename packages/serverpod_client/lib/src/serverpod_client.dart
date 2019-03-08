import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';

class ServerpodClient {
  final String host;
  final SerializationManager serializationManager;
  HttpClient _httpClient;

  ServerpodClient(this.host, this.serializationManager, {SecurityContext context}) {
    _httpClient = HttpClient(context: context);
    assert(host.endsWith('/'), 'host must end with a slash, eg: https://example.com/');
    assert(host.startsWith('http://') || host.startsWith('https://'), 'host must include protocol, eg: https://example.com/');
  }

  Future<dynamic> callServerEndpoint(String endpoint, String returnTypeName, Map<String, dynamic> args) async {
    var formattedArgs = <String>[];
    for (var argName in args.keys) {
      var value = args[argName];
      if (value != null)
        formattedArgs.add('$argName=${Uri.encodeQueryComponent('$value')}');
    }

    var queryStr = formattedArgs.join('&');
    if (formattedArgs.length > 0)
      queryStr = '?$queryStr';

    Uri url = Uri.parse('$host$endpoint$queryStr');

    HttpClientRequest request = await _httpClient.getUrl(url);
    HttpClientResponse response = await request.close();  // done instead of close() ?
    String data = await _readResponse(response);

    if (returnTypeName == 'int')
      return int.parse(data);
    else if (returnTypeName == 'String')
      return data;

    return serializationManager.createEntityFromSerialization(jsonDecode(data));
  }

  Future<dynamic> _readResponse(HttpClientResponse response) {
    var completer = new Completer();
    var contents = new StringBuffer();
    response.transform(Utf8Decoder()).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }
}