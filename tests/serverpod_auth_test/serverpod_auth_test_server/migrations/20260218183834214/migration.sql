BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "session_metadata" (
    "id" bigserial PRIMARY KEY,
    "serverSideSessionId" uuid NOT NULL,
    "deviceName" text NOT NULL,
    "ipAddress" text,
    "userAgent" text,
    "metadata" text
);

-- Indexes
CREATE UNIQUE INDEX "server_side_session_id_unique_idx" ON "session_metadata" USING btree ("serverSideSessionId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "token_metadata" (
    "id" bigserial PRIMARY KEY,
    "refreshTokenId" uuid NOT NULL,
    "deviceName" text NOT NULL,
    "ipAddress" text,
    "userAgent" text,
    "metadata" text
);

-- Indexes
CREATE UNIQUE INDEX "refresh_token_id_unique_idx" ON "token_metadata" USING btree ("refreshTokenId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "session_metadata"
    ADD CONSTRAINT "session_metadata_fk_0"
    FOREIGN KEY("serverSideSessionId")
    REFERENCES "serverpod_auth_core_session"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "token_metadata"
    ADD CONSTRAINT "token_metadata_fk_0"
    FOREIGN KEY("refreshTokenId")
    REFERENCES "serverpod_auth_core_jwt_refresh_token"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_auth_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_test', '20260218183834214', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260218183834214', "timestamp" = now();

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
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

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
