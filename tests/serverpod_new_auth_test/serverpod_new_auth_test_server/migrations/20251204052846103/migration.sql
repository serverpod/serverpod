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
-- ACTION DROP TABLE
--
DROP TABLE "serverpod_auth_idp_email_account_request_completion" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "serverpod_auth_idp_email_account_pw_reset_request" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "serverpod_auth_idp_email_account_password_reset_complete" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "serverpod_auth_idp_email_account_failed_login_attempt" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_rate_limited_request_attempt" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "domain" text NOT NULL,
    "source" text NOT NULL,
    "nonce" text NOT NULL,
    "ipAddress" text,
    "attemptedAt" timestamp without time zone NOT NULL,
    "extraData" json
);

-- Indexes
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_domain" ON "serverpod_auth_idp_rate_limited_request_attempt" USING btree ("domain");
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_source" ON "serverpod_auth_idp_rate_limited_request_attempt" USING btree ("source");
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_nonce" ON "serverpod_auth_idp_rate_limited_request_attempt" USING btree ("nonce");


--
-- MIGRATION VERSION FOR serverpod_new_auth_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_new_auth_test', '20251204052846103', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251204052846103', "timestamp" = now();

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
    VALUES ('serverpod_auth_bridge', '20251128113932588', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251128113932588', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251128113842674', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251128113842674', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251204015642995', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251204015642995', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_migration
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_migration', '20251128114152686', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251128114152686', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20250825102351908-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102351908-v3-0-0', "timestamp" = now();


COMMIT;
