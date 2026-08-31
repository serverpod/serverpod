# Server-rendered HTML

Reference for the [Serverpod Web Server](../SKILL.md) skill.

Extend `WidgetRoute` and return a `WebWidget` from `build()`. Returning `null` responds with 404:

```dart
class MyRoute extends WidgetRoute {
  @override
  Future<WebWidget?> build(Session session, Request request) async {
    final users = await User.db.find(session);
    if (users.isEmpty) return null; // 404
    return UserListWidget(users: users);
  }
}

class UserListWidget extends TemplateWidget {
  UserListWidget({required List<User> users}) : super(name: 'user_list') {
    values = {'users': users.map((u) => u.userName).join(', ')};
  }
}

pod.webServer.addRoute(MyRoute(), '/users');
```

Place Mustache templates in `web/templates/` (e.g. `web/templates/user_list.html`):

```html
<html><body><h1>Users</h1><p>{{users}}</p></body></html>
```

Other widgets: `ListWidget(children: [...])` concatenates widgets; `JsonWidget({'key': 'value'})` renders JSON; `RedirectWidget('/new/location')` redirects. All of them extend `WebWidget`.

Pass a `cacheBustingConfig` to the `WidgetRoute` to resolve `{{{@/path/to/asset}}}` patterns in the template to cache-busted paths:

```dart
class MyRoute extends WidgetRoute {
  MyRoute() : super(cacheBustingConfig: cacheBustingConfig);
  // ...
}
```

```html
<img src="{{{@/static/logo.png}}}">  <!-- → /static/logo@<hash>.png -->
```
