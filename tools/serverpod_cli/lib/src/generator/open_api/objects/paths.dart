import 'package:serverpod_cli/src/generator/open_api/helpers/utils.dart';
import 'package:serverpod_cli/src/generator/open_api/objects/operation.dart';
import 'package:serverpod_cli/src/generator/open_api/objects/server.dart';

/// Holds the relative paths to the individual endpoints and their operations.
/// The path is appended to the URL from the Server Object in order to
/// construct the full URL.
/// The Paths may be empty, due to Access Control List (ACL) constraints.
class OpenAPIPaths {
  /// The name of the path.
  /// ```
  /// /pets <- pathName (ServerPod Endpoint Name)
  ///     - post/ <- pathItemObject (Serverpod Endpoint's method name)
  /// ```
  final String pathName;
  final OpenAPIPathItem? path;
  OpenAPIPaths({
    required this.pathName,
    this.path,
  });

  Map<String, dynamic> toJson() {
    return {pathName: path!.toJson()};
  }
}

/// Describes the operations available on a single path.
/// A Path Item may be empty, due to ACL constraints.
/// The path itself is still exposed to the documentation viewer
/// but they will not know which operations and parameters are available.
class OpenAPIPathItem {
  /// An optional, string summary, intended to apply to all operations in this
  /// path.
  final String? summary;

  /// An optional, string description, intended to apply to all operations in
  /// this path. CommonMark syntax may be used for rich text representation.
  final String? description;

  /// A definition of a GET operation on this path.
  final OperationObject? getOperation;

  /// A definition of a PUT operation on this path.
  final OperationObject? putOperation;

  /// A definition of a POST operation on this path.
  final OperationObject postOperation;

  /// A definition of a DELETE operation on this path.
  final OperationObject? deleteOperation;

  /// A definition of a OPTIONS operation on this path.
  final OperationObject? optionsOperation;

  /// A definition of a HEAD operation on this path.
  final OperationObject? headOperation;

  /// A definition of a PATCH operation on this path.
  final OperationObject? patchOperation;

  /// A definition of a TRACE operation on this path.
  final OperationObject? traceOperation;

  /// An alternative server array to service all operations in this path.
  final List<OpenAPIServer>? servers;

  OpenAPIPathItem({
    this.summary,
    this.description,
    this.getOperation,
    this.putOperation,
    required this.postOperation,
    this.deleteOperation,
    this.optionsOperation,
    this.headOperation,
    this.patchOperation,
    this.traceOperation,
    this.servers,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (summary != null) {
      map[OpenAPIJsonKey.summary.name] = summary;
    }
    if (description != null) {
      map[OpenAPIJsonKey.description.name] = description;
    }

    map[OpenAPIJsonKey.post.name] = postOperation.toJson();

    return map;
  }
}
