BEGIN;

--
-- ACTION ALTER TABLE
--
DROP INDEX "serverpod_auth_idp_passwordless_login_request_handle";
CREATE UNIQUE INDEX "serverpod_auth_idp_passwordless_login_request_handle" ON "serverpod_auth_idp_passwordless_login_request" USING btree ("handle", "handleType");

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260429193109306', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260429193109306', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260324085808546', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260324085808546', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260324085844499', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260324085844499', "timestamp" = now();


COMMIT;
