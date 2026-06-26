BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "types" ADD COLUMN "aGeographyPoint" TEXT;
ALTER TABLE "types" ADD COLUMN "aGeographyLineString" TEXT;
ALTER TABLE "types" ADD COLUMN "aGeographyPolygon" TEXT;
ALTER TABLE "types" ADD COLUMN "aGeographyGeometryCollection" TEXT;

--
-- STORE COLUMN TYPES FOR MIGRATIONS
--
DROP TABLE IF EXISTS "serverpod_sqlite_schema";

CREATE TABLE "serverpod_sqlite_schema" (
    "table_name" TEXT NOT NULL,
    "column_name" TEXT NOT NULL,
    "column_type" TEXT NOT NULL,
    "column_vector_dimension" INTEGER,
    PRIMARY KEY ("table_name", "column_name")
);

INSERT INTO "serverpod_sqlite_schema" VALUES
    ('address_uuid', 'id', 'uuid', NULL),
    ('arena_uuid', 'id', 'uuid', NULL),
    ('bool_default', 'boolDefaultTrue', 'boolean', NULL),
    ('bool_default', 'boolDefaultFalse', 'boolean', NULL),
    ('bool_default', 'boolDefaultNullFalse', 'boolean', NULL),
    ('bool_default_mix', 'boolDefaultAndDefaultModel', 'boolean', NULL),
    ('bool_default_mix', 'boolDefaultAndDefaultPersist', 'boolean', NULL),
    ('bool_default_mix', 'boolDefaultModelAndDefaultPersist', 'boolean', NULL),
    ('bool_default_model', 'boolDefaultModelTrue', 'boolean', NULL),
    ('bool_default_model', 'boolDefaultModelFalse', 'boolean', NULL),
    ('bool_default_model', 'boolDefaultModelNullFalse', 'boolean', NULL),
    ('bool_default_persist', 'boolDefaultPersistTrue', 'boolean', NULL),
    ('bool_default_persist', 'boolDefaultPersistFalse', 'boolean', NULL),
    ('changed_id_type_self', 'id', 'uuid', NULL),
    ('changed_id_type_self', 'nextId', 'uuid', NULL),
    ('changed_id_type_self', 'parentId', 'uuid', NULL),
    ('citizen_int', 'companyId', 'uuid', NULL),
    ('citizen_int', 'oldCompanyId', 'uuid', NULL),
    ('comment_int', 'orderId', 'uuid', NULL),
    ('company_uuid', 'id', 'uuid', NULL),
    ('course_uuid', 'id', 'uuid', NULL),
    ('datetime_default', 'dateTimeDefaultNow', 'timestampWithoutTimeZone', NULL),
    ('datetime_default', 'dateTimeDefaultStr', 'timestampWithoutTimeZone', NULL),
    ('datetime_default', 'dateTimeDefaultStrNull', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_mix', 'dateTimeDefaultAndDefaultModel', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_mix', 'dateTimeDefaultAndDefaultPersist', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_mix', 'dateTimeDefaultModelAndDefaultPersist', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_model', 'dateTimeDefaultModelNow', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_model', 'dateTimeDefaultModelStr', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_model', 'dateTimeDefaultModelStrNull', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_persist', 'dateTimeDefaultPersistNow', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_persist', 'dateTimeDefaultPersistStr', 'timestampWithoutTimeZone', NULL),
    ('enrollment_int', 'studentId', 'uuid', NULL),
    ('enrollment_int', 'courseId', 'uuid', NULL),
    ('object_with_bit', 'bit', 'bit', 512),
    ('object_with_bit', 'bitNullable', 'bit', 512),
    ('object_with_bit', 'bitIndexedHnsw', 'bit', 512),
    ('object_with_bit', 'bitIndexedHnswWithParams', 'bit', 512),
    ('object_with_bit', 'bitIndexedIvfflat', 'bit', 512),
    ('object_with_bit', 'bitIndexedIvfflatWithParams', 'bit', 512),
    ('object_with_dynamic', 'payload', 'json', NULL),
    ('object_with_dynamic', 'jsonbPayload', 'jsonb', NULL),
    ('object_with_dynamic', 'payloadList', 'json', NULL),
    ('object_with_dynamic', 'payloadMap', 'json', NULL),
    ('object_with_dynamic', 'payloadSet', 'json', NULL),
    ('object_with_dynamic', 'payloadMapWithDynamicKeys', 'jsonb', NULL),
    ('object_with_enum', 'enumList', 'json', NULL),
    ('object_with_enum', 'nullableEnumList', 'json', NULL),
    ('object_with_enum', 'enumListList', 'json', NULL),
    ('object_with_enum_enhanced', 'byIndexList', 'json', NULL),
    ('object_with_enum_enhanced', 'byNameList', 'json', NULL),
    ('object_with_half_vector', 'halfVector', 'halfvec', 512),
    ('object_with_half_vector', 'halfVectorNullable', 'halfvec', 512),
    ('object_with_half_vector', 'halfVectorIndexedHnsw', 'halfvec', 512),
    ('object_with_half_vector', 'halfVectorIndexedHnswWithParams', 'halfvec', 512),
    ('object_with_half_vector', 'halfVectorIndexedIvfflat', 'halfvec', 512),
    ('object_with_half_vector', 'halfVectorIndexedIvfflatWithParams', 'halfvec', 512),
    ('object_with_jsonb', 'notJsonb', 'json', NULL),
    ('object_with_jsonb', 'jsonb', 'jsonb', NULL),
    ('object_with_jsonb', 'jsonbMap', 'jsonb', NULL),
    ('object_with_jsonb', 'jsonbObject', 'jsonb', NULL),
    ('object_with_jsonb', 'jsonbIndexed', 'jsonb', NULL),
    ('object_with_jsonb', 'jsonbIndexedGin', 'jsonb', NULL),
    ('object_with_jsonb', 'jsonbIndexedGinJsonbPath', 'jsonb', NULL),
    ('object_with_jsonb', 'jsonbIndexedImplicitGin', 'jsonb', NULL),
    ('object_with_jsonb', 'nullableJsonb', 'jsonb', NULL),
    ('object_with_jsonb_class_level', 'implicitJsonb', 'jsonb', NULL),
    ('object_with_jsonb_class_level', 'explicitJsonb', 'jsonb', NULL),
    ('object_with_jsonb_class_level', 'json', 'json', NULL),
    ('object_with_object', 'data', 'json', NULL),
    ('object_with_object', 'nullableData', 'json', NULL),
    ('object_with_object', 'dataList', 'json', NULL),
    ('object_with_object', 'nullableDataList', 'json', NULL),
    ('object_with_object', 'listWithNullableData', 'json', NULL),
    ('object_with_object', 'nullableListWithNullableData', 'json', NULL),
    ('object_with_object', 'nestedDataList', 'json', NULL),
    ('object_with_object', 'nestedDataListInMap', 'json', NULL),
    ('object_with_object', 'nestedDataMap', 'json', NULL),
    ('object_with_sparse_vector', 'sparseVector', 'sparsevec', 512),
    ('object_with_sparse_vector', 'sparseVectorNullable', 'sparsevec', 512),
    ('object_with_sparse_vector', 'sparseVectorIndexedHnsw', 'sparsevec', 512),
    ('object_with_sparse_vector', 'sparseVectorIndexedHnswWithParams', 'sparsevec', 512),
    ('object_with_uuid', 'uuid', 'uuid', NULL),
    ('object_with_uuid', 'uuidNullable', 'uuid', NULL),
    ('object_with_vector', 'vector', 'vector', 512),
    ('object_with_vector', 'vectorNullable', 'vector', 512),
    ('object_with_vector', 'vectorIndexedHnsw', 'vector', 512),
    ('object_with_vector', 'vectorIndexedHnswWithParams', 'vector', 512),
    ('object_with_vector', 'vectorIndexedIvfflat', 'vector', 512),
    ('object_with_vector', 'vectorIndexedIvfflatWithParams', 'vector', 512),
    ('order_uuid', 'id', 'uuid', NULL),
    ('player_uuid', 'id', 'uuid', NULL),
    ('server_only_changed_id_field_class', 'id', 'uuid', NULL),
    ('simple_date_time', 'dateTime', 'timestampWithoutTimeZone', NULL),
    ('student_uuid', 'id', 'uuid', NULL),
    ('team_int', 'arenaId', 'uuid', NULL),
    ('types', 'aBool', 'boolean', NULL),
    ('types', 'aDateTime', 'timestampWithoutTimeZone', NULL),
    ('types', 'aUuid', 'uuid', NULL),
    ('types', 'aVector', 'vector', 3),
    ('types', 'aHalfVector', 'halfvec', 3),
    ('types', 'aSparseVector', 'sparsevec', 3),
    ('types', 'aBit', 'bit', 3),
    ('types', 'aGeographyPoint', 'geography', NULL),
    ('types', 'aGeographyLineString', 'geographyLineString', NULL),
    ('types', 'aGeographyPolygon', 'geographyPolygon', NULL),
    ('types', 'aGeographyGeometryCollection', 'geographyGeometryCollection', NULL),
    ('types', 'aList', 'json', NULL),
    ('types', 'aMap', 'json', NULL),
    ('types', 'aSet', 'json', NULL),
    ('types', 'aRecord', 'json', NULL),
    ('uuid_default', 'uuidDefaultRandom', 'uuid', NULL),
    ('uuid_default', 'uuidDefaultRandomV7', 'uuid', NULL),
    ('uuid_default', 'uuidDefaultRandomNull', 'uuid', NULL),
    ('uuid_default', 'uuidDefaultStr', 'uuid', NULL),
    ('uuid_default', 'uuidDefaultStrNull', 'uuid', NULL),
    ('uuid_default_mix', 'uuidDefaultAndDefaultModel', 'uuid', NULL),
    ('uuid_default_mix', 'uuidDefaultAndDefaultPersist', 'uuid', NULL),
    ('uuid_default_mix', 'uuidDefaultModelAndDefaultPersist', 'uuid', NULL),
    ('uuid_default_model', 'uuidDefaultModelRandom', 'uuid', NULL),
    ('uuid_default_model', 'uuidDefaultModelRandomV7', 'uuid', NULL),
    ('uuid_default_model', 'uuidDefaultModelRandomNull', 'uuid', NULL),
    ('uuid_default_model', 'uuidDefaultModelStr', 'uuid', NULL),
    ('uuid_default_model', 'uuidDefaultModelStrNull', 'uuid', NULL),
    ('uuid_default_persist', 'uuidDefaultPersistRandom', 'uuid', NULL),
    ('uuid_default_persist', 'uuidDefaultPersistRandomV7', 'uuid', NULL),
    ('uuid_default_persist', 'uuidDefaultPersistStr', 'uuid', NULL),
    ('serverpod_cloud_storage', 'addedTime', 'timestampWithoutTimeZone', NULL),
    ('serverpod_cloud_storage', 'expiration', 'timestampWithoutTimeZone', NULL),
    ('serverpod_cloud_storage', 'verified', 'boolean', NULL),
    ('serverpod_cloud_storage_direct_upload', 'expiration', 'timestampWithoutTimeZone', NULL),
    ('serverpod_future_call', 'time', 'timestampWithoutTimeZone', NULL),
    ('serverpod_future_call', 'scheduling', 'json', NULL),
    ('serverpod_future_call_claim', 'lastHeartbeatTime', 'timestampWithoutTimeZone', NULL),
    ('serverpod_health_connection_info', 'timestamp', 'timestampWithoutTimeZone', NULL),
    ('serverpod_health_metric', 'timestamp', 'timestampWithoutTimeZone', NULL),
    ('serverpod_health_metric', 'isHealthy', 'boolean', NULL),
    ('serverpod_log', 'time', 'timestampWithoutTimeZone', NULL),
    ('serverpod_message_log', 'slow', 'boolean', NULL),
    ('serverpod_migrations', 'timestamp', 'timestampWithoutTimeZone', NULL),
    ('serverpod_query_log', 'slow', 'boolean', NULL),
    ('serverpod_runtime_settings', 'logSettings', 'json', NULL),
    ('serverpod_runtime_settings', 'logSettingsOverrides', 'json', NULL),
    ('serverpod_runtime_settings', 'logServiceCalls', 'boolean', NULL),
    ('serverpod_runtime_settings', 'logMalformedCalls', 'boolean', NULL),
    ('serverpod_session_log', 'time', 'timestampWithoutTimeZone', NULL),
    ('serverpod_session_log', 'slow', 'boolean', NULL),
    ('serverpod_session_log', 'isOpen', 'boolean', NULL),
    ('serverpod_session_log', 'touched', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_jwt_refresh_token', 'id', 'uuid', NULL),
    ('serverpod_auth_core_jwt_refresh_token', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_core_jwt_refresh_token', 'scopeNames', 'json', NULL),
    ('serverpod_auth_core_jwt_refresh_token', 'lastUpdatedAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_jwt_refresh_token', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_profile', 'id', 'uuid', NULL),
    ('serverpod_auth_core_profile', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_core_profile', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_profile', 'imageId', 'uuid', NULL),
    ('serverpod_auth_core_profile_image', 'id', 'uuid', NULL),
    ('serverpod_auth_core_profile_image', 'userProfileId', 'uuid', NULL),
    ('serverpod_auth_core_profile_image', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_session', 'id', 'uuid', NULL),
    ('serverpod_auth_core_session', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_core_session', 'scopeNames', 'json', NULL),
    ('serverpod_auth_core_session', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_session', 'lastUsedAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_session', 'expiresAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_user', 'id', 'uuid', NULL),
    ('serverpod_auth_core_user', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_core_user', 'scopeNames', 'json', NULL),
    ('serverpod_auth_core_user', 'blocked', 'boolean', NULL),
    ('serverpod_auth_idp_anonymous_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_anonymous_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_anonymous_account', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_apple_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_apple_account', 'refreshTokenRequestedWithBundleIdentifier', 'boolean', NULL),
    ('serverpod_auth_idp_apple_account', 'lastRefreshedAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_apple_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_apple_account', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_apple_account', 'isEmailVerified', 'boolean', NULL),
    ('serverpod_auth_idp_apple_account', 'isPrivateEmail', 'boolean', NULL),
    ('serverpod_auth_idp_email_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_email_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_email_account', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_email_account_password_reset_request', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_email_account_password_reset_request', 'emailAccountId', 'uuid', NULL),
    ('serverpod_auth_idp_email_account_password_reset_request', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_email_account_password_reset_request', 'challengeId', 'uuid', NULL),
    ('serverpod_auth_idp_email_account_password_reset_request', 'setPasswordChallengeId', 'uuid', NULL),
    ('serverpod_auth_idp_email_account_request', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_email_account_request', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_email_account_request', 'challengeId', 'uuid', NULL),
    ('serverpod_auth_idp_email_account_request', 'createAccountChallengeId', 'uuid', NULL),
    ('serverpod_auth_idp_facebook_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_facebook_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_facebook_account', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_firebase_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_firebase_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_firebase_account', 'created', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_github_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_github_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_github_account', 'created', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_google_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_google_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_google_account', 'created', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_microsoft_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_microsoft_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_microsoft_account', 'created', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_passkey_account', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_passkey_account', 'authUserId', 'uuid', NULL),
    ('serverpod_auth_idp_passkey_account', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_passkey_challenge', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_passkey_challenge', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_rate_limited_request_attempt', 'id', 'uuid', NULL),
    ('serverpod_auth_idp_rate_limited_request_attempt', 'attemptedAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_auth_idp_rate_limited_request_attempt', 'extraData', 'json', NULL),
    ('serverpod_auth_idp_secret_challenge', 'id', 'uuid', NULL);

--
-- MIGRATION VERSION FOR serverpod_test_sqlite
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_sqlite', '20260625141124530', (unixepoch('now', 'subsecond') * 1000))
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260625141124530', "timestamp" = (unixepoch('now', 'subsecond') * 1000);

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260416151914983-insights-perf', (unixepoch('now', 'subsecond') * 1000))
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260416151914983-insights-perf', "timestamp" = (unixepoch('now', 'subsecond') * 1000);

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260417182253191', (unixepoch('now', 'subsecond') * 1000))
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417182253191', "timestamp" = (unixepoch('now', 'subsecond') * 1000);

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260417182309198', (unixepoch('now', 'subsecond') * 1000))
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417182309198', "timestamp" = (unixepoch('now', 'subsecond') * 1000);


COMMIT;
