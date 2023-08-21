/// Manages user customisable http request headers
abstract class HeaderManager {
  /// Retrieves all headers that need to be added to the request.
  Future<Map<String, String>?> get();
}
