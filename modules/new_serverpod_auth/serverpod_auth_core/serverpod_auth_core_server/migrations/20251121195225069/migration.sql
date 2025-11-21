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
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251121195225069', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251121195225069', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251121195126312', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251121195126312', "timestamp" = now();


COMMIT;
