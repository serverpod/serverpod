part of '../open_api_objects.dart';

/// Holds the relative paths to the individual endpoints and their operations.
/// The path is appended to the URL from the Server Object in order to
///  construct the full URL.
/// The Paths may be empty, due to Access Control List (ACL) constraints.
class PathsObject {
  /// name of the path
  /// ```
  /// /pets <- pathName (ServerPod Endpoint Name)
  ///     - post/ <- pathItemObject (Serverpod Endpoint's method name)
  /// ```
  final String pathName;
  final PathItemObject? path;
  PathsObject({
    required this.pathName,
    this.path,
  });

  Map<String, dynamic> toJson() {
    return {'/$pathName': path ?? {}};
  }
}

/// Describes the operations available on a single path.
/// A Path Item may be empty, due to ACL constraints.
/// The path itself is still exposed to the documentation viewer
/// but they will not know which operations and parameters are available.
class PathItemObject {
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
  final OperationObject? postOperation;

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
  final List<ServerObject>? servers;

  PathItemObject({
    this.summary,
    this.description,
    this.getOperation,
    this.putOperation,
    this.postOperation,
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
      map['summary'] = summary;
    }
    if (description != null) {
      map['description'] = description;
    }

    if (postOperation != null) {
      map['post'] = postOperation!.toJson();
    }

    return map;
  }

  factory PathItemObject.fromMethod(MethodDefinition method, String tag) {
    String? description = method.documentationComment;

    /// Method name is operationId
    String operationId = method.name;
    ResponseObject responseObject = ResponseObject(
      responseType: ContentObject(
        contentTypes: [ContentType.applicationJson],
        schemaObject: ContentSchemaObject(
          returnType: method.returnType,
        ),
      ),
    );
    // log.info('''
    // ${method.name}
    // ${method.returnType}
    // ${method.returnType.className}
    // ${method.returnType.generics.first.className}
    // ${method.returnType.generics.map(
    //           (e) => e.generics.map(
    //             (e) => e.className,
    //           ),
    //         ).toList()}

    // ''');
    // log.info(method.parameters
    //     .map((ParameterDefinition param) =>
    //         'param required ${param.name} | type ${param.type.className}')
    //     .toList()
    //     .toString());

    // log.info(method.parametersNamed
    //     .map((ParameterDefinition param) =>
    //         'param named ${param.name} | type ${param.type.className}')
    //     .toList()
    //     .toString());
    // log.info(method.parametersPositional
    //     .map((ParameterDefinition param) =>
    //         'param p name ${param.name} | type ${param.type.className}')
    //     .toList()
    //     .toString());
    List<ParameterDefinition> params = [
      ...method.parameters,
      ...method.parametersNamed,
      ...method.parametersPositional
    ];

    // TODO : Change to OperationObject.fromParameterDefinitionList
    return PathItemObject(
      description: description,
      postOperation: OperationObject(
        description: description,
        operationId: operationId,
        responses: responseObject,
        tags: [tag],

        /// No need in OpeApi 2.0
        parameters: [],
        requestBody: RequestBodyObject.fromParameterDefinitionList(params),
        security: SecurityRequirementObject(),
      ),
    );
  }
}
