BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_sms_auth" (
    "id" serial PRIMARY KEY,
    "userId" integer NOT NULL,
    "phoneNumber" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_sms_auth_sms" ON "serverpod_sms_auth" USING btree ("phoneNumber");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_sms_failed_sign_in" (
    "id" serial PRIMARY KEY,
    "phoneNumber" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_sms_failed_sign_in_sms_idx" ON "serverpod_sms_failed_sign_in" USING btree ("phoneNumber");
CREATE INDEX "serverpod_sms_failed_sign_in_sms_time_idx" ON "serverpod_sms_failed_sign_in" USING btree ("time");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_user_info" ADD COLUMN "phoneNumber" text;
CREATE INDEX "serverpod_user_info_phone_number" ON "serverpod_user_info" USING btree ("phoneNumber");
--
-- ACTION CREATE FOREIGN KEY
--
--
-- ACTION CREATE FOREIGN KEY
--

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_auth', '20230915125542', 1, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20230915125542', "priority" = 1;


COMMIT;
