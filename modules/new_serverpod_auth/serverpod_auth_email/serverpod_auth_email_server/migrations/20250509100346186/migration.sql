BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_email_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_email_account_email" ON "serverpod_auth_email_account" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_email_account_failed_login_attempt" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "attemptedAt" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_auth_email_account_failed_login_attempt_email" ON "serverpod_auth_email_account_failed_login_attempt" USING btree ("email");
CREATE INDEX "serverpod_auth_email_account_failed_login_attempt_attempted_at" ON "serverpod_auth_email_account_failed_login_attempt" USING btree ("attemptedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_email_account_password_reset_attempt" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "attemptedAt" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_auth_email_account_password_reset_attempt_email" ON "serverpod_auth_email_account_password_reset_attempt" USING btree ("email");
CREATE INDEX "serverpod_auth_email_account_password_reset_attempt_ip_address" ON "serverpod_auth_email_account_password_reset_attempt" USING btree ("ipAddress");
CREATE INDEX "serverpod_auth_email_account_password_reset_attempt_at" ON "serverpod_auth_email_account_password_reset_attempt" USING btree ("attemptedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_email_account_password_reset_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "authenticationId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "verificationCode" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_email_account_password_reset_request_code" ON "serverpod_auth_email_account_password_reset_request" USING btree ("verificationCode");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_email_account_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "created" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL,
    "verificationCode" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_email_account_request_email" ON "serverpod_auth_email_account_request" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_profile_user_profile" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "authUserId" uuid NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "created" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "imageId" uuid
);

-- Indexes
CREATE INDEX "serverpod_auth_profile_user_profile_email" ON "serverpod_auth_profile_user_profile" USING btree ("email");
CREATE UNIQUE INDEX "serverpod_auth_profile_user_profile_email_auth_user_id" ON "serverpod_auth_profile_user_profile" USING btree ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_profile_user_profile_image" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "authUserId" uuid NOT NULL,
    "version" bigint NOT NULL,
    "url" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_auth_profile_user_profile_image_auth_user_id_version" ON "serverpod_auth_profile_user_profile_image" USING btree ("authUserId", "version");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_session" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "scopeNames" json NOT NULL,
    "sessionKeyHash" text NOT NULL,
    "method" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_user" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "created" timestamp without time zone NOT NULL,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_email_account"
    ADD CONSTRAINT "serverpod_auth_email_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_email_account_password_reset_request_fk_0"
    FOREIGN KEY("authenticationId")
    REFERENCES "serverpod_auth_email_account"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_profile_user_profile"
    ADD CONSTRAINT "serverpod_auth_profile_user_profile_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_profile_user_profile"
    ADD CONSTRAINT "serverpod_auth_profile_user_profile_fk_1"
    FOREIGN KEY("imageId")
    REFERENCES "serverpod_auth_profile_user_profile_image"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_profile_user_profile_image"
    ADD CONSTRAINT "serverpod_auth_profile_user_profile_image_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_session"
    ADD CONSTRAINT "serverpod_auth_session_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_auth_email
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_email', '20250509100346186', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250509100346186', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_email_account
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_email_account', '20250507154721031', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250507154721031', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_profile
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_profile', '20250507124705783', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250507124705783', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_session
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_session', '20250507151311162', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250507151311162', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_user
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_user', '20250506070330492', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250506070330492', "timestamp" = now();


COMMIT;
