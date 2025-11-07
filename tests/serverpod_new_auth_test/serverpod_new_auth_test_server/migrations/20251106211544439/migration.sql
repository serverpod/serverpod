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
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_bridge_email_password" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_bridge_external_user_id" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_core_profile" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_core_profile_image" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_core_session" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_core_user" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_apple_account" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_email_account" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_email_account_failed_login_attempt" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_email_account_password_reset_complete" DROP CONSTRAINT "serverpod_auth_idp_email_account_password_reset_complete_fk_0";
ALTER TABLE "serverpod_auth_idp_email_account_password_reset_complete" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_email_account_password_reset_request" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_email_account_pw_reset_request" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_email_account_request" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_email_account_request_completion" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_google_account" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_passkey_account" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_passkey_challenge" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_secret_challenge" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();

--
-- MIGRATION VERSION FOR serverpod_new_auth_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_new_auth_test', '20251106211544439', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251106211544439', "timestamp" = now();

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
    VALUES ('serverpod_auth_bridge', '20251106211509125', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251106211509125', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251106211458056', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251106211458056', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251106211503768', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251106211503768', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_migration
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_migration', '20251106211514954', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251106211514954', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20250825102351908-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102351908-v3-0-0', "timestamp" = now();


COMMIT;
