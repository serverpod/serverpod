# Serverpod authentication module
The Serverpod auth module makes it easy to authenticate users using 3rd parties. Currently supported is Signing in with Google and Apple. Future versions of the authentication module will include more options. Using this module requires some setup with Google and Apple for things to work.

## Installing the module
General instructions for adding a module will go here.

## Setting up Sign in with Google
To set up Sign in with Google, you will need a Firebase and Google account for your organization.

1. Follow the instructions in the [google_sign_in](https://pub.dev/packages/google_sign_in) plug-in for iOS and Android.
   - For iOS, make sure that you obtain the `GoogleService-Info.plist` and add it to your Xcode project.
   - For Android, there are other setup steps you need to take.
2. In Google cloud, you need to do some additional setup.
   - To access the Firebase project in Google cloud the first time, you may need to copy the project identifier and place it directly in the Google cloud URL. Otherwise, you may not see the project on the list. E.g., https://console.cloud.google.com/apis/dashboard?project=PROJECT_ID
   - Activate the _People API_ on your project.
   - Set up the OAuth consent screen. You will need to add the `../auth/userinfo.email` and `../auth/userinfo.profile` scopes.
3. Finally, you need to set up the Google client secret so your server can authenticate the user with Google. In GCP's _APIs & Services_, select the Credentials tab. Download the _Web client (auto created by Google Service)_ under _OAuth 2.0 Client IDs_. Rename it to `google_client_secret.json` and place it in the `config` directory of your server.
