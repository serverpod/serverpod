// URLs for the Dockerised `test_e2e` suite, where the server runs as the
// `serverpod_test_server` compose service and is only reachable by that
// hostname. The host-based suites address the server at localhost directly:
// the integration tests via the in-process server (see
// startup_shutdown_messages_test), and the migration e2e via
// SERVERPOD_TEST_SERVICE_URL (see test_util/service_client.dart).
const serverUrl = 'http://serverpod_test_server:8080/';

const serverEndpointWebsocketUrl = 'ws://serverpod_test_server:8080/websocket';

const serverMethodWebsocketUrl = 'ws://serverpod_test_server:8080/v1/websocket';

const serviceServerUrl = 'http://serverpod_test_server:8081/';
