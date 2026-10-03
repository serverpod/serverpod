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
CREATE TABLE "serverpod_auth_core_account_link_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "authId" text NOT NULL,
    "linkedAuthUserId" uuid,
    "linkedMethod" text,
    "linkedAccountWasCreated" boolean,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_core_account_link_request_auth_user_id" ON "serverpod_auth_core_account_link_request" USING btree ("authUserId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_core_account_link_request"
    ADD CONSTRAINT "serverpod_auth_core_account_link_request_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('auth', '20261003003437087', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261003003437087', "timestamp" = now();

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
    VALUES ('serverpod_auth_idp', '20261003003231437', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261003003231437', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20261003003218065', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261003003218065', "timestamp" = now();


COMMIT;
