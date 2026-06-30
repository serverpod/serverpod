// URLs for the Dockerised e2e suites (`test_e2e`, `test_e2e_migrations`), where
// the server runs as the `serverpod_test_server` compose service and is only
// reachable by that hostname. The host-based integration tests address the
// in-process server at localhost directly (see startup_shutdown_messages_test).
const serverUrl = 'http://serverpod_test_server:8080/';

const serverEndpointWebsocketUrl = 'ws://serverpod_test_server:8080/websocket';

const serverMethodWebsocketUrl = 'ws://serverpod_test_server:8080/v1/websocket';

const serviceServerUrl = 'http://serverpod_test_server:8081/';
