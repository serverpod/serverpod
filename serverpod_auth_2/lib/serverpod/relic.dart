class RelicServer {
  var _endpoints = <String, String Function()>{};

  void registerEndpoint(String path, String Function() handler) {
    _endpoints[path] = handler;
  }

  String handleCall(String path) {
    return _endpoints[path]!();
  }
}
