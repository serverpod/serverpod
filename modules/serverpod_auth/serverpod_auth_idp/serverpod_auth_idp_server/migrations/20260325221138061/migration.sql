BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_generic_passwordless_login_request" DROP CONSTRAINT "serverpod_auth_idp_generic_passwordless_login_request_fk_1";
ALTER TABLE "serverpod_auth_idp_generic_passwordless_login_request" DROP COLUMN "loginChallengeId";

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260325221138061', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260325221138061', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
