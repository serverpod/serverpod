# Serverpod Authentication 2.0

The modules in this folder contain the next generation of Serverpod authentication modules.

Instead of one big module including all authentication and user profile options out of the box, this take a highly modular approach.

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

`serverpod_auth_profile`: User profile similar to the current `UserInfo` class. Also showcases how developers might build there own custom "user profile" classes

## Links

- [Miro board](https://miro.com/app/board/uXjVILtMmz8=/?moveToWidget=3458764623448047336&cot=14)