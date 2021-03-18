import 'connection_handler.dart';
import 'package:serverpod_service_client/protocol/protocol.dart';

final AppState state = AppState();

class AppState {
  ConnectionHandler connectionHandler = ConnectionHandler('production');
  Client? get client => connectionHandler.client;
  List<Client> get clients => connectionHandler.clients;

  AppState();
}