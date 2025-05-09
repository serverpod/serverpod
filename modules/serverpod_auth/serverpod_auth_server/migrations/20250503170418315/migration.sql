BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_anonymous_auth" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "hash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_anonymous_auth_userid" ON "serverpod_anonymous_auth" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_anonymous_failed_sign_in" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_anonymous_failed_sign_in_userid_idx" ON "serverpod_anonymous_failed_sign_in" USING btree ("userId");
CREATE INDEX "serverpod_anonymous_failed_sign_in_time_idx" ON "serverpod_anonymous_failed_sign_in" USING btree ("time");


--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20250503170418315', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250503170418315', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
