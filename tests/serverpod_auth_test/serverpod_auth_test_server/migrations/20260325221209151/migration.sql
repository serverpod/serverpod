BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_generic_passwordless_login_request" DROP CONSTRAINT "serverpod_auth_idp_generic_passwordless_login_request_fk_1";
ALTER TABLE "serverpod_auth_idp_generic_passwordless_login_request" DROP COLUMN "loginChallengeId";

--
-- MIGRATION VERSION FOR serverpod_auth_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_test', '20260325221209151', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260325221209151', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_bridge
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_bridge', '20260213194701269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194701269', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260325221138061', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260325221138061', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_migration
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_migration', '20260213194706631', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194706631', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260129181059877', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181059877', "timestamp" = now();


COMMIT;
