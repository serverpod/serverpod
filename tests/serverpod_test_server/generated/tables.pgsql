--
-- Class ObjectFieldScopes as table object_field_scopes
--

CREATE TABLE "object_field_scopes" (
  "id" serial,
  "normal" text NOT NULL,
  "database" text
);

ALTER TABLE ONLY "object_field_scopes"
  ADD CONSTRAINT object_field_scopes_pkey PRIMARY KEY (id);


--
-- Class ObjectWithByteData as table object_with_bytedata
--

CREATE TABLE "object_with_bytedata" (
  "id" serial,
  "byteData" bytea NOT NULL
);

ALTER TABLE ONLY "object_with_bytedata"
  ADD CONSTRAINT object_with_bytedata_pkey PRIMARY KEY (id);


--
-- Class ObjectWithDuration as table object_with_duration
--

CREATE TABLE "object_with_duration" (
  "id" serial,
  "duration" bigint NOT NULL
);

ALTER TABLE ONLY "object_with_duration"
  ADD CONSTRAINT object_with_duration_pkey PRIMARY KEY (id);


--
-- Class ObjectWithEnum as table object_with_enum
--

CREATE TABLE "object_with_enum" (
  "id" serial,
  "testEnum" integer NOT NULL,
  "nullableEnum" integer,
  "enumList" json NOT NULL,
  "nullableEnumList" json NOT NULL,
  "enumListList" json NOT NULL
);

ALTER TABLE ONLY "object_with_enum"
  ADD CONSTRAINT object_with_enum_pkey PRIMARY KEY (id);


--
-- Class ObjectWithIndex as table object_with_index
--

CREATE TABLE "object_with_index" (
  "id" serial,
  "indexed" integer NOT NULL,
  "indexed2" integer NOT NULL
);

ALTER TABLE ONLY "object_with_index"
  ADD CONSTRAINT object_with_index_pkey PRIMARY KEY (id);

CREATE INDEX object_with_index_test_index ON "object_with_index" USING brin ("indexed", "indexed2");


--
-- Class ObjectWithObject as table object_with_object
--

CREATE TABLE "object_with_object" (
  "id" serial,
  "data" json NOT NULL,
  "nullableData" json,
  "dataList" json NOT NULL,
  "nullableDataList" json,
  "listWithNullableData" json NOT NULL,
  "nullableListWithNullableData" json
);

ALTER TABLE ONLY "object_with_object"
  ADD CONSTRAINT object_with_object_pkey PRIMARY KEY (id);


--
-- Class ObjectWithParent as table object_with_parent
--

CREATE TABLE "object_with_parent" (
  "id" serial,
  "other" integer NOT NULL
);

ALTER TABLE ONLY "object_with_parent"
  ADD CONSTRAINT object_with_parent_pkey PRIMARY KEY (id);

ALTER TABLE ONLY "object_with_parent"
  ADD CONSTRAINT object_with_parent_fk_0
    FOREIGN KEY("other")
      REFERENCES object_field_scopes(id)
        ON DELETE CASCADE;

--
-- Class ObjectWithSelfParent as table object_with_self_parent
--

CREATE TABLE "object_with_self_parent" (
  "id" serial,
  "other" integer
);

ALTER TABLE ONLY "object_with_self_parent"
  ADD CONSTRAINT object_with_self_parent_pkey PRIMARY KEY (id);

ALTER TABLE ONLY "object_with_self_parent"
  ADD CONSTRAINT object_with_self_parent_fk_0
    FOREIGN KEY("other")
      REFERENCES object_with_self_parent(id)
        ON DELETE CASCADE;

--
-- Class ObjectWithUuid as table object_with_uuid
--

CREATE TABLE "object_with_uuid" (
  "id" serial,
  "uuid" uuid NOT NULL,
  "uuidNullable" uuid
);

ALTER TABLE ONLY "object_with_uuid"
  ADD CONSTRAINT object_with_uuid_pkey PRIMARY KEY (id);


--
-- Class SimpleData as table simple_data
--

CREATE TABLE "simple_data" (
  "id" serial,
  "num" integer NOT NULL
);

ALTER TABLE ONLY "simple_data"
  ADD CONSTRAINT simple_data_pkey PRIMARY KEY (id);


--
-- Class SimpleDateTime as table simple_datetime
--

CREATE TABLE "simple_datetime" (
  "id" serial,
  "dateTime" timestamp without time zone NOT NULL
);

ALTER TABLE ONLY "simple_datetime"
  ADD CONSTRAINT simple_datetime_pkey PRIMARY KEY (id);


--
-- Class Types as table types
--

CREATE TABLE "types" (
  "id" serial,
  "anInt" integer,
  "aBool" boolean,
  "aDouble" double precision,
  "aDateTime" timestamp without time zone,
  "aString" text,
  "aByteData" bytea,
  "aDuration" bigint,
  "aUuid" uuid
);

ALTER TABLE ONLY "types"
  ADD CONSTRAINT types_pkey PRIMARY KEY (id);


