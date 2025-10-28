BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "serverpod_auth_idp_email_account_password_reset" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_email_account_password_reset_complete" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "attemptedAt" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL,
    "passwordResetRequestId" uuid NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_auth_idp_email_account_password_reset_ip" ON "serverpod_auth_idp_email_account_password_reset_complete" USING btree ("ipAddress");
CREATE INDEX "serverpod_auth_idp_email_account_password_reset_at" ON "serverpod_auth_idp_email_account_password_reset_complete" USING btree ("attemptedAt");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_complete"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_complete_fk_0"
    FOREIGN KEY("passwordResetRequestId")
    REFERENCES "serverpod_auth_idp_email_account_password_reset_request"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_new_auth_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_new_auth_test', '20251026201612005', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251026201612005', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20250825102336032-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102336032-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_bridge
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_bridge', '20251026201513219', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251026201513219', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20250825102357155-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102357155-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251026095951842', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251026095951842', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_migration
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_migration', '20251026201537686', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251026201537686', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20250825102351908-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102351908-v3-0-0', "timestamp" = now();


COMMIT;
