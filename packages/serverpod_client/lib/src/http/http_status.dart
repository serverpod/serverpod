// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * HTTP status codes. Extracted from dart:io since it does not exist on package:web/web.dart.
 */
abstract class HttpStatus {
  /// The client should continue with its request. This interim response is used to inform the client that the initial part of the request has been received and has not yet been rejected by the server.
  static const int continue_ = 100;
  
  /// The server understands and is willing to comply with the client's request to switch protocols.
  static const int switchingProtocols = 101;

  /// The server has received and is processing the request, but no response is available yet.
  static const int processing = 102;

  /// The request has succeeded. The information returned with the response is dependent on the method used in the request.
  static const int ok = 200;

  /// The request has been fulfilled and resulted in a new resource being created.
  static const int created = 201;

  /// The request has been accepted for processing, but the processing has not been completed.
  static const int accepted = 202;

  /// The server has successfully processed the request, but is returning information that may be from another source.
  static const int nonAuthoritativeInformation = 203;

  /// The server has successfully processed the request, but is not returning any content.
  static const int noContent = 204;

  /// The server has successfully processed the request, but is not returning any content, and requires that the requester reset the document view.
  static const int resetContent = 205;

  /// The server has successfully processed the request, and is returning only part of the content.
  static const int partialContent = 206;

  /// The message body that follows is by default an XML message and can contain a number of separate response codes, depending on how many sub-requests were made.
  static const int multiStatus = 207;

  /// The members of a DAV binding have already been enumerated in a previous reply to this request, and are not being included again.
  static const int alreadyReported = 208;

  /// The server has fulfilled a GET request for the resource, and the response is a representation of the result of one or more instance-manipulations applied to the current instance.
  static const int imUsed = 226;

  /// Indicates multiple options for the resource from which the client may choose (via agent-driven content negotiation).
  static const int multipleChoices = 300;

  /// This and all future requests should be directed to the given URI.
  static const int movedPermanently = 301;

  /// The resource was found at a different location, but the client should use the original URI.
  static const int found = 302;

  /// Common alias for the HTTP 302 status code. The requested resource resides temporarily under a different URI.
  static const int movedTemporarily = 302; 

  /// The response to the request can be found under another URI using a GET method.
  static const int seeOther = 303;

  /// The resource has not been modified since the last request.
  static const int notModified = 304;

  /// The requested resource is available only through a proxy, the address for which is provided in the response.
  static const int useProxy = 305;

  /// The request should be repeated with another URI; however, future requests should still use the original URI.
  static const int temporaryRedirect = 307;

  /// The request, and all future requests, should be repeated using another URI.
  static const int permanentRedirect = 308;

  /// The request could not be understood by the server due to malformed syntax.
  static const int badRequest = 400;

  /// The request requires user authentication.
  static const int unauthorized = 401;

  /// The client must first authenticate itself with the proxy.
  static const int paymentRequired = 402;

  /// The server understood the request, but is refusing to fulfill it.
  static const int forbidden = 403;

  /// The server has not found anything matching the request URI.
  static const int notFound = 404;

  /// The method specified in the request is not allowed for the resource identified by the request URI.
  static const int methodNotAllowed = 405;

  /// The resource identified by the request is only capable of generating content not acceptable according to the Accept headers sent in the request.
  static const int notAcceptable = 406;

  /// The client must first authenticate itself with the proxy.
  static const int proxyAuthenticationRequired = 407;

  /// The client did not produce a request within the time that the server was prepared to wait.
  static const int requestTimeout = 408;

  /// The request could not be completed due to a conflict with the current state of the resource.
  static const int conflict = 409;

  /// The requested resource is no longer available at the server and no forwarding address is known.
  static const int gone = 410;

  /// The server refuses to accept the request without a defined Content-Length.
  static const int lengthRequired = 411;

  /// The precondition given in one or more of the request-header fields evaluated to false when it was tested on the server.
  static const int preconditionFailed = 412;

  /// The server is refusing to process a request because the request entity is larger than the server is willing or able to process.
  static const int requestEntityTooLarge = 413;

  /// The server is refusing to service the request because the request URI is longer than the server is willing to interpret.
  static const int requestUriTooLong = 414;

  /// The server is refusing to service the request because the entity of the request is in a format not supported by the requested resource for the requested method.
  static const int unsupportedMediaType = 415;

  /// The requested resource is not capable of producing a response within the range specified by the request's Range header field.
  static const int requestedRangeNotSatisfiable = 416;

  /// The server cannot meet the requirements of the Expect request-header field.
  static const int expectationFailed = 417;

  /// The request was directed at a server that is not able to produce a response.
  static const int misdirectedRequest = 421;

  /// The request was well-formed but was unable to be followed due to semantic errors.
  static const int unprocessableEntity = 422;

  /// The resource that is being accessed is locked.
  static const int locked = 423;

  /// The request failed due to failure of a previous request.
  static const int failedDependency = 424;

  /// The client should switch to a different protocol, such as TLS/1.0.
  static const int upgradeRequired = 426;

  /// The origin server requires the request to be conditional.
  static const int preconditionRequired = 428;

  /// The user has sent too many requests in a given amount of time.
  static const int tooManyRequests = 429;

  /// The server is unwilling to process the request because its header fields are too large.
  static const int requestHeaderFieldsTooLarge = 431;

  /// The server has closed the connection without sending any response.
  static const int connectionClosedWithoutResponse = 444;

  /// The server is denying access to the resource as a consequence of a legal demand.
  static const int unavailableForLegalReasons = 451;

  /// The client has closed the request before the server could send a response.
  static const int clientClosedRequest = 499;

  /// The server encountered an unexpected condition that prevented it from fulfilling the request.
  static const int internalServerError = 500;

  /// The server does not support the functionality required to fulfill the request.
  static const int notImplemented = 501;

  /// The server, while acting as a gateway or proxy, received an invalid response from the upstream server.
  static const int badGateway = 502;

  /// The server is currently unable to handle the request due to a temporary overload or maintenance of the server.
  static const int serviceUnavailable = 503;

  /// The server, while acting as a gateway or proxy, did not receive a timely response from the upstream server.
  static const int gatewayTimeout = 504;

  /// The server does not support the HTTP protocol version used in the request.
  static const int httpVersionNotSupported = 505;

  /// The server has an internal configuration error: transparent content negotiation for the request results in a circular reference.
  static const int variantAlsoNegotiates = 506;

  /// The server is unable to store the representation needed to complete the request.
  static const int insufficientStorage = 507;

  /// The server detected an infinite loop while processing a request.
  static const int loopDetected = 508;

  /// Further extensions to the request are required for the server to fulfill it.
  static const int notExtended = 510;

  /// The client needs to authenticate to gain network access.
  static const int networkAuthenticationRequired = 511;

  /// The network connection was lost, resulting in a client-generated status code.
  static const int networkConnectTimeoutError = 599;
}
