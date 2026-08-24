BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_cloud_storage" ADD COLUMN "contentType" text;
ALTER TABLE "serverpod_cloud_storage" ADD COLUMN "cacheControl" text;
ALTER TABLE "serverpod_cloud_storage" ADD COLUMN "contentDisposition" text;
ALTER TABLE "serverpod_cloud_storage" ADD COLUMN "contentEncoding" text;
ALTER TABLE "serverpod_cloud_storage" ADD COLUMN "customMetadata" text;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_cloud_storage_direct_download" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL,
    "downloadFileName" text,
    "contentType" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_download_auth_key" ON "serverpod_cloud_storage_direct_download" USING btree ("authKey");
CREATE INDEX "serverpod_cloud_storage_direct_download_expiration" ON "serverpod_cloud_storage_direct_download" USING btree ("expiration");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_cloud_storage_direct_upload" ADD COLUMN "maxFileSize" bigint NOT NULL DEFAULT 10485760;
ALTER TABLE "serverpod_cloud_storage_direct_upload" ADD COLUMN "contentLength" bigint;
ALTER TABLE "serverpod_cloud_storage_direct_upload" ADD COLUMN "preventOverwrite" boolean NOT NULL DEFAULT false;
ALTER TABLE "serverpod_cloud_storage_direct_upload" ADD COLUMN "contentType" text;
ALTER TABLE "serverpod_cloud_storage_direct_upload" ADD COLUMN "cacheControl" text;
ALTER TABLE "serverpod_cloud_storage_direct_upload" ADD COLUMN "contentDisposition" text;
ALTER TABLE "serverpod_cloud_storage_direct_upload" ADD COLUMN "contentEncoding" text;
ALTER TABLE "serverpod_cloud_storage_direct_upload" ADD COLUMN "customMetadata" text;

--
-- MIGRATION VERSION FOR auth_example
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('auth_example', '20260824174833886', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824174833886', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260821141637226-cloud-storage-metadata', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260821141637226-cloud-storage-metadata', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260417182239578', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417182239578', "timestamp" = now();


COMMIT;
