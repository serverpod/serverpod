# Showcase of "Authentication 2.0" APIs

Sequence diagrams & overviews are at https://miro.com/app/board/uXjVILtMmz8=/

## TODOs

- Handle different types of user ID (`int` or `UUID`)
  - Currently all showcases use `int`, but we'd have to somehow support `UUID` there as well
- Detailed behavior of "custom user info" still TBD
- Find a pattern such that missing configurations can err early during server start-up, not later upon usage
- Password reset / password change flows in the example / default endpoints
  - Might become especially interesting for 2FA, where the question is when to check the second factor
- Document how multi-tenancy system could be built atop of this

# Implementation Plan

1. Update client & server to get / resolve session key from helper
2. Default to the old behavior, even if that means that we can not drop the session table yet
3. Migrate authentication repositories, keep their old endpoints
4. Create new authentication methods like SMS and pass key
5. Create sample endpoints like email with verification, email with 2FA etc.
6. Breaking changes
  - move default session handler into package, show it can be used if user wants to continue with this (and also default template should keep using that)
  - remove default authentication endpoints, so they don't get mounted by default
    - expose the legacy ones in a package, showing how to use them without breaking backwards compatibility, but updating the template & docs to use the new ones

## Open Questions

- Should we have any relation between authentication mechanisms and sessions?
  - Currently there is only a connection (foreign key), by convention, between any active authentication method and a user, such that they get cleaned up properly should the user get deactivated.
  - A relation between authentication method and session could be useful to only invalidate certain ones, else we have to disable all of a user's sessions on e.g. an email password change.
- Should the user's `blocked` flag be checked in the `SessionRepository` or authentication method implementation (or better both)? For a `blocked` user it wouldn't make sense to send e.g. a 2FA token. On the other hand it'd be nice to only even expose the user ID at the end of a successful authentication (in each authentication method implementation), so that a higher-level endpoint method would not inadvertently create a session for a not fully verified / completed login.
  - When blocking one would need to make sure to call `revokeAllSessionsForUser`, or else any implementation would need to check the user in `resolveSessionToUserId` (where some implementations would want to avoid any database look-up).
- Should something like `additionalData` become a core concept? (mostly by convention, as it would only be useful if persisted by the authentication methods and/or session store)
  - 2025-03-31: No, let's keep it out of the low-level parts; developer can better create a typed version in their endpoint
- Does this have to be a breaking change, or couldn't we offer migration paths which would leave all active sessions and authentication methods intact?
- Can we still provide any useful hooks that don't obstruct the example implementations, while making them more amenable to changes? Or are the modules small and self-contained enough, that they'd be "take it or leave it"?
  - Like a simple addition like a post-registration / user creation welcome mail, which maybe should not require forking one or many authentication endpoints; or limiting the set of accepted email domains during registration
- How to best enable "cross authentication provider" account lookups for merge (which is probably a good feature to have), without taking dependencies on them all? Just documentation so the developer plugs them in?
- Should there be a way to "get" auth providers between endpoints? Or would we have to make do with accessing the tables at most (and then e.g. delete by ID or via an extension method, but without the ability to trigger more complex flows)?
- Do we need any per-request permission checks? E.g. scopes could be used, but it might be nicer if the "requirements" could already be built upfront, such that one can not get a user ID that is not fully validated.

## Notes

Some things which are not shown in the diagrams in code, but have been considered (and deemed solved/solvable).

- By convention (but since there is no base interface we can not otherwise enforce this), all authentication methods to not create users nor sessions. This gives the developers the freedom to keep using those even if they want to layer use-cases on top which are not backed in, like an invitation system.
- Our default endoint implementations are build in a way that the developer could copy them as a quick-start for their custom logic. They contain only minimal glue to the base "repositories" which hold all the state, where they would likely want to insert some additional checks or behavior in between the default one. This seems like a cleaner approach compared to offering detailed hooks, where you then can not read the code in a linear fashion anymore.
- The approach would allow a developer to layer an invite system on top of the authentication endpoints, giving them the full flexibility to opt for account creation before or after the invite was accepted. Or even add the ability to accept the invite from an existing account.
- The current `SessionRepository` would also support validating permission tokens with a third party, in case we have a SSO implementation where no own (local) session should be created.
- Some `SessionRepository` might opt not to implement certain methods of the interface, e.g. a pure token based approach without an invalidation cache could not support `revokeSession`, and instead needs to wait for the access token's TTL to expire and then prevent a new one being requested.
  - So it would need to make sure that the data change which caused `revokeSession` to be called, is also visible in its `rotateTokens` method (implemented outside of the interface).
