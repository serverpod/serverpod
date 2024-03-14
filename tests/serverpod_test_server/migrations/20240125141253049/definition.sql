BEGIN;

--
-- Class Address as table address
--
CREATE TABLE "address" (
    "id" serial PRIMARY KEY,
    "street" text NOT NULL,
    "inhabitantId" integer
);

-- Indexes
CREATE UNIQUE INDEX "inhabitant_index_idx" ON "address" USING btree ("inhabitantId");

--
-- Class Arena as table arena
--
CREATE TABLE "arena" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class Blocking as table blocking
--
CREATE TABLE "blocking" (
    "id" serial PRIMARY KEY,
    "blockedId" integer NOT NULL,
    "blockedById" integer NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "blocking_blocked_unique_idx" ON "blocking" USING btree ("blockedId", "blockedById");

--
-- Class Cat as table cat
--
CREATE TABLE "cat" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "motherId" integer
);

--
-- Class Citizen as table citizen
--
CREATE TABLE "citizen" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "companyId" integer NOT NULL,
    "oldCompanyId" integer
);

--
-- Class City as table city
--
CREATE TABLE "city" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class CityWithLongTableName as table city_with_long_table_name_that_is_still_valid
--
CREATE TABLE "city_with_long_table_name_that_is_still_valid" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class Comment as table comment
--
CREATE TABLE "comment" (
    "id" serial PRIMARY KEY,
    "description" text NOT NULL,
    "orderId" integer NOT NULL
);

--
-- Class Company as table company
--
CREATE TABLE "company" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "townId" integer NOT NULL
);

--
-- Class Course as table course
--
CREATE TABLE "course" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class Customer as table customer
--
CREATE TABLE "customer" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class Enrollment as table enrollment
--
CREATE TABLE "enrollment" (
    "id" serial PRIMARY KEY,
    "studentId" integer NOT NULL,
    "courseId" integer NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "enrollment_index_idx" ON "enrollment" USING btree ("studentId", "courseId");

--
-- Class LongImplicitIdField as table long_implicit_id_field
--
CREATE TABLE "long_implicit_id_field" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id" integer
);

--
-- Class LongImplicitIdFieldCollection as table long_implicit_id_field_collection
--
CREATE TABLE "long_implicit_id_field_collection" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class MaxFieldName as table max_field_name
--
CREATE TABLE "max_field_name" (
    "id" serial PRIMARY KEY,
    "thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo" text NOT NULL
);

--
-- Class Member as table member
--
CREATE TABLE "member" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class MultipleMaxFieldName as table multiple_max_field_name
--
CREATE TABLE "multiple_max_field_name" (
    "id" serial PRIMARY KEY,
    "thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1" text NOT NULL,
    "thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2" text NOT NULL,
    "_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId" integer
);

--
-- Class ObjectFieldScopes as table object_field_scopes
--
CREATE TABLE "object_field_scopes" (
    "id" serial PRIMARY KEY,
    "normal" text NOT NULL,
    "database" text
);

--
-- Class ObjectUser as table object_user
--
CREATE TABLE "object_user" (
    "id" serial PRIMARY KEY,
    "name" text,
    "userInfoId" integer NOT NULL
);

--
-- Class ObjectWithByteData as table object_with_bytedata
--
CREATE TABLE "object_with_bytedata" (
    "id" serial PRIMARY KEY,
    "byteData" bytea NOT NULL
);

--
-- Class ObjectWithDuration as table object_with_duration
--
CREATE TABLE "object_with_duration" (
    "id" serial PRIMARY KEY,
    "duration" bigint NOT NULL
);

--
-- Class ObjectWithEnum as table object_with_enum
--
CREATE TABLE "object_with_enum" (
    "id" serial PRIMARY KEY,
    "testEnum" integer NOT NULL,
    "nullableEnum" integer,
    "enumList" json NOT NULL,
    "nullableEnumList" json NOT NULL,
    "enumListList" json NOT NULL
);

--
-- Class ObjectWithIndex as table object_with_index
--
CREATE TABLE "object_with_index" (
    "id" serial PRIMARY KEY,
    "indexed" integer NOT NULL,
    "indexed2" integer NOT NULL
);

-- Indexes
CREATE INDEX "object_with_index_test_index" ON "object_with_index" USING brin ("indexed", "indexed2");

