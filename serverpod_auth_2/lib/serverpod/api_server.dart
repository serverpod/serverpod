class ApiServer {
  var _endpointsByModule = <String, Map<String, String Function()>>{};

  void registerEndpoint(
    String module,
    Map<String, String Function()> endpoints,
  ) {
    _endpointsByModule[module] = endpoints;
  }

  String handleCall(String module, String method) {
    return _endpointsByModule[module]![method]!();
  }
}
