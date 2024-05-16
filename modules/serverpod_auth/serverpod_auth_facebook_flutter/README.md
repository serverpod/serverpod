![Serverpod banner](https://github.com/serverpod/serverpod/raw/main/misc/images/github-header.webp)

# Serverpod
This package is a core part of Serverpod. For documentation, visit: [https://docs.serverpod.dev](https://docs.serverpod.dev).

## What is Serverpod?
Serverpod is an open-source, scalable app server, written in Dart for the Flutter community. Check it out!

[Serverpod.dev](https://serverpod.dev)

## `serverpod_auth_facebook_flutter`

This library is part of `serverpod_auth`, and provides Facebook login to Serverpod apps, via `flutter_facebook_auth`.

For Facebook login to work, you first need to set up your Android/iOS/Web client as specified in the []`flutter_facebook_auth` documentation](https://facebook.meedu.app/docs/5.x.x/web).

You also need to create a with the Facebook app id and app secret, at the path `config/facebook_app_secret.json` in your Serverpod server (ensure it is not committed to version control by adding it to `.gitignore` and `.pubignore`):

```json
{
    "app_id": "<your Facebook app id>",
    "app_secret": "<your Facebook app secret>"
}
```

These values can be obtained from the Facebook app developer console.

You will also need to configure your Facebook app in the developer console to give permission for the app to fetch the following information: email, first_name, name, profile_pic. (Otherwise login will fail.)

You can log into Facebook in your Serverpod app's Flutter frontend using `SignInWithFacebookButton`, or you can directly call the `signInWithFacebook` method.

### Limitations

Currently only short-term access tokens are fetched on the client (valid for one hour). The server exchanges this short-term access token for a long-term access token (valid for 60 days), however there is no way to get the long-term access token from the Serverpod server currently (this could be added).

Additionally, in the current implementation, the server makes no attempt to refresh access tokens before they expire.

Consequently, the main usecase for `serverpod_auth_facebook_flutter` is currently for logging into a Serverpod server using Facebook credentials, but after login, it should not be assumed that the client's access token can be used for any other task, other than immediate queries right after login.
