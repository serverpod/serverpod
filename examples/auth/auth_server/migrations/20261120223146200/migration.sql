BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "click" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "timestamp" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "click"
    ADD CONSTRAINT "click_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('auth', '20261120223146200', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261120223146200', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20261120215203362', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261120215203362', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20261003003218065', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261003003218065', "timestamp" = now();


COMMIT;
