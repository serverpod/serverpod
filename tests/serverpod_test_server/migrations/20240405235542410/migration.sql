BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "address" (
    "id" bigserial PRIMARY KEY,
    "street" text NOT NULL,
    "inhabitantId" bigint
);

-- Indexes
CREATE UNIQUE INDEX "inhabitant_index_idx" ON "address" USING btree ("inhabitantId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "arena" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "blocking" (
    "id" bigserial PRIMARY KEY,
    "blockedId" bigint NOT NULL,
    "blockedById" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "blocking_blocked_unique_idx" ON "blocking" USING btree ("blockedId", "blockedById");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "cat" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "motherId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "citizen" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "companyId" bigint NOT NULL,
    "oldCompanyId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "city" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "city_with_long_table_name_that_is_still_valid" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "comment" (
    "id" bigserial PRIMARY KEY,
    "description" text NOT NULL,
    "orderId" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "company" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "townId" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "course" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "customer" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "enrollment" (
    "id" bigserial PRIMARY KEY,
    "studentId" bigint NOT NULL,
    "courseId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "enrollment_index_idx" ON "enrollment" USING btree ("studentId", "courseId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "long_implicit_id_field" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "long_implicit_id_field_collection" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "max_field_name" (
    "id" bigserial PRIMARY KEY,
    "thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "member" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "multiple_max_field_name" (
    "id" bigserial PRIMARY KEY,
    "thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1" text NOT NULL,
    "thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2" text NOT NULL,
    "_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_field_scopes" (
    "id" bigserial PRIMARY KEY,
    "normal" text NOT NULL,
    "database" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_user" (
    "id" bigserial PRIMARY KEY,
    "name" text,
    "userInfoId" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_bytedata" (
    "id" bigserial PRIMARY KEY,
    "byteData" bytea NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_duration" (
    "id" bigserial PRIMARY KEY,
    "duration" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_enum" (
    "id" bigserial PRIMARY KEY,
    "testEnum" bigint NOT NULL,
    "nullableEnum" bigint,
    "enumList" json NOT NULL,
    "nullableEnumList" json NOT NULL,
    "enumListList" json NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_index" (
    "id" bigserial PRIMARY KEY,
    "indexed" bigint NOT NULL,
    "indexed2" bigint NOT NULL
);

-- Indexes
CREATE INDEX "object_with_index_test_index" ON "object_with_index" USING brin ("indexed", "indexed2");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_object" (
    "id" bigserial PRIMARY KEY,
    "data" json NOT NULL,
    "nullableData" json,
    "dataList" json NOT NULL,
    "nullableDataList" json,
    "listWithNullableData" json NOT NULL,
    "nullableListWithNullableData" json
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_parent" (
    "id" bigserial PRIMARY KEY,
    "other" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_self_parent" (
    "id" bigserial PRIMARY KEY,
    "other" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_uuid" (
    "id" bigserial PRIMARY KEY,
    "uuid" uuid NOT NULL,
    "uuidNullable" uuid
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "order" (
    "id" bigserial PRIMARY KEY,
    "description" text NOT NULL,
    "customerId" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "organization" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "cityId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "organization_with_long_table_name_that_is_still_valid" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "cityId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "parent_user" (
    "id" bigserial PRIMARY KEY,
    "name" text,
    "userInfoId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "person" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "organizationId" bigint,
    "_cityCitizensCityId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "person_with_long_table_name_that_is_still_valid" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "organizationId" bigint,
    "_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "player" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "teamId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "post" (
    "id" bigserial PRIMARY KEY,
    "content" text NOT NULL,
    "nextId" bigint
);

-- Indexes
CREATE UNIQUE INDEX "next_unique_idx" ON "post" USING btree ("nextId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "related_unique_data" (
    "id" bigserial PRIMARY KEY,
    "uniqueDataId" bigint NOT NULL,
    "number" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "relation_to_multiple_max_field_name" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scope_none_fields" (
    "id" bigserial PRIMARY KEY,
    "name" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "simple_data" (
    "id" bigserial PRIMARY KEY,
    "num" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "simple_date_time" (
    "id" bigserial PRIMARY KEY,
    "dateTime" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "student" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "team" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "arenaId" bigint
);

-- Indexes
CREATE UNIQUE INDEX "arena_index_idx" ON "team" USING btree ("arenaId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "town" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "mayorId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "types" (
    "id" bigserial PRIMARY KEY,
    "anInt" bigint,
    "aBool" boolean,
    "aDouble" double precision,
    "aDateTime" timestamp without time zone,
    "aString" text,
    "aByteData" bytea,
    "aDuration" bigint,
    "aUuid" uuid,
    "anEnum" bigint,
    "aStringifiedEnum" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "unique_data" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL,
    "email" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "email_index_idx" ON "unique_data" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_note" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_note_collection_with_a_long_name" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_note_collections" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_note_with_a_long_name" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_email_auth" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "email" text NOT NULL,
    "hash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_auth_email" ON "serverpod_email_auth" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_email_create_request" (
    "id" bigserial PRIMARY KEY,
    "userName" text NOT NULL,
    "email" text NOT NULL,
    "hash" text NOT NULL,
    "verificationCode" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_auth_create_account_request_idx" ON "serverpod_email_create_request" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_email_failed_sign_in" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_email_failed_sign_in_email_idx" ON "serverpod_email_failed_sign_in" USING btree ("email");
CREATE INDEX "serverpod_email_failed_sign_in_time_idx" ON "serverpod_email_failed_sign_in" USING btree ("time");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_email_reset" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "verificationCode" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_reset_verification_idx" ON "serverpod_email_reset" USING btree ("verificationCode");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_facebook_long_lived_token" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "fbProfileId" text NOT NULL,
    "token" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_facebook_long_lived_token_idx" ON "serverpod_facebook_long_lived_token" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_google_refresh_token" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "refreshToken" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_google_refresh_token_userId_idx" ON "serverpod_google_refresh_token" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_user_image" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "version" bigint NOT NULL,
    "url" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_user_image_user_id" ON "serverpod_user_image" USING btree ("userId", "version");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_user_info" (
    "id" bigserial PRIMARY KEY,
    "userIdentifier" text NOT NULL,
    "userName" text NOT NULL,
    "fullName" text,
    "email" text,
    "created" timestamp without time zone NOT NULL,
    "imageUrl" text,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_user_info_user_identifier" ON "serverpod_user_info" USING btree ("userIdentifier");
CREATE INDEX "serverpod_user_info_email" ON "serverpod_user_info" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_key" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "hash" text NOT NULL,
    "scopeNames" json NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_auth_key_userId_idx" ON "serverpod_auth_key" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "address"
    ADD CONSTRAINT "address_fk_0"
    FOREIGN KEY("inhabitantId")
    REFERENCES "citizen"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "blocking"
    ADD CONSTRAINT "blocking_fk_0"
    FOREIGN KEY("blockedId")
    REFERENCES "member"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "blocking"
    ADD CONSTRAINT "blocking_fk_1"
    FOREIGN KEY("blockedById")
    REFERENCES "member"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "cat"
    ADD CONSTRAINT "cat_fk_0"
    FOREIGN KEY("motherId")
    REFERENCES "cat"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "citizen"
    ADD CONSTRAINT "citizen_fk_0"
    FOREIGN KEY("companyId")
    REFERENCES "company"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "citizen"
    ADD CONSTRAINT "citizen_fk_1"
    FOREIGN KEY("oldCompanyId")
    REFERENCES "company"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "comment"
    ADD CONSTRAINT "comment_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "company"
    ADD CONSTRAINT "company_fk_0"
    FOREIGN KEY("townId")
    REFERENCES "town"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "enrollment"
    ADD CONSTRAINT "enrollment_fk_0"
    FOREIGN KEY("studentId")
    REFERENCES "student"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "enrollment"
    ADD CONSTRAINT "enrollment_fk_1"
    FOREIGN KEY("courseId")
    REFERENCES "course"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "long_implicit_id_field"
    ADD CONSTRAINT "long_implicit_id_field_fk_0"
    FOREIGN KEY("_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id")
    REFERENCES "long_implicit_id_field_collection"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "multiple_max_field_name"
    ADD CONSTRAINT "multiple_max_field_name_fk_0"
    FOREIGN KEY("_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId")
    REFERENCES "relation_to_multiple_max_field_name"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "object_user"
    ADD CONSTRAINT "object_user_fk_0"
    FOREIGN KEY("userInfoId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "object_with_parent"
    ADD CONSTRAINT "object_with_parent_fk_0"
    FOREIGN KEY("other")
    REFERENCES "object_field_scopes"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "object_with_self_parent"
    ADD CONSTRAINT "object_with_self_parent_fk_0"
    FOREIGN KEY("other")
    REFERENCES "object_with_self_parent"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "order"
    ADD CONSTRAINT "order_fk_0"
    FOREIGN KEY("customerId")
    REFERENCES "customer"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "organization"
    ADD CONSTRAINT "organization_fk_0"
    FOREIGN KEY("cityId")
    REFERENCES "city"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "organization_with_long_table_name_that_is_still_valid"
    ADD CONSTRAINT "organization_with_long_table_name_that_is_still_valid_fk_0"
    FOREIGN KEY("cityId")
    REFERENCES "city_with_long_table_name_that_is_still_valid"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "parent_user"
    ADD CONSTRAINT "parent_user_fk_0"
    FOREIGN KEY("userInfoId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "person"
    ADD CONSTRAINT "person_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "person"
    ADD CONSTRAINT "person_fk_1"
    FOREIGN KEY("_cityCitizensCityId")
    REFERENCES "city"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "person_with_long_table_name_that_is_still_valid"
    ADD CONSTRAINT "person_with_long_table_name_that_is_still_valid_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization_with_long_table_name_that_is_still_valid"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "person_with_long_table_name_that_is_still_valid"
    ADD CONSTRAINT "person_with_long_table_name_that_is_still_valid_fk_1"
    FOREIGN KEY("_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id")
    REFERENCES "city_with_long_table_name_that_is_still_valid"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "player"
    ADD CONSTRAINT "player_fk_0"
    FOREIGN KEY("teamId")
    REFERENCES "team"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "post"
    ADD CONSTRAINT "post_fk_0"
    FOREIGN KEY("nextId")
    REFERENCES "post"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "related_unique_data"
    ADD CONSTRAINT "related_unique_data_fk_0"
    FOREIGN KEY("uniqueDataId")
    REFERENCES "unique_data"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "team"
    ADD CONSTRAINT "team_fk_0"
    FOREIGN KEY("arenaId")
    REFERENCES "arena"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "town"
    ADD CONSTRAINT "town_fk_0"
    FOREIGN KEY("mayorId")
    REFERENCES "citizen"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "user_note"
    ADD CONSTRAINT "user_note_fk_0"
    FOREIGN KEY("_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId")
    REFERENCES "user_note_collections"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "user_note_with_a_long_name"
    ADD CONSTRAINT "user_note_with_a_long_name_fk_0"
    FOREIGN KEY("_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId")
    REFERENCES "user_note_collection_with_a_long_name"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20240405235542410', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240405235542410', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240405235514720', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240405235514720', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240405235505637', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240405235505637', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20240405235533022', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240405235533022', "timestamp" = now();


COMMIT;
