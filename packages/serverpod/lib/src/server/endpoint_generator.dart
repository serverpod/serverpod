//import 'package:serverpod/serverpod.dart';
//import '../generated/protocol.dart';
//import '../cache/endpoint.dart';
//import '../insights/endpoint.dart';
//import 'runmode.dart';
//
//void main(List<String> args) async {
//  var server = Server(serverId: 0, port: 8080, serializationManager: Protocol(), runMode: ServerpodRunMode.generate);
//  server.addEndpoint(CacheEndpoint(1024, server.serializationManager, null), endpointNameCache);
//  server.addEndpoint(CacheEndpoint(1024, server.serializationManager, null), endpointNameCachePrio);
//  server.addEndpoint(InsightsEndpoint(null), endpointNameInsights);
//
//  for (Endpoint endpoint in server.endpoints.values) {
//    endpoint.printDefinition();
//  }
//}