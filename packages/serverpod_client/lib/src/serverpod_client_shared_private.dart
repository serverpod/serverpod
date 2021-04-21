import 'dart:convert';

String formatArgs(Map<String, dynamic> args, String? authorizationKey, String method) {
  var formattedArgs = <String, String?>{};

  for (var argName in args.keys) {
    var value = args[argName];
    if (value != null) {
      formattedArgs[argName] = value.toString();
    }
  }

  if (authorizationKey != null)
    formattedArgs['auth'] = authorizationKey;

  formattedArgs['method'] = method;

  return jsonEncode(formattedArgs);
}