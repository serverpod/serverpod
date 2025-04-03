BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_session" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "created" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_session"
    ADD CONSTRAINT "serverpod_auth_session_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "auth_user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_auth_session
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_session', '20250403122301511', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250403122301511', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth2
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth2', '20250403112548936', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250403112548936', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
