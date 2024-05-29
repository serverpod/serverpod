import 'package:http/http.dart';

/// Base Auth Http Client
class AuthBaseClient extends BaseClient {
  @override
  Future<StreamedResponse> send(
    BaseRequest request,
  ) async {
    return request.send();
  }
}
