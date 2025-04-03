# Serverpod Authentication 2.0

The modules in this folder contain the next generation of Serverpod authentication modules.

Instead of one big module including all authentication and user profile options out of the box, this takes a highly modular approach.

The core `auth` module just offers an `AuthenticationUser` that serves as an anchor for all authentication mechanisms to hook into. Furthermore this allows for "user profiles" to be attached to this user. Depending on the applications need, this could be a 1:1 relation, or 1:many for example to support different profiles per tenant / project for the same user.

This is published under a new name, because it can not be a drop-in replacement for the existing `serverpod_auth` (due to new and stricter database schemas and the need to offer protocol-level backwards compatibility during the migration for existing projects).
But we offer a smooth upgrade path by means of the `serverpod_auth_migration` package, which can be used to gradually migrate existing users to the new system.

For new Serverpod projects `serverpod_auth2`, `serverpod_auth_session`, `serverpod_auth_email`, and `serverpod_auth_profile` will be included in the default template to offer a quick start just like today.  
Existing project could use the following upgrade path:
- Add packages for the desired session handling and authentication methods (e.g. `serverpod_auth_session` and `serverpod_auth_email`)
- Add and configure `serverpod_auth_migration` to create a smooth upgrade path for existing users and session
- Update client application to use the new endpoints
- Eventually remove the legacy `serverpod_auth` module once all clients have been updated to use the new endpoints and all user-data has been migrated

## Modules

`serverpod_auth2`: Core anchor point offering a user ID to add authentication methods and optional user profiles to

`serverpod_auth_session`: Database-backed session implementation  
`serverpod_auth_jwt`: JWT token based session implementation, using access and refresh tokens

`serverpod_auth_email`: Full-service email account endpoint implementation where users can register, login, change password, etc.  
`serverpod_auth_email_account`: Low-level package to handle only the email authentication. This would not create sessions or users itself. Instead the goal is to server as a building block to build custom authentication endpoints

(For other authentication methods like Apple, Firebase, Google a similar approach would be implemented across 2 modules.)

`serverpod_auth_migration`: Migration tools to import data from the legacy `serverpod_auth` into the new modules

`serverpod_auth_profile`: User profile similar to the current `UserInfo` class. Also showcases how developers might build their own custom "user profile" classes

## Dependencies

The modular approach, of course, leads to projects having to take on more direct dependencies on auth packages, picking exactly what they want to use.  
Alternatives would either fewer bigger packages, or a wrapper package like `serverpod_auth2_full`. The former approach has the drawback that now many potentially unused parts are visible to the developer (database tables, classes in autocomplete (with potential conflicts for common names), etc.). The latter offers a lean quick-start (especially if it or a similar package also configures the default migration), but migrating off of it becomes harder, as the developer would have to replace that wrapper package with the 3-4 explicit modules they need to build their own business logic. Though maybe we could remove the complexity from going to "wrapper package" to a starting point for one's own implementation by implementing something like [create-react-app](https://create-react-app.dev/docs/getting-started/). This added a single dependency to a project with all modules and default configurations applied, but when a custom configuration is needed it would allow one to [`eject`](https://create-react-app.dev/docs/available-scripts#npm-run-eject) and get all the dependencies and configuration under the projects control. Such a tool could even be minimally adaptive and only add support for authorization methods actually used in the project (which would be easily identifiable by their configuration class' name).

Given the current structure, the dependencies would look like this:
- Legacy project
  - depends on: `serverpod_auth`
  - imports: `serverpod_auth` in `main.dart`
    - usually "`as auth`" to avoid name clashes on `Protocol` and `Endpoints` classes
    - to set the `Serverpod` `authenticationHandler` and modify the global `AuthConfig`
- Project in progress of upgrading from legacy auth
  - depends on: `serverpod_auth_compatibility`, `serverpod_auth2_session`, `serverpod_auth_profile` (if desired), `serverpod_auth_email` (and whatever other new auth methods should be supported)
  - imports (in `main.dart`):
    - `serverpod_auth_compatibility` and `serverpod_auth2_session` to use the `authenticationHandler` from `auth2` with the migration support from the compatibility package
    - `serverpod_auth_email` to set the e-mail specific configuration (most of which would forward to / be aligned with the underlying `serverpod_auth_email_acount` package's configuration)
- New project created with the template
  - depends on: `serverpod_auth_email`, `serverpod_auth2_session`, and optionally on `serverpod_auth_profile`
    - The session package is already a dependency of the email endpoints, but since we need to pick it's auth handler in `main` we have to explicitly depend on it to avoid lint warnings (or re-export that function from the `*auth_email` package for convenience, as that package is tied to the DB-backed session anyway (for session creation, unless we make that configurable))
    - If the `auth_profile` should be included with new packages, we would probably need to also bake that into `auth_email`, so a profile is created for every user (but would the registration then blow up with user-related parameters, or should those be handled separately?)
  - imports (in `main.dart`):
      - `serverpod_auth2_session` to set the `authenticationHandler`
      - `serverpod_auth_email` to set the e-mail specific configuration

## Links

- [Miro board](https://miro.com/app/board/uXjVILtMmz8=/?moveToWidget=3458764623448047336&cot=14)