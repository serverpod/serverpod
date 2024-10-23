BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_phone_auth" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "phoneNumber" text NOT NULL,
    "hash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_phone_auth_phoneNumber" ON "serverpod_phone_auth" USING btree ("phoneNumber");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_phone_create_request" (
    "id" bigserial PRIMARY KEY,
    "userName" text NOT NULL,
    "phoneNumber" text NOT NULL,
    "hash" text NOT NULL,
    "verificationCode" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_phone_auth_create_account_request_idx" ON "serverpod_phone_create_request" USING btree ("phoneNumber");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_phone_failed_sign_in" (
    "id" bigserial PRIMARY KEY,
    "phoneNumber" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_phone_failed_sign_in_phoneNumber_idx" ON "serverpod_phone_failed_sign_in" USING btree ("phoneNumber");
CREATE INDEX "serverpod_phone_failed_sign_in_time_idx" ON "serverpod_phone_failed_sign_in" USING btree ("time");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_phone_reset" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "verificationCode" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_phone_reset_verification_idx" ON "serverpod_phone_reset" USING btree ("verificationCode");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_user_info" ADD COLUMN "phoneNumber" text;
CREATE INDEX "serverpod_user_info_phoneNumber" ON "serverpod_user_info" USING btree ("phoneNumber");

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20241022113112710', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20241022113112710', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20241017134154083', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20241017134154083', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20240115074247714', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240115074247714', "timestamp" = now();


COMMIT;
