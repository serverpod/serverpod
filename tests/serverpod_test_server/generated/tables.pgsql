--
-- Class ObjectFieldScopes as table object_field_scopes
--

CREATE TABLE object_field_scopes (
  "id" serial,
  "normal" text NOT NULL,
  "database" text
);

ALTER TABLE ONLY object_field_scopes
  ADD CONSTRAINT object_field_scopes_pkey PRIMARY KEY (id);


--
-- Class ObjectWithEnum as table object_with_enum
--

CREATE TABLE object_with_enum (
  "id" serial,
  "testEnum" json NOT NULL,
  "nullableEnum" json,
  "enumList" json NOT NULL,
  "nullableEnumList" json NOT NULL
);

ALTER TABLE ONLY object_with_enum
  ADD CONSTRAINT object_with_enum_pkey PRIMARY KEY (id);


--
-- Class ObjectWithObject as table object_with_object
--

CREATE TABLE object_with_object (
  "id" serial,
  "data" json NOT NULL,
  "nullableData" json,
  "dataList" json NOT NULL,
  "nullableDataList" json,
  "listWithNullableData" json NOT NULL,
  "nullableListWithNullableData" json
);

ALTER TABLE ONLY object_with_object
  ADD CONSTRAINT object_with_object_pkey PRIMARY KEY (id);


--
-- Class SimpleData as table simple_data
--

CREATE TABLE simple_data (
  "id" serial,
  "num" integer NOT NULL
);

ALTER TABLE ONLY simple_data
  ADD CONSTRAINT simple_data_pkey PRIMARY KEY (id);


--
-- Class Types as table types
--

CREATE TABLE types (
  "id" serial,
  "anInt" integer,
  "aBool" boolean,
  "aDouble" double precision,
  "aDateTime" timestamp without time zone,
  "aString" text,
  "aByteData" bytea
);

ALTER TABLE ONLY types
  ADD CONSTRAINT types_pkey PRIMARY KEY (id);


