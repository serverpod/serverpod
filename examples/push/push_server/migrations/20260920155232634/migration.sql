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
CREATE TABLE "serverpod_push_delivery" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "notificationId" uuid NOT NULL,
    "deviceId" uuid NOT NULL,
    "provider" text NOT NULL,
    "status" text NOT NULL,
    "attempts" bigint NOT NULL DEFAULT 0,
    "claimCount" bigint NOT NULL DEFAULT 0,
    "backoffExponent" bigint NOT NULL DEFAULT 0,
    "expiresAt" timestamp without time zone,
    "nextAttemptAt" timestamp without time zone NOT NULL,
    "firstAttemptAt" timestamp without time zone,
    "lastAttemptAt" timestamp without time zone,
    "lastOutcome" text,
    "lastErrorCode" text,
    "lastErrorMessage" text,
    "providerMessageId" text,
    "claimedBy" text,
    "claimedAt" timestamp without time zone,
    "receivedAt" timestamp without time zone,
    "openedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_push_delivery_claim_idx" ON "serverpod_push_delivery" USING btree ("provider", "status", "nextAttemptAt");
CREATE INDEX "serverpod_push_delivery_reaper_idx" ON "serverpod_push_delivery" USING btree ("status", "claimedAt");
CREATE INDEX "serverpod_push_delivery_retention_idx" ON "serverpod_push_delivery" USING btree ("status", "createdAt");
CREATE UNIQUE INDEX "serverpod_push_delivery_unique_idx" ON "serverpod_push_delivery" USING btree ("notificationId", "deviceId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_push_device" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "provider" text NOT NULL,
    "credential" text NOT NULL,
    "identityHash" text NOT NULL,
    "platform" text NOT NULL,
    "userIdentifier" text,
    "installationId" text,
    "locale" text,
    "appVersion" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "disabledAt" timestamp without time zone,
    "disabledReason" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_push_device_identity_idx" ON "serverpod_push_device" USING btree ("provider", "identityHash");
CREATE UNIQUE INDEX "serverpod_push_device_installation_idx" ON "serverpod_push_device" USING btree ("provider", "installationId");
CREATE INDEX "serverpod_push_device_user_idx" ON "serverpod_push_device" USING btree ("userIdentifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_push_notification" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "message" json NOT NULL,
    "schemaVersion" bigint NOT NULL DEFAULT 1,
    "dedupeKey" text,
    "dedupeExpiresAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_push_notification_dedupe_idx" ON "serverpod_push_notification" USING btree ("dedupeKey");
CREATE INDEX "serverpod_push_notification_retention_idx" ON "serverpod_push_notification" USING btree ("dedupeExpiresAt");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_push_delivery"
    ADD CONSTRAINT "serverpod_push_delivery_fk_0"
    FOREIGN KEY("notificationId")
    REFERENCES "serverpod_push_notification"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_push_delivery"
    ADD CONSTRAINT "serverpod_push_delivery_fk_1"
    FOREIGN KEY("deviceId")
    REFERENCES "serverpod_push_device"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR push
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('push', '20260920155232634', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260920155232634', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_push_store
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_push_store', '20260920143543296', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260920143543296', "timestamp" = now();


COMMIT;