--
-- Class ObjectWithObject as table object_with_object
--
CREATE TABLE "object_with_object" (
    "id" serial PRIMARY KEY,
    "data" json NOT NULL,
    "nullableData" json,
    "dataList" json NOT NULL,
    "nullableDataList" json,
    "listWithNullableData" json NOT NULL,
    "nullableListWithNullableData" json
);

--
-- Class ObjectWithParent as table object_with_parent
--
CREATE TABLE "object_with_parent" (
    "id" serial PRIMARY KEY,
    "other" integer NOT NULL
);

--
-- Class ObjectWithSelfParent as table object_with_self_parent
--
CREATE TABLE "object_with_self_parent" (
    "id" serial PRIMARY KEY,
    "other" integer
);

--
-- Class ObjectWithUuid as table object_with_uuid
--
CREATE TABLE "object_with_uuid" (
    "id" serial PRIMARY KEY,
    "uuid" uuid NOT NULL,
    "uuidNullable" uuid
);

--
-- Class Order as table order
--
CREATE TABLE "order" (
    "id" serial PRIMARY KEY,
    "description" text NOT NULL,
    "customerId" integer NOT NULL
);

--
-- Class Organization as table organization
--
CREATE TABLE "organization" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "cityId" integer
);

--
-- Class OrganizationWithLongTableName as table organization_with_long_table_name_that_is_still_valid
--
CREATE TABLE "organization_with_long_table_name_that_is_still_valid" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "cityId" integer
);

--
-- Class ParentUser as table parent_user
--
CREATE TABLE "parent_user" (
    "id" serial PRIMARY KEY,
    "name" text,
    "userInfoId" integer
);

--
-- Class Person as table person
--
CREATE TABLE "person" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "organizationId" integer,
    "_cityCitizensCityId" integer
);

--
-- Class PersonWithLongTableName as table person_with_long_table_name_that_is_still_valid
--
CREATE TABLE "person_with_long_table_name_that_is_still_valid" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "organizationId" integer,
    "_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id" integer
);

--
-- Class Player as table player
--
CREATE TABLE "player" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "teamId" integer
);

--
-- Class Post as table post
--
CREATE TABLE "post" (
    "id" serial PRIMARY KEY,
    "content" text NOT NULL,
    "nextId" integer
);

-- Indexes
CREATE UNIQUE INDEX "next_unique_idx" ON "post" USING btree ("nextId");

--
-- Class RelatedUniqueData as table related_unique_data
--
CREATE TABLE "related_unique_data" (
    "id" serial PRIMARY KEY,
    "uniqueDataId" integer NOT NULL,
    "number" integer NOT NULL
);

--
-- Class RelationToMultipleMaxFieldName as table relation_to_multiple_max_field_name
--
CREATE TABLE "relation_to_multiple_max_field_name" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class ScopeNoneFields as table scope_none_fields
--
CREATE TABLE "scope_none_fields" (
    "id" serial PRIMARY KEY,
    "name" text
);

--
-- Class SimpleData as table simple_data
--
CREATE TABLE "simple_data" (
    "id" serial PRIMARY KEY,
    "num" integer NOT NULL
);

--
-- Class SimpleDateTime as table simple_date_time
--
CREATE TABLE "simple_date_time" (
    "id" serial PRIMARY KEY,
    "dateTime" timestamp without time zone NOT NULL
);

--
-- Class Student as table student
--
CREATE TABLE "student" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class Team as table team
--
CREATE TABLE "team" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "arenaId" integer
);

-- Indexes
CREATE UNIQUE INDEX "arena_index_idx" ON "team" USING btree ("arenaId");

--
-- Class Town as table town
--
CREATE TABLE "town" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "mayorId" integer
);

--
-- Class Types as table types
--
CREATE TABLE "types" (
    "id" serial PRIMARY KEY,
    "anInt" integer,
    "aBool" boolean,
    "aDouble" double precision,
    "aDateTime" timestamp without time zone,
    "aString" text,
    "aByteData" bytea,
    "aDuration" bigint,
    "aUuid" uuid,
    "anEnum" integer,
    "aStringifiedEnum" text
);

--
-- Class UniqueData as table unique_data
--
CREATE TABLE "unique_data" (
    "id" serial PRIMARY KEY,
    "number" integer NOT NULL,
    "email" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "email_index_idx" ON "unique_data" USING btree ("email");

--
-- Class UserNote as table user_note
--
CREATE TABLE "user_note" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId" integer
);

