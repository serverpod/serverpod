import 'package:serverpod/serverpod.dart';

///
class GoogleSignInRedirectPageWidget extends AbstractWidget {

  @override
  String toString() {
    return '''<html>

<head>
  <script>
    function findParam(name) {
      let result = null;
      location.search
        .substr(1)
        .split("&")
        .forEach(function (item) {
          const tmp = item.split("=");
          if (tmp[0] === name) result = decodeURIComponent(tmp[1]);
        });
      return result;
    }

    function returnToWebClient() {
      const code = findParam('code');
      window.opener.postMessage(code, '*');
      window.close();
    }

    returnToWebClient();
  </script>
</head>

<body>
</body>

</html>''';
  }
}
