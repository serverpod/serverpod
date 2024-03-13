import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Web implementation to sign in with google.
/// Supply the clientId, defined in the Google developer console, should be the
/// same clientId as used in the server (serverClientId).
class GoogleSignInWebService {
  /// The clientId from google, should be the same as the serverClientId.
  final String clientId;

  /// The scopes to request from google.
  final List<String> scopes;

  /// The redirect uri to web page that will handle the authentication after signin.
  final String redirectUri;

  _SignInSession? _signInSession;

  /// Creates a new [GoogleSignInWebService].
  GoogleSignInWebService({
    required this.clientId,
    required this.scopes,
    required this.redirectUri,
  }) {
    // Handles callbacks from the window handling authentication.
    html.window.addEventListener('message', _eventListener);
  }

  void _eventListener(html.Event event) {
    _signInSession?.completeWithCode((event as html.MessageEvent).data);
  }

  /// Signs in with Google and returns the server auth code.
  Future<String?> signIn() async {
    if (_signInSession != null) {
      return null;
    }

    // Builds the Google authentication uri.
    // See: https://developers.google.com/identity/protocols/oauth2/web-server
    var authorizationUri = Uri(
      scheme: 'https',
      host: 'accounts.google.com',
      path: '/o/oauth2/v2/auth',
      queryParameters: {
        'scope': scopes.join(' '),
        'response_type': 'code',
        'redirect_uri': redirectUri,
        'client_id': clientId,
        'access_type': 'offline',
        'prompt': 'select_account consent',
      },
    );

    // Creates a sign-in session, opens the authentication window and signs and
    // waits for a callback from the opened page.
    _signInSession = _SignInSession(authorizationUri.toString());
    var code = await _signInSession!.codeCompleter.future;
    _signInSession = null;
    return code;
  }
}

class _SignInSession {
  final codeCompleter = Completer<String?>();
  late final html.WindowBase _window;
  late final Timer _timer;

  bool get isClosed => codeCompleter.isCompleted;

  _SignInSession(String authorizationUri) {
    // Opens the Google authentication url in a new window. When the
    // authentication is complete on the client side the window is redirected to.
    // This page will then make a callback into Flutter with the retrieved
    // server authentication code.
    _window = html.window.open(
      authorizationUri,
      '_blank',
      'location=yes,width=550,height=600',
    );

    // Monitors the window, if it's closed without signing in, make the
    // completer return null.
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_window.closed == true) {
        if (!isClosed) {
          codeCompleter.complete(null);
        }
        _timer.cancel();
      }
    });
  }

  // Called when we recieve the code from open window.
  void completeWithCode(String code) {
    if (!isClosed) {
      codeCompleter.complete(code);
    }
  }
}