--
-- Class UserNoteCollectionWithALongName as table user_note_collection_with_a_long_name
--
CREATE TABLE "user_note_collection_with_a_long_name" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class UserNoteCollection as table user_note_collections
--
CREATE TABLE "user_note_collections" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class UserNoteWithALongName as table user_note_with_a_long_name
--
CREATE TABLE "user_note_with_a_long_name" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId" integer
);

--
-- Class EmailAuth as table serverpod_email_auth
--
CREATE TABLE "serverpod_email_auth" (
    "id" serial PRIMARY KEY,
    "userId" integer NOT NULL,
    "email" text NOT NULL,
    "hash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_auth_email" ON "serverpod_email_auth" USING btree ("email");

--
-- Class EmailCreateAccountRequest as table serverpod_email_create_request
--
CREATE TABLE "serverpod_email_create_request" (
    "id" serial PRIMARY KEY,
    "userName" text NOT NULL,
    "email" text NOT NULL,
    "hash" text NOT NULL,
    "verificationCode" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_auth_create_account_request_idx" ON "serverpod_email_create_request" USING btree ("email");

--
-- Class EmailFailedSignIn as table serverpod_email_failed_sign_in
--
CREATE TABLE "serverpod_email_failed_sign_in" (
    "id" serial PRIMARY KEY,
    "email" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_email_failed_sign_in_email_idx" ON "serverpod_email_failed_sign_in" USING btree ("email");
CREATE INDEX "serverpod_email_failed_sign_in_time_idx" ON "serverpod_email_failed_sign_in" USING btree ("time");

--
-- Class EmailReset as table serverpod_email_reset
--
CREATE TABLE "serverpod_email_reset" (
    "id" serial PRIMARY KEY,
    "userId" integer NOT NULL,
    "verificationCode" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_reset_verification_idx" ON "serverpod_email_reset" USING btree ("verificationCode");

--
-- Class GoogleRefreshToken as table serverpod_google_refresh_token
--
CREATE TABLE "serverpod_google_refresh_token" (
    "id" serial PRIMARY KEY,
    "userId" integer NOT NULL,
    "refreshToken" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_google_refresh_token_userId_idx" ON "serverpod_google_refresh_token" USING btree ("userId");

--
-- Class UserImage as table serverpod_user_image
--
CREATE TABLE "serverpod_user_image" (
    "id" serial PRIMARY KEY,
    "userId" integer NOT NULL,
    "version" integer NOT NULL,
    "url" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_user_image_user_id" ON "serverpod_user_image" USING btree ("userId", "version");

--
-- Class UserInfo as table serverpod_user_info
--
CREATE TABLE "serverpod_user_info" (
    "id" serial PRIMARY KEY,
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
-- Class AuthKey as table serverpod_auth_key
--
CREATE TABLE "serverpod_auth_key" (
    "id" serial PRIMARY KEY,
    "userId" integer NOT NULL,
    "hash" text NOT NULL,
    "scopeNames" json NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_auth_key_userId_idx" ON "serverpod_auth_key" USING btree ("userId");

--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" serial PRIMARY KEY,
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
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" serial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" serial PRIMARY KEY,
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
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" serial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" integer NOT NULL,
    "closing" integer NOT NULL,
    "idle" integer NOT NULL,
    "granularity" integer NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" integer NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" serial PRIMARY KEY,
    "sessionLogId" integer NOT NULL,
    "messageId" integer,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" integer NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" integer NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" serial PRIMARY KEY,
    "sessionLogId" integer NOT NULL,
    "serverId" text NOT NULL,
    "messageId" integer NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" integer NOT NULL
);

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" serial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" serial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" serial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" integer NOT NULL,
    "messageId" integer,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" integer,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" integer NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" serial PRIMARY KEY,
    "number" integer NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" serial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" serial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" integer,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" integer,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Foreign relations for "address" table
--
ALTER TABLE ONLY "address"
    ADD CONSTRAINT "address_fk_0"
    FOREIGN KEY("inhabitantId")
    REFERENCES "citizen"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "blocking" table
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
-- Foreign relations for "cat" table
--
ALTER TABLE ONLY "cat"
    ADD CONSTRAINT "cat_fk_0"
    FOREIGN KEY("motherId")
    REFERENCES "cat"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "citizen" table
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
-- Foreign relations for "comment" table
--
ALTER TABLE ONLY "comment"
    ADD CONSTRAINT "comment_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "company" table
--
ALTER TABLE ONLY "company"
    ADD CONSTRAINT "company_fk_0"
    FOREIGN KEY("townId")
    REFERENCES "town"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "enrollment" table
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
-- Foreign relations for "long_implicit_id_field" table
--
ALTER TABLE ONLY "long_implicit_id_field"
    ADD CONSTRAINT "long_implicit_id_field_fk_0"
    FOREIGN KEY("_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id")
    REFERENCES "long_implicit_id_field_collection"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "multiple_max_field_name" table
--
ALTER TABLE ONLY "multiple_max_field_name"
    ADD CONSTRAINT "multiple_max_field_name_fk_0"
    FOREIGN KEY("_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId")
    REFERENCES "relation_to_multiple_max_field_name"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "object_user" table
--
ALTER TABLE ONLY "object_user"
    ADD CONSTRAINT "object_user_fk_0"
    FOREIGN KEY("userInfoId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "object_with_parent" table
--
ALTER TABLE ONLY "object_with_parent"
    ADD CONSTRAINT "object_with_parent_fk_0"
    FOREIGN KEY("other")
    REFERENCES "object_field_scopes"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "object_with_self_parent" table
--
ALTER TABLE ONLY "object_with_self_parent"
    ADD CONSTRAINT "object_with_self_parent_fk_0"
    FOREIGN KEY("other")
    REFERENCES "object_with_self_parent"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "order" table
--
ALTER TABLE ONLY "order"
    ADD CONSTRAINT "order_fk_0"
    FOREIGN KEY("customerId")
    REFERENCES "customer"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "organization" table
--
ALTER TABLE ONLY "organization"
    ADD CONSTRAINT "organization_fk_0"
    FOREIGN KEY("cityId")
    REFERENCES "city"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "organization_with_long_table_name_that_is_still_valid" table
--
ALTER TABLE ONLY "organization_with_long_table_name_that_is_still_valid"
    ADD CONSTRAINT "organization_with_long_table_name_that_is_still_valid_fk_0"
    FOREIGN KEY("cityId")
    REFERENCES "city_with_long_table_name_that_is_still_valid"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "parent_user" table
--
ALTER TABLE ONLY "parent_user"
    ADD CONSTRAINT "parent_user_fk_0"
    FOREIGN KEY("userInfoId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "person" table
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
-- Foreign relations for "person_with_long_table_name_that_is_still_valid" table
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
-- Foreign relations for "player" table
--
ALTER TABLE ONLY "player"
    ADD CONSTRAINT "player_fk_0"
    FOREIGN KEY("teamId")
    REFERENCES "team"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "post" table
--
ALTER TABLE ONLY "post"
    ADD CONSTRAINT "post_fk_0"
    FOREIGN KEY("nextId")
    REFERENCES "post"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "related_unique_data" table
--
ALTER TABLE ONLY "related_unique_data"
    ADD CONSTRAINT "related_unique_data_fk_0"
    FOREIGN KEY("uniqueDataId")
    REFERENCES "unique_data"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- Foreign relations for "team" table
--
ALTER TABLE ONLY "team"
    ADD CONSTRAINT "team_fk_0"
    FOREIGN KEY("arenaId")
    REFERENCES "arena"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "town" table
--
ALTER TABLE ONLY "town"
    ADD CONSTRAINT "town_fk_0"
    FOREIGN KEY("mayorId")
    REFERENCES "citizen"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "user_note" table
--
ALTER TABLE ONLY "user_note"
    ADD CONSTRAINT "user_note_fk_0"
    FOREIGN KEY("_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId")
    REFERENCES "user_note_collections"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "user_note_with_a_long_name" table
--
ALTER TABLE ONLY "user_note_with_a_long_name"
    ADD CONSTRAINT "user_note_with_a_long_name_fk_0"
    FOREIGN KEY("_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId")
    REFERENCES "user_note_collection_with_a_long_name"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
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
    VALUES ('serverpod_test', '20240125141253049', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240125141253049', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240115074239642', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240115074239642', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240115074235544', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240115074235544', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20240115074247714', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240115074247714', "timestamp" = now();


COMMIT;
