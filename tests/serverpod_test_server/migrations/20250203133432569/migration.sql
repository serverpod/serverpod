BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "types_map" (
    "id" bigserial PRIMARY KEY,
    "anIntKey" json,
    "aBoolKey" json,
    "aDoubleKey" json,
    "aDateTimeKey" json,
    "aStringKey" json,
    "aByteDataKey" json,
    "aDurationKey" json,
    "aUuidKey" json,
    "anEnumKey" json,
    "aStringifiedEnumKey" json,
    "anObjectKey" json,
    "aMapKey" json,
    "aListKey" json,
    "anIntValue" json,
    "aBoolValue" json,
    "aDoubleValue" json,
    "aDateTimeValue" json,
    "aStringValue" json,
    "aByteDataValue" json,
    "aDurationValue" json,
    "aUuidValue" json,
    "anEnumValue" json,
    "aStringifiedEnumValue" json,
    "anObjectValue" json,
    "aMapValue" json,
    "aListValue" json
);


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20250203133432569', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250203133432569', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();

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
    VALUES ('serverpod_test_module', '20241219152628926', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20241219152628926', "timestamp" = now();


COMMIT;
