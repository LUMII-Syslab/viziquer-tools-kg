--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.13 (Ubuntu 14.13-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: starwars; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA starwars;


--
-- Name: SCHEMA starwars; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA starwars IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: starwars; Owner: -
--

CREATE FUNCTION starwars.tapprox(integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
select concat(
	case cc when 0 then nn::text else round(ll::decimal,2-lsize)::text end,
case cc when 5 then 'P' when 4 then 'T' when 3 then 'G' 
	   	when 2 then 'M' when 1 then 'K' when 0 then '' else '' end) as ee
from
(select nn, cc, (c-cc*3)::integer as lsize, pp*(pow(10,c-cc*3)::integer) as ll from
(select nn, round((nn/pow(10,c))::decimal,2) as pp, floor(c/3) as cc, c from
(select case $1 when 0 then 0 else floor(log10($1)) end as c, $1 as nn) bb) aa) bb
$_$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _h_classes; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: starwars; Owner: -
--

COMMENT ON TABLE starwars._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.classes (
    id integer NOT NULL,
    iri text NOT NULL,
    cnt integer,
    data jsonb,
    props_in_schema boolean DEFAULT false NOT NULL,
    ns_id integer,
    local_name text,
    display_name text,
    classification_property_id integer,
    classification_property text,
    classification_adornment text,
    is_literal boolean DEFAULT false,
    datatype_id integer,
    instance_name_pattern jsonb,
    indirect_members boolean DEFAULT false NOT NULL,
    is_unique boolean DEFAULT false NOT NULL,
    large_superclass_id integer,
    hide_in_main boolean DEFAULT false,
    principal_super_class_id integer,
    self_cp_rels boolean DEFAULT true,
    cp_ask_endpoint boolean DEFAULT false
);


--
-- Name: cp_rels; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.cp_rels (
    id integer NOT NULL,
    class_id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    object_cnt integer,
    data_cnt_calc integer GENERATED ALWAYS AS (GREATEST((cnt - object_cnt), (0)::bigint)) STORED,
    max_cardinality integer,
    min_cardinality integer,
    cover_set_index integer,
    add_link_slots integer DEFAULT 1 NOT NULL,
    details_level integer DEFAULT 0 NOT NULL,
    sub_cover_complete boolean DEFAULT false NOT NULL,
    data_cnt integer,
    principal_class_id integer
);


--
-- Name: properties; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.properties (
    id integer NOT NULL,
    iri text NOT NULL,
    cnt integer,
    data jsonb,
    ns_id integer,
    display_name text,
    local_name text,
    is_unique boolean DEFAULT false NOT NULL,
    object_cnt integer,
    data_cnt_calc integer GENERATED ALWAYS AS (GREATEST((cnt - object_cnt), 0)) STORED,
    max_cardinality integer,
    inverse_max_cardinality integer,
    source_cover_complete boolean DEFAULT false NOT NULL,
    target_cover_complete boolean DEFAULT false NOT NULL,
    domain_class_id integer,
    range_class_id integer,
    data_cnt integer,
    classes_in_schema boolean DEFAULT true NOT NULL,
    is_classifier boolean DEFAULT false,
    use_in_class boolean,
    classif_prefix text,
    values_have_cp boolean,
    props_in_schema boolean DEFAULT true,
    pp_ask_endpoint boolean DEFAULT false,
    pc_ask_endpoint boolean DEFAULT false
);


--
-- Name: c_links; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((starwars.classes c1
     JOIN starwars.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN starwars.properties p ON ((cp1.property_id = p.id)))
     JOIN starwars.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN starwars.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt integer,
    data jsonb,
    cover_set_index integer
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt integer,
    data jsonb
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.instances (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text,
    local_name_lowercase text,
    class_id integer,
    class_iri text,
    test tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, local_name)) STORED
);


--
-- Name: instances_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt integer,
    data jsonb
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: starwars; Owner: -
--

CREATE TABLE starwars.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: starwars; Owner: -
--

ALTER TABLE starwars.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME starwars.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.v_cc_rels AS
 SELECT r.id,
    r.class_1_id,
    r.class_2_id,
    r.type_id,
    r.cnt,
    r.data,
    c1.iri AS iri1,
    c1.classification_property AS cprop1,
    c2.iri AS iri2,
    c2.classification_property AS cprop2
   FROM starwars.cc_rels r,
    starwars.classes c1,
    starwars.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.v_classes_ns AS
 SELECT c.id,
    c.iri,
    c.cnt,
    c.ns_id,
    n.name AS prefix,
    c.props_in_schema,
    c.local_name,
    c.display_name,
    c.classification_property_id,
    c.classification_property,
    c.classification_adornment,
    c.is_literal,
    c.datatype_id,
    c.instance_name_pattern,
    c.indirect_members,
    c.is_unique,
    concat(n.name, ',', c.local_name, ',', c.classification_adornment, ',', c.display_name, ',', lower(c.display_name)) AS namestring,
    starwars.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint
   FROM (starwars.classes c
     LEFT JOIN starwars.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.v_classes_ns_main AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.props_in_schema,
    v.local_name,
    v.display_name,
    v.classification_property_id,
    v.classification_property,
    v.classification_adornment,
    v.is_literal,
    v.datatype_id,
    v.instance_name_pattern,
    v.indirect_members,
    v.is_unique,
    v.namestring,
    v.cnt_x,
    v.is_local,
    v.large_superclass_id,
    v.hide_in_main,
    v.principal_super_class_id,
    v.self_cp_rels,
    v.cp_ask_endpoint
   FROM starwars.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM starwars.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.v_classes_ns_plus AS
 SELECT c.id,
    c.iri,
    c.cnt,
    c.ns_id,
    n.name AS prefix,
    c.props_in_schema,
    c.local_name,
    c.display_name,
    c.classification_property_id,
    c.classification_property,
    c.classification_adornment,
    c.is_literal,
    c.datatype_id,
    c.instance_name_pattern,
    c.indirect_members,
    c.is_unique,
    concat(n.name, ',', c.local_name, ',', c.display_name, ',', lower(c.display_name)) AS namestring,
    starwars.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM starwars.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint
   FROM (starwars.classes c
     LEFT JOIN starwars.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.v_classes_ns_main_plus AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.props_in_schema,
    v.local_name,
    v.display_name,
    v.classification_property_id,
    v.classification_property,
    v.classification_adornment,
    v.is_literal,
    v.datatype_id,
    v.instance_name_pattern,
    v.indirect_members,
    v.is_unique,
    v.namestring,
    v.cnt_x,
    v.is_local,
    v.has_subclasses,
    v.large_superclass_id,
    v.hide_in_main,
    v.principal_super_class_id,
    v.self_cp_rels,
    v.cp_ask_endpoint
   FROM starwars.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM starwars.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.v_classes_ns_main_v01 AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.props_in_schema,
    v.local_name,
    v.display_name,
    v.classification_property_id,
    v.classification_property,
    v.classification_adornment,
    v.is_literal,
    v.datatype_id,
    v.instance_name_pattern,
    v.indirect_members,
    v.is_unique,
    v.namestring,
    v.cnt_x,
    v.is_local
   FROM (starwars.v_classes_ns v
     LEFT JOIN starwars.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.v_cp_rels AS
 SELECT r.id,
    r.class_id,
    r.property_id,
    r.type_id,
    r.cnt,
    r.data,
    r.object_cnt,
    r.data_cnt_calc AS data_cnt,
    r.max_cardinality,
    r.min_cardinality,
    r.cover_set_index,
    r.add_link_slots,
    r.details_level,
    r.sub_cover_complete,
    starwars.tapprox((r.cnt)::integer) AS cnt_x,
    starwars.tapprox(r.object_cnt) AS object_cnt_x,
    starwars.tapprox(r.data_cnt_calc) AS data_cnt_x,
    c.iri AS class_iri,
    c.classification_property_id AS class_cprop_id,
    c.classification_property AS class_cprop,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    p.iri AS property_iri
   FROM starwars.cp_rels r,
    starwars.classes c,
    starwars.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.v_cp_rels_card AS
 SELECT r.id,
    r.class_id,
    r.property_id,
    r.type_id,
    r.cnt,
    r.data,
    r.object_cnt,
    r.data_cnt_calc,
    r.max_cardinality,
    r.min_cardinality,
    r.cover_set_index,
    r.add_link_slots,
    r.details_level,
    r.sub_cover_complete,
    r.data_cnt,
    COALESCE(r.max_cardinality,
        CASE r.type_id
            WHEN 2 THEN p.max_cardinality
            ELSE p.inverse_max_cardinality
        END, '-1'::integer) AS x_max_cardinality,
    r.principal_class_id
   FROM starwars.cp_rels r,
    starwars.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.v_properties_ns AS
 SELECT p.id,
    p.iri,
    p.cnt,
    p.ns_id,
    n.name AS prefix,
    p.display_name,
    p.local_name,
    p.is_unique,
    p.object_cnt,
    p.data_cnt_calc AS data_cnt,
    p.source_cover_complete,
    p.target_cover_complete,
    concat(n.name, ',', p.local_name, ',', p.display_name, ',', lower(p.display_name)) AS namestring,
    starwars.tapprox(p.cnt) AS cnt_x,
    starwars.tapprox(p.object_cnt) AS object_cnt_x,
    starwars.tapprox(p.data_cnt_calc) AS data_cnt_x,
    n.is_local,
    p.domain_class_id,
    p.range_class_id,
    p.classes_in_schema,
    p.is_classifier,
    p.use_in_class,
    p.classif_prefix,
    p.values_have_cp,
    p.props_in_schema,
    p.pp_ask_endpoint,
    p.pc_ask_endpoint,
    n.basic_order_level,
        CASE
            WHEN (p.max_cardinality IS NOT NULL) THEN p.max_cardinality
            ELSE '-1'::integer
        END AS max_cardinality,
        CASE
            WHEN (p.inverse_max_cardinality IS NOT NULL) THEN p.inverse_max_cardinality
            ELSE '-1'::integer
        END AS inverse_max_cardinality
   FROM (starwars.properties p
     LEFT JOIN starwars.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.v_cp_sources_single AS
 SELECT r.class_id,
    v.id,
    v.iri,
    r.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    r.object_cnt AS o,
    v.namestring,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS class_cprop_id,
    c.classification_property AS class_cprop,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    r.x_max_cardinality
   FROM ((starwars.v_cp_rels_card r
     JOIN starwars.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN starwars.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.v_cp_targets_single AS
 SELECT r.class_id,
    v.id,
    v.iri,
    r.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    r.object_cnt AS o,
    v.namestring,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS class_cprop_id,
    c.classification_property AS class_cprop,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    r.x_max_cardinality
   FROM ((starwars.v_cp_rels_card r
     JOIN starwars.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN starwars.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    starwars.tapprox((r.cnt)::integer) AS cnt_x
   FROM starwars.pp_rels r,
    starwars.properties p1,
    starwars.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.v_properties_sources AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    v.object_cnt,
    v.data_cnt,
    v.source_cover_complete,
    v.target_cover_complete,
    v.namestring,
    v.cnt_x,
    v.object_cnt_x,
    v.data_cnt_x,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS base_class_cprop_id,
    c.classification_property AS base_class_cprop,
    c.classification_adornment AS base_class_adornment,
    c.is_literal AS base_class_is_literal,
    c.datatype_id AS base_cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    v.max_cardinality,
    v.inverse_max_cardinality
   FROM (starwars.v_properties_ns v
     LEFT JOIN ( SELECT r.id,
            r.property_id,
            r.cover_set_index,
            r.add_link_slots,
            c_1.id AS id_1,
            c_1.iri,
            c_1.ns_id,
            c_1.prefix,
            c_1.local_name,
            c_1.display_name,
            c_1.classification_property_id,
            c_1.classification_property,
            c_1.classification_adornment,
            c_1.is_literal,
            c_1.datatype_id,
            c_1.indirect_members,
            c_1.is_unique,
            c_1.namestring,
            c_1.is_local
           FROM starwars.cp_rels r,
            starwars.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.v_properties_sources_single AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    v.object_cnt,
    v.data_cnt,
    v.source_cover_complete,
    v.target_cover_complete,
    v.namestring,
    v.cnt_x,
    v.object_cnt_x,
    v.data_cnt_x,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS class_cprop_id,
    c.classification_property AS class_cprop,
    c.classification_adornment AS class_adornment,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    v.max_cardinality,
    v.inverse_max_cardinality
   FROM (starwars.v_properties_ns v
     LEFT JOIN starwars.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.v_properties_targets AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    v.object_cnt,
    v.data_cnt,
    v.source_cover_complete,
    v.target_cover_complete,
    v.namestring,
    v.cnt_x,
    v.object_cnt_x,
    v.data_cnt_x,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS base_class_cprop_id,
    c.classification_property AS base_class_cprop,
    c.classification_adornment AS base_class_adornment,
    c.is_literal AS base_class_is_literal,
    c.datatype_id AS base_cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    v.max_cardinality,
    v.inverse_max_cardinality
   FROM (starwars.v_properties_ns v
     LEFT JOIN ( SELECT r.id,
            r.property_id,
            r.cover_set_index,
            r.add_link_slots,
            c_1.id AS id_1,
            c_1.iri,
            c_1.ns_id,
            c_1.prefix,
            c_1.local_name,
            c_1.display_name,
            c_1.classification_property_id,
            c_1.classification_property,
            c_1.classification_adornment,
            c_1.is_literal,
            c_1.datatype_id,
            c_1.indirect_members,
            c_1.is_unique,
            c_1.namestring,
            c_1.is_local
           FROM starwars.cp_rels r,
            starwars.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: starwars; Owner: -
--

CREATE VIEW starwars.v_properties_targets_single AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    v.object_cnt,
    v.data_cnt,
    v.source_cover_complete,
    v.target_cover_complete,
    v.namestring,
    v.cnt_x,
    v.object_cnt_x,
    v.data_cnt_x,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS class_cprop_id,
    c.classification_property AS class_cprop,
    c.classification_adornment AS class_adornment,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    v.max_cardinality,
    v.inverse_max_cardinality
   FROM (starwars.v_properties_ns v
     LEFT JOIN starwars.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	1	6	1	\N	\N
2	2	6	1	\N	\N
3	4	6	1	\N	\N
4	5	6	1	\N	\N
5	8	6	1	\N	\N
6	9	6	1	\N	\N
7	10	6	1	\N	\N
8	11	6	1	\N	\N
9	12	6	1	\N	\N
10	13	6	1	\N	\N
11	15	6	1	\N	\N
12	16	6	1	\N	\N
13	17	6	1	\N	\N
14	18	6	1	\N	\N
15	19	6	1	\N	\N
16	21	6	1	\N	\N
17	22	6	1	\N	\N
18	23	6	1	\N	\N
19	25	6	1	\N	\N
20	27	6	1	\N	\N
21	28	6	1	\N	\N
22	29	6	1	\N	\N
23	30	6	1	\N	\N
24	31	6	1	\N	\N
25	32	6	1	\N	\N
26	33	6	1	\N	\N
27	35	6	1	\N	\N
28	36	6	1	\N	\N
29	37	6	1	\N	\N
30	40	6	1	\N	\N
31	41	6	1	\N	\N
32	42	6	1	\N	\N
33	44	6	1	\N	\N
34	45	6	1	\N	\N
35	47	6	1	\N	\N
36	49	6	1	\N	\N
37	50	6	1	\N	\N
38	51	6	1	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint) FROM stdin;
1	https://swapi.co/vocabulary/Besalisk	1	\N	t	68	Besalisk	Besalisk	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
2	https://swapi.co/vocabulary/Droid	6	\N	t	68	Droid	Droid	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
3	https://swapi.co/vocabulary/Location	195	\N	t	68	Location	Location	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
4	https://swapi.co/vocabulary/Nautolan	1	\N	t	68	Nautolan	Nautolan	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
5	https://swapi.co/vocabulary/Sullustan	1	\N	t	68	Sullustan	Sullustan	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
6	https://swapi.co/vocabulary/Character	87	\N	t	68	Character	Character	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
7	https://swapi.co/vocabulary/FilmRelease	29	\N	t	68	FilmRelease	FilmRelease	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
8	https://swapi.co/vocabulary/Geonosian	1	\N	t	68	Geonosian	Geonosian	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
9	https://swapi.co/vocabulary/Hutt	1	\N	t	68	Hutt	Hutt	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
10	https://swapi.co/vocabulary/Moncalamari	1	\N	t	68	Moncalamari	Moncalamari	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
11	https://swapi.co/vocabulary/Quermian	1	\N	t	68	Quermian	Quermian	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
12	https://swapi.co/vocabulary/Tholothian	1	\N	t	68	Tholothian	Tholothian	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
13	https://swapi.co/vocabulary/Xexto	1	\N	t	68	Xexto	Xexto	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
14	https://swapi.co/vocabulary/Award	62	\N	t	68	Award	Award	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
15	https://swapi.co/vocabulary/Iktotchi	1	\N	t	68	Iktotchi	Iktotchi	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
16	https://swapi.co/vocabulary/Cerean	1	\N	t	68	Cerean	Cerean	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
17	https://swapi.co/vocabulary/Dug	1	\N	t	68	Dug	Dug	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
18	https://swapi.co/vocabulary/Gungan	3	\N	t	68	Gungan	Gungan	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
19	https://swapi.co/vocabulary/Human	38	\N	t	68	Human	Human	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
20	https://swapi.co/vocabulary/Person	249	\N	t	68	Person	Person	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
21	https://swapi.co/vocabulary/Rodian	1	\N	t	68	Rodian	Rodian	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
22	https://swapi.co/vocabulary/Trandoshan	1	\N	t	68	Trandoshan	Trandoshan	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
23	https://swapi.co/vocabulary/Yodasspecies	1	\N	t	68	Yodasspecies	Yodasspecies	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
24	https://swapi.co/vocabulary/Country	41	\N	t	68	Country	Country	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
25	https://swapi.co/vocabulary/Ewok	1	\N	t	68	Ewok	Ewok	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
26	https://swapi.co/vocabulary/FilmRole	345	\N	t	68	FilmRole	FilmRole	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
27	https://swapi.co/vocabulary/Kaleesh	1	\N	t	68	Kaleesh	Kaleesh	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
28	https://swapi.co/vocabulary/Togruta	1	\N	t	68	Togruta	Togruta	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
29	https://swapi.co/vocabulary/Twilek	2	\N	t	68	Twilek	Twilek	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
30	https://swapi.co/vocabulary/Aleena	1	\N	t	68	Aleena	Aleena	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
31	https://swapi.co/vocabulary/Clawdite	1	\N	t	68	Clawdite	Clawdite	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
32	https://swapi.co/vocabulary/Kaminoan	2	\N	t	68	Kaminoan	Kaminoan	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
33	https://swapi.co/vocabulary/Skakoan	1	\N	t	68	Skakoan	Skakoan	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
34	https://swapi.co/vocabulary/Species	38	\N	t	68	Species	Species	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
35	https://swapi.co/vocabulary/Wookiee	2	\N	t	68	Wookiee	Wookiee	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
36	https://swapi.co/vocabulary/Keldor	1	\N	t	68	Keldor	Keldor	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
37	https://swapi.co/vocabulary/Neimodian	1	\N	t	68	Neimodian	Neimodian	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
38	https://swapi.co/vocabulary/Planet	61	\N	t	68	Planet	Planet	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
39	https://swapi.co/vocabulary/Starship	37	\N	t	68	Starship	Starship	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
40	https://swapi.co/vocabulary/Toong	1	\N	t	68	Toong	Toong	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
41	https://swapi.co/vocabulary/Toydarian	1	\N	t	68	Toydarian	Toydarian	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
42	https://swapi.co/vocabulary/Zabrak	2	\N	t	68	Zabrak	Zabrak	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
43	https://swapi.co/vocabulary/AwardRecognition	198	\N	t	68	AwardRecognition	AwardRecognition	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
44	https://swapi.co/vocabulary/Chagrian	1	\N	t	68	Chagrian	Chagrian	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
45	https://swapi.co/vocabulary/Umbaran	1	\N	t	68	Umbaran	Umbaran	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
46	https://swapi.co/vocabulary/Vehicle	39	\N	t	68	Vehicle	Vehicle	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
47	https://swapi.co/vocabulary/Vulptereen	1	\N	t	68	Vulptereen	Vulptereen	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
48	https://swapi.co/vocabulary/Film	7	\N	t	68	Film	Film	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
49	https://swapi.co/vocabulary/Mirialan	2	\N	t	68	Mirialan	Mirialan	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
50	https://swapi.co/vocabulary/Muun	1	\N	t	68	Muun	Muun	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
51	https://swapi.co/vocabulary/Pauan	1	\N	t	68	Pauan	Pauan	\N	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id) FROM stdin;
1	6	1	2	59	\N	0	1	0	1	1	2	f	59	\N
2	19	1	2	22	\N	0	1	0	0	1	2	f	22	\N
3	2	1	2	4	\N	0	1	0	0	1	2	f	4	\N
4	18	1	2	2	\N	0	1	0	0	1	2	f	2	\N
5	49	1	2	2	\N	0	1	1	0	1	2	f	2	\N
6	35	1	2	2	\N	0	1	1	0	1	2	f	2	\N
7	30	1	2	1	\N	0	1	1	0	1	2	f	1	\N
8	1	1	2	1	\N	0	1	1	0	1	2	f	1	\N
9	16	1	2	1	\N	0	1	1	0	1	2	f	1	\N
10	31	1	2	1	\N	0	1	1	0	1	2	f	1	\N
11	17	1	2	1	\N	0	1	1	0	1	2	f	1	\N
12	25	1	2	1	\N	0	1	1	0	1	2	f	1	\N
13	8	1	2	1	\N	0	1	1	0	1	2	f	1	\N
14	9	1	2	1	\N	0	1	1	0	1	2	f	1	\N
15	27	1	2	1	\N	0	1	1	0	1	2	f	1	\N
16	32	1	2	1	\N	0	1	0	0	1	2	f	1	\N
17	36	1	2	1	\N	0	1	1	0	1	2	f	1	\N
18	10	1	2	1	\N	0	1	1	0	1	2	f	1	\N
19	4	1	2	1	\N	0	1	1	0	1	2	f	1	\N
20	37	1	2	1	\N	0	1	1	0	1	2	f	1	\N
21	51	1	2	1	\N	0	1	1	0	1	2	f	1	\N
22	21	1	2	1	\N	0	1	1	0	1	2	f	1	\N
23	33	1	2	1	\N	0	1	1	0	1	2	f	1	\N
24	5	1	2	1	\N	0	1	1	0	1	2	f	1	\N
25	12	1	2	1	\N	0	1	1	0	1	2	f	1	\N
26	28	1	2	1	\N	0	1	1	0	1	2	f	1	\N
27	40	1	2	1	\N	0	1	1	0	1	2	f	1	\N
28	22	1	2	1	\N	0	1	1	0	1	2	f	1	\N
29	29	1	2	1	\N	0	1	0	0	1	2	f	1	\N
30	45	1	2	1	\N	0	1	1	0	1	2	f	1	\N
31	47	1	2	1	\N	0	1	1	0	1	2	f	1	\N
32	23	1	2	1	\N	0	1	1	0	1	2	f	1	\N
33	42	1	2	1	\N	0	1	0	0	1	2	f	1	\N
34	48	2	2	7	\N	0	1	1	1	1	2	f	7	\N
35	26	3	2	345	\N	0	1	1	1	1	2	f	345	\N
36	46	4	2	31	\N	0	1	0	1	1	2	f	31	\N
37	39	4	2	29	\N	0	1	0	2	1	2	f	29	\N
38	38	5	2	43	\N	0	1	0	1	1	2	f	43	\N
39	6	6	2	101	\N	0	-1	0	1	1	2	f	101	\N
40	34	6	2	88	\N	0	-1	0	2	1	2	f	88	\N
41	19	6	2	37	\N	0	1	0	0	1	2	f	37	\N
42	2	6	2	8	\N	0	-1	0	0	1	2	f	8	\N
43	31	6	2	3	\N	0	-1	1	0	1	2	f	3	\N
44	18	6	2	3	\N	0	1	1	0	1	2	f	3	\N
45	28	6	2	3	\N	0	-1	1	0	1	2	f	3	\N
46	40	6	2	3	\N	0	-1	1	0	1	2	f	3	\N
47	30	6	2	2	\N	0	-1	1	0	1	2	f	2	\N
48	17	6	2	2	\N	0	-1	1	0	1	2	f	2	\N
49	9	6	2	2	\N	0	-1	1	0	1	2	f	2	\N
50	27	6	2	2	\N	0	-1	1	0	1	2	f	2	\N
51	32	6	2	2	\N	0	1	1	0	1	2	f	2	\N
52	49	6	2	2	\N	0	1	1	0	1	2	f	2	\N
53	33	6	2	2	\N	0	-1	1	0	1	2	f	2	\N
54	41	6	2	2	\N	0	-1	1	0	1	2	f	2	\N
55	29	6	2	2	\N	0	1	1	0	1	2	f	2	\N
56	47	6	2	2	\N	0	-1	1	0	1	2	f	2	\N
57	13	6	2	2	\N	0	-1	1	0	1	2	f	2	\N
58	42	6	2	2	\N	0	1	1	0	1	2	f	2	\N
59	1	6	2	1	\N	0	1	1	0	1	2	f	1	\N
60	16	6	2	1	\N	0	1	1	0	1	2	f	1	\N
61	44	6	2	1	\N	0	1	1	0	1	2	f	1	\N
62	25	6	2	1	\N	0	1	1	0	1	2	f	1	\N
63	8	6	2	1	\N	0	1	1	0	1	2	f	1	\N
64	15	6	2	1	\N	0	1	1	0	1	2	f	1	\N
65	36	6	2	1	\N	0	1	1	0	1	2	f	1	\N
66	10	6	2	1	\N	0	1	1	0	1	2	f	1	\N
67	50	6	2	1	\N	0	1	1	0	1	2	f	1	\N
68	4	6	2	1	\N	0	1	1	0	1	2	f	1	\N
69	37	6	2	1	\N	0	1	1	0	1	2	f	1	\N
70	51	6	2	1	\N	0	1	1	0	1	2	f	1	\N
71	11	6	2	1	\N	0	1	1	0	1	2	f	1	\N
72	21	6	2	1	\N	0	1	1	0	1	2	f	1	\N
73	5	6	2	1	\N	0	1	1	0	1	2	f	1	\N
74	12	6	2	1	\N	0	1	1	0	1	2	f	1	\N
75	22	6	2	1	\N	0	1	1	0	1	2	f	1	\N
76	45	6	2	1	\N	0	1	1	0	1	2	f	1	\N
77	35	6	2	1	\N	0	1	0	0	1	2	f	1	\N
78	23	6	2	1	\N	0	1	1	0	1	2	f	1	\N
79	34	7	2	35	\N	0	1	0	1	1	2	f	35	\N
80	38	8	2	48	\N	0	1	0	1	1	2	f	48	\N
81	46	9	2	38	\N	0	1	0	1	1	2	f	38	\N
82	39	9	2	33	\N	0	1	0	2	1	2	f	33	\N
83	48	10	2	10	\N	0	-1	1	1	1	2	f	10	\N
84	43	11	2	198	\N	198	1	1	1	1	2	f	0	\N
85	14	11	1	198	\N	198	-1	0	1	1	2	f	\N	\N
86	48	12	2	49	\N	49	-1	0	1	1	2	f	0	\N
87	6	12	2	13	\N	13	-1	0	2	1	2	f	0	\N
88	19	12	2	9	\N	9	-1	0	0	1	2	f	0	\N
89	31	12	2	1	\N	1	1	1	0	1	2	f	0	\N
90	27	12	2	1	\N	1	1	1	0	1	2	f	0	\N
91	35	12	2	1	\N	1	1	0	0	1	2	f	0	\N
92	42	12	2	1	\N	1	1	0	0	1	2	f	0	\N
93	46	12	1	62	\N	62	-1	1	1	1	2	f	\N	\N
94	46	13	2	39	\N	0	1	1	1	1	2	f	39	\N
95	39	13	2	36	\N	0	1	0	2	1	2	f	36	\N
96	34	14	2	76	\N	76	-1	1	1	1	2	f	0	\N
97	6	15	2	86	\N	0	-1	0	1	1	2	f	86	\N
98	34	15	2	69	\N	0	-1	0	2	1	2	f	69	\N
99	19	15	2	37	\N	0	1	0	0	1	2	f	37	\N
100	2	15	2	7	\N	0	-1	1	0	1	2	f	7	\N
101	18	15	2	3	\N	0	1	1	0	1	2	f	3	\N
102	27	15	2	2	\N	0	-1	1	0	1	2	f	2	\N
103	32	15	2	2	\N	0	1	1	0	1	2	f	2	\N
104	49	15	2	2	\N	0	1	1	0	1	2	f	2	\N
105	29	15	2	2	\N	0	1	1	0	1	2	f	2	\N
106	35	15	2	2	\N	0	1	1	0	1	2	f	2	\N
107	42	15	2	2	\N	0	1	1	0	1	2	f	2	\N
108	1	15	2	1	\N	0	1	1	0	1	2	f	1	\N
109	16	15	2	1	\N	0	1	1	0	1	2	f	1	\N
110	44	15	2	1	\N	0	1	1	0	1	2	f	1	\N
111	31	15	2	1	\N	0	1	1	0	1	2	f	1	\N
112	17	15	2	1	\N	0	1	1	0	1	2	f	1	\N
113	25	15	2	1	\N	0	1	1	0	1	2	f	1	\N
114	8	15	2	1	\N	0	1	1	0	1	2	f	1	\N
115	9	15	2	1	\N	0	1	1	0	1	2	f	1	\N
116	15	15	2	1	\N	0	1	1	0	1	2	f	1	\N
117	36	15	2	1	\N	0	1	1	0	1	2	f	1	\N
118	10	15	2	1	\N	0	1	1	0	1	2	f	1	\N
119	50	15	2	1	\N	0	1	1	0	1	2	f	1	\N
120	4	15	2	1	\N	0	1	1	0	1	2	f	1	\N
121	37	15	2	1	\N	0	1	1	0	1	2	f	1	\N
122	51	15	2	1	\N	0	1	1	0	1	2	f	1	\N
123	11	15	2	1	\N	0	1	1	0	1	2	f	1	\N
124	21	15	2	1	\N	0	1	1	0	1	2	f	1	\N
125	5	15	2	1	\N	0	1	1	0	1	2	f	1	\N
126	12	15	2	1	\N	0	1	1	0	1	2	f	1	\N
127	28	15	2	1	\N	0	1	1	0	1	2	f	1	\N
128	40	15	2	1	\N	0	1	1	0	1	2	f	1	\N
129	41	15	2	1	\N	0	1	1	0	1	2	f	1	\N
130	22	15	2	1	\N	0	1	1	0	1	2	f	1	\N
131	45	15	2	1	\N	0	1	1	0	1	2	f	1	\N
132	47	15	2	1	\N	0	1	1	0	1	2	f	1	\N
133	13	15	2	1	\N	0	1	1	0	1	2	f	1	\N
134	23	15	2	1	\N	0	1	1	0	1	2	f	1	\N
135	2	16	2	6	\N	0	1	1	1	1	2	f	6	\N
136	6	16	2	6	\N	0	1	0	0	1	2	f	6	\N
137	46	17	2	38	\N	0	1	0	1	1	2	f	38	\N
138	39	17	2	36	\N	0	1	0	2	1	2	f	36	\N
139	20	18	2	3995	\N	0	-1	1	1	1	2	f	3995	\N
140	6	18	2	443	\N	0	-1	0	2	1	2	f	443	\N
141	48	18	2	191	\N	0	-1	1	3	1	2	f	191	\N
142	38	18	2	11	\N	0	1	0	4	1	2	f	11	\N
143	39	18	2	8	\N	0	1	0	5	1	2	f	8	\N
144	46	18	2	6	\N	0	1	0	6	1	2	f	6	\N
145	34	18	2	5	\N	0	1	0	7	1	2	f	5	\N
146	19	18	2	297	\N	0	-1	0	0	1	2	f	297	\N
147	2	18	2	31	\N	0	-1	0	0	1	2	f	31	\N
148	23	18	2	20	\N	0	-1	1	0	1	2	f	20	\N
149	42	18	2	18	\N	0	-1	0	0	1	2	f	18	\N
150	35	18	2	17	\N	0	-1	0	0	1	2	f	17	\N
151	41	18	2	13	\N	0	-1	1	0	1	2	f	13	\N
152	18	18	2	11	\N	0	-1	0	0	1	2	f	11	\N
153	16	18	2	8	\N	0	-1	1	0	1	2	f	8	\N
154	37	18	2	8	\N	0	-1	1	0	1	2	f	8	\N
155	31	18	2	5	\N	0	-1	1	0	1	2	f	5	\N
156	8	18	2	3	\N	0	-1	1	0	1	2	f	3	\N
157	32	18	2	3	\N	0	-1	0	0	1	2	f	3	\N
158	29	18	2	3	\N	0	-1	0	0	1	2	f	3	\N
159	51	18	2	2	\N	0	-1	1	0	1	2	f	2	\N
160	9	18	2	1	\N	0	1	1	0	1	2	f	1	\N
161	27	18	2	1	\N	0	1	1	0	1	2	f	1	\N
162	21	18	2	1	\N	0	1	1	0	1	2	f	1	\N
163	5	18	2	1	\N	0	1	1	0	1	2	f	1	\N
164	38	19	2	45	\N	0	1	0	1	1	2	f	45	\N
165	38	20	2	26	\N	0	1	0	1	1	2	f	26	\N
166	39	21	2	31	\N	31	-1	0	1	1	2	f	0	\N
167	46	21	2	13	\N	13	-1	0	2	1	2	f	0	\N
168	6	21	1	44	\N	44	-1	0	1	1	2	f	\N	\N
169	19	21	1	34	\N	34	-1	0	0	1	2	f	\N	\N
170	35	21	1	3	\N	3	-1	0	0	1	2	f	\N	\N
171	27	21	1	2	\N	2	-1	1	0	1	2	f	\N	\N
172	42	21	1	2	\N	2	-1	0	0	1	2	f	\N	\N
173	31	21	1	1	\N	1	1	1	0	1	2	f	\N	\N
174	36	21	1	1	\N	1	1	1	0	1	2	f	\N	\N
175	5	21	1	1	\N	1	1	1	0	1	2	f	\N	\N
176	46	22	2	38	\N	0	1	0	1	1	2	f	38	\N
177	39	22	2	37	\N	0	1	1	2	1	2	f	37	\N
178	26	23	2	345	\N	345	1	1	1	1	2	f	0	\N
179	6	23	2	173	\N	173	-1	1	2	1	2	f	0	\N
180	34	23	2	77	\N	77	-1	1	3	1	2	f	0	\N
181	43	23	2	65	\N	65	1	0	4	1	2	f	0	\N
182	39	23	2	57	\N	57	-1	1	5	1	2	f	0	\N
183	46	23	2	49	\N	49	-1	1	6	1	2	f	0	\N
184	38	23	2	34	\N	34	-1	0	7	1	2	f	0	\N
185	7	23	2	29	\N	29	1	1	8	1	2	f	0	\N
186	19	23	2	81	\N	81	-1	1	0	1	2	f	0	\N
187	2	23	2	18	\N	18	-1	1	0	1	2	f	0	\N
188	35	23	2	6	\N	6	-1	1	0	1	2	f	0	\N
189	23	23	2	5	\N	5	-1	1	0	1	2	f	0	\N
190	18	23	2	4	\N	4	-1	1	0	1	2	f	0	\N
191	29	23	2	4	\N	4	-1	1	0	1	2	f	0	\N
192	16	23	2	3	\N	3	-1	1	0	1	2	f	0	\N
193	9	23	2	3	\N	3	-1	1	0	1	2	f	0	\N
194	36	23	2	3	\N	3	-1	1	0	1	2	f	0	\N
195	49	23	2	3	\N	3	-1	1	0	1	2	f	0	\N
196	4	23	2	3	\N	3	-1	1	0	1	2	f	0	\N
197	37	23	2	3	\N	3	-1	1	0	1	2	f	0	\N
198	42	23	2	3	\N	3	-1	1	0	1	2	f	0	\N
199	44	23	2	2	\N	2	-1	1	0	1	2	f	0	\N
200	8	23	2	2	\N	2	-1	1	0	1	2	f	0	\N
201	15	23	2	2	\N	2	-1	1	0	1	2	f	0	\N
202	32	23	2	2	\N	2	1	1	0	1	2	f	0	\N
203	10	23	2	2	\N	2	-1	1	0	1	2	f	0	\N
204	12	23	2	2	\N	2	-1	1	0	1	2	f	0	\N
205	28	23	2	2	\N	2	-1	1	0	1	2	f	0	\N
206	41	23	2	2	\N	2	-1	1	0	1	2	f	0	\N
207	45	23	2	2	\N	2	-1	1	0	1	2	f	0	\N
208	30	23	2	1	\N	1	1	1	0	1	2	f	0	\N
209	1	23	2	1	\N	1	1	1	0	1	2	f	0	\N
210	31	23	2	1	\N	1	1	1	0	1	2	f	0	\N
211	17	23	2	1	\N	1	1	1	0	1	2	f	0	\N
212	25	23	2	1	\N	1	1	1	0	1	2	f	0	\N
213	27	23	2	1	\N	1	1	1	0	1	2	f	0	\N
214	50	23	2	1	\N	1	1	1	0	1	2	f	0	\N
215	51	23	2	1	\N	1	1	1	0	1	2	f	0	\N
216	11	23	2	1	\N	1	1	1	0	1	2	f	0	\N
217	21	23	2	1	\N	1	1	1	0	1	2	f	0	\N
218	33	23	2	1	\N	1	1	1	0	1	2	f	0	\N
219	5	23	2	1	\N	1	1	1	0	1	2	f	0	\N
220	40	23	2	1	\N	1	1	1	0	1	2	f	0	\N
221	22	23	2	1	\N	1	1	1	0	1	2	f	0	\N
222	47	23	2	1	\N	1	1	1	0	1	2	f	0	\N
223	13	23	2	1	\N	1	1	1	0	1	2	f	0	\N
224	48	23	1	829	\N	829	-1	1	1	1	2	f	\N	\N
225	34	24	2	36	\N	0	1	0	1	1	2	f	36	\N
226	48	25	2	12	\N	0	-1	0	1	1	2	f	12	\N
227	43	26	2	198	\N	0	1	1	1	1	2	f	198	\N
228	48	27	2	173	\N	173	-1	1	1	1	2	f	0	\N
229	26	27	2	106	\N	106	-1	0	2	1	2	f	0	\N
230	34	27	2	83	\N	83	-1	1	3	1	2	f	0	\N
231	6	27	1	362	\N	362	-1	1	1	1	2	f	\N	\N
232	19	27	1	181	\N	181	-1	1	0	1	2	f	\N	\N
233	2	27	1	36	\N	36	-1	1	0	1	2	f	\N	\N
234	35	27	1	13	\N	13	-1	1	0	1	2	f	\N	\N
235	23	27	1	13	\N	13	-1	1	0	1	2	f	\N	\N
236	18	27	1	9	\N	9	-1	1	0	1	2	f	\N	\N
237	37	27	1	7	\N	7	-1	1	0	1	2	f	\N	\N
238	29	27	1	7	\N	7	-1	1	0	1	2	f	\N	\N
239	42	27	1	7	\N	7	-1	1	0	1	2	f	\N	\N
240	16	27	1	6	\N	6	-1	1	0	1	2	f	\N	\N
241	32	27	1	5	\N	5	-1	1	0	1	2	f	\N	\N
242	49	27	1	5	\N	5	-1	1	0	1	2	f	\N	\N
243	41	27	1	5	\N	5	-1	1	0	1	2	f	\N	\N
244	8	27	1	4	\N	4	-1	1	0	1	2	f	\N	\N
245	9	27	1	4	\N	4	-1	1	0	1	2	f	\N	\N
246	36	27	1	4	\N	4	-1	1	0	1	2	f	\N	\N
247	4	27	1	4	\N	4	-1	1	0	1	2	f	\N	\N
248	44	27	1	3	\N	3	-1	1	0	1	2	f	\N	\N
249	31	27	1	3	\N	3	-1	1	0	1	2	f	\N	\N
250	15	27	1	3	\N	3	-1	1	0	1	2	f	\N	\N
251	10	27	1	3	\N	3	-1	1	0	1	2	f	\N	\N
252	51	27	1	3	\N	3	-1	1	0	1	2	f	\N	\N
253	21	27	1	3	\N	3	-1	1	0	1	2	f	\N	\N
254	12	27	1	3	\N	3	-1	1	0	1	2	f	\N	\N
255	28	27	1	3	\N	3	-1	1	0	1	2	f	\N	\N
256	30	27	1	2	\N	2	-1	1	0	1	2	f	\N	\N
257	1	27	1	2	\N	2	-1	1	0	1	2	f	\N	\N
258	17	27	1	2	\N	2	-1	1	0	1	2	f	\N	\N
259	25	27	1	2	\N	2	-1	1	0	1	2	f	\N	\N
260	27	27	1	2	\N	2	-1	1	0	1	2	f	\N	\N
261	50	27	1	2	\N	2	-1	1	0	1	2	f	\N	\N
262	11	27	1	2	\N	2	-1	1	0	1	2	f	\N	\N
263	33	27	1	2	\N	2	-1	1	0	1	2	f	\N	\N
264	5	27	1	2	\N	2	-1	1	0	1	2	f	\N	\N
265	40	27	1	2	\N	2	-1	1	0	1	2	f	\N	\N
266	22	27	1	2	\N	2	-1	1	0	1	2	f	\N	\N
267	45	27	1	2	\N	2	-1	1	0	1	2	f	\N	\N
268	47	27	1	2	\N	2	-1	1	0	1	2	f	\N	\N
269	13	27	1	2	\N	2	-1	1	0	1	2	f	\N	\N
270	20	28	2	51	\N	51	-1	0	1	1	2	f	0	\N
271	3	28	1	48	\N	48	-1	0	1	1	2	f	\N	\N
272	24	28	1	3	\N	3	-1	0	2	1	2	f	\N	\N
273	38	29	2	48	\N	0	1	0	1	1	2	f	48	\N
274	26	30	2	345	\N	345	1	1	1	1	2	f	0	\N
275	20	30	2	249	\N	249	1	1	2	1	2	f	0	\N
276	43	30	2	198	\N	198	1	1	3	1	2	f	0	\N
277	3	30	2	195	\N	195	1	1	4	1	2	f	0	\N
278	6	30	2	174	\N	174	-1	1	5	1	2	f	0	\N
279	14	30	2	62	\N	62	1	1	6	1	2	f	0	\N
280	38	30	2	61	\N	61	1	1	7	1	2	f	0	\N
281	24	30	2	41	\N	41	1	1	8	1	2	f	0	\N
282	46	30	2	39	\N	39	1	1	9	1	2	f	0	\N
283	34	30	2	38	\N	38	1	1	10	1	2	f	0	\N
284	39	30	2	37	\N	37	1	1	11	1	2	f	0	\N
285	7	30	2	29	\N	29	1	1	12	1	2	f	0	\N
286	48	30	2	7	\N	7	1	1	13	1	2	f	0	\N
287	19	30	2	76	\N	76	-1	1	0	1	2	f	0	\N
288	2	30	2	12	\N	12	-1	1	0	1	2	f	0	\N
289	18	30	2	6	\N	6	-1	1	0	1	2	f	0	\N
290	32	30	2	4	\N	4	-1	1	0	1	2	f	0	\N
291	49	30	2	4	\N	4	-1	1	0	1	2	f	0	\N
292	29	30	2	4	\N	4	-1	1	0	1	2	f	0	\N
293	35	30	2	4	\N	4	-1	1	0	1	2	f	0	\N
294	42	30	2	4	\N	4	-1	1	0	1	2	f	0	\N
295	30	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
296	1	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
297	16	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
298	44	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
299	31	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
300	17	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
301	25	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
302	8	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
303	9	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
304	15	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
305	27	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
306	36	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
307	10	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
308	50	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
309	4	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
310	37	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
311	51	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
312	11	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
313	21	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
314	33	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
315	5	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
316	12	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
317	28	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
318	40	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
319	41	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
320	22	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
321	45	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
322	47	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
323	13	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
324	23	30	2	2	\N	2	-1	1	0	1	2	f	0	\N
325	34	30	1	87	\N	87	-1	1	1	1	2	f	\N	\N
326	20	31	2	228	\N	228	1	0	1	1	2	f	0	\N
327	3	31	1	212	\N	212	-1	0	1	1	2	f	\N	\N
328	24	31	1	16	\N	16	-1	0	2	1	2	f	\N	\N
329	38	32	2	44	\N	0	1	0	1	1	2	f	44	\N
330	3	33	2	195	\N	195	1	1	1	1	2	f	0	\N
331	24	33	2	22	\N	22	1	0	2	1	2	f	0	\N
332	24	33	1	217	\N	217	-1	0	1	1	2	f	\N	\N
333	38	34	2	87	\N	87	-1	0	1	1	2	f	0	\N
334	6	34	1	87	\N	87	1	1	1	1	2	f	\N	\N
335	19	34	1	38	\N	38	1	1	0	1	2	f	\N	\N
336	2	34	1	6	\N	6	1	1	0	1	2	f	\N	\N
337	18	34	1	3	\N	3	1	1	0	1	2	f	\N	\N
338	32	34	1	2	\N	2	1	1	0	1	2	f	\N	\N
339	49	34	1	2	\N	2	1	1	0	1	2	f	\N	\N
340	29	34	1	2	\N	2	1	1	0	1	2	f	\N	\N
341	35	34	1	2	\N	2	1	1	0	1	2	f	\N	\N
342	42	34	1	2	\N	2	1	1	0	1	2	f	\N	\N
343	30	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
344	1	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
345	16	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
346	44	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
347	31	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
348	17	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
349	25	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
350	8	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
351	9	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
352	15	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
353	27	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
354	36	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
355	10	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
356	50	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
357	4	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
358	37	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
359	51	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
360	11	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
361	21	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
362	33	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
363	5	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
364	12	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
365	28	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
366	40	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
367	41	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
368	22	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
369	45	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
370	47	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
371	13	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
372	23	34	1	1	\N	1	1	1	0	1	2	f	\N	\N
373	19	35	2	5	\N	0	-1	0	1	1	2	f	5	\N
374	6	35	2	5	\N	0	-1	0	0	1	2	f	5	\N
375	20	36	2	254	\N	0	-1	0	1	1	2	f	254	\N
376	7	37	2	34	\N	34	-1	1	1	1	2	f	0	\N
377	48	37	2	32	\N	32	-1	1	2	1	2	f	0	\N
378	24	37	1	42	\N	42	-1	0	1	1	2	f	\N	\N
379	3	37	1	24	\N	24	-1	0	2	1	2	f	\N	\N
380	39	38	2	35	\N	0	1	0	1	1	2	f	35	\N
381	43	39	2	11809	\N	0	-1	0	1	1	2	f	11809	\N
382	46	40	2	38	\N	0	1	0	1	1	2	f	38	\N
383	39	40	2	29	\N	0	1	0	2	1	2	f	29	\N
384	6	41	2	43	\N	0	1	0	1	1	2	f	43	\N
385	19	41	2	26	\N	0	1	0	0	1	2	f	26	\N
386	2	41	2	3	\N	0	1	0	0	1	2	f	3	\N
387	49	41	2	2	\N	0	1	1	0	1	2	f	2	\N
388	16	41	2	1	\N	0	1	1	0	1	2	f	1	\N
389	25	41	2	1	\N	0	1	1	0	1	2	f	1	\N
390	18	41	2	1	\N	0	1	0	0	1	2	f	1	\N
391	9	41	2	1	\N	0	1	1	0	1	2	f	1	\N
392	36	41	2	1	\N	0	1	1	0	1	2	f	1	\N
393	10	41	2	1	\N	0	1	1	0	1	2	f	1	\N
394	21	41	2	1	\N	0	1	1	0	1	2	f	1	\N
395	22	41	2	1	\N	0	1	1	0	1	2	f	1	\N
396	29	41	2	1	\N	0	1	0	0	1	2	f	1	\N
397	35	41	2	1	\N	0	1	0	0	1	2	f	1	\N
398	23	41	2	1	\N	0	1	1	0	1	2	f	1	\N
399	42	41	2	1	\N	0	1	0	0	1	2	f	1	\N
400	26	42	2	345	\N	345	1	1	1	1	2	f	0	\N
401	20	42	2	249	\N	249	1	1	2	1	2	f	0	\N
402	43	42	2	198	\N	198	1	1	3	1	2	f	0	\N
403	3	42	2	195	\N	195	1	1	4	1	2	f	0	\N
404	14	42	2	62	\N	62	1	1	5	1	2	f	0	\N
405	24	42	2	41	\N	41	1	1	6	1	2	f	0	\N
406	6	42	2	38	\N	38	1	0	7	1	2	f	0	\N
407	7	42	2	29	\N	29	1	1	8	1	2	f	0	\N
408	48	42	2	7	\N	7	1	1	9	1	2	f	0	\N
409	19	42	2	24	\N	24	1	0	0	1	2	f	0	\N
410	2	42	2	2	\N	2	1	0	0	1	2	f	0	\N
411	16	42	2	1	\N	1	1	1	0	1	2	f	0	\N
412	31	42	2	1	\N	1	1	1	0	1	2	f	0	\N
413	8	42	2	1	\N	1	1	1	0	1	2	f	0	\N
414	18	42	2	1	\N	1	1	0	0	1	2	f	0	\N
415	32	42	2	1	\N	1	1	0	0	1	2	f	0	\N
416	37	42	2	1	\N	1	1	1	0	1	2	f	0	\N
417	51	42	2	1	\N	1	1	1	0	1	2	f	0	\N
418	41	42	2	1	\N	1	1	1	0	1	2	f	0	\N
419	29	42	2	1	\N	1	1	0	0	1	2	f	0	\N
420	35	42	2	1	\N	1	1	0	0	1	2	f	0	\N
421	23	42	2	1	\N	1	1	1	0	1	2	f	0	\N
422	42	42	2	1	\N	1	1	0	0	1	2	f	0	\N
423	26	42	1	345	\N	345	1	1	1	1	2	f	\N	\N
424	20	42	1	249	\N	249	1	1	2	1	2	f	\N	\N
425	43	42	1	198	\N	198	1	1	3	1	2	f	\N	\N
426	3	42	1	195	\N	195	1	1	4	1	2	f	\N	\N
427	14	42	1	62	\N	62	1	1	5	1	2	f	\N	\N
428	24	42	1	41	\N	41	1	1	6	1	2	f	\N	\N
429	7	42	1	29	\N	29	1	1	7	1	2	f	\N	\N
430	20	43	2	147	\N	147	-1	0	1	1	2	f	0	\N
431	6	43	2	16	\N	16	1	0	2	1	2	f	0	\N
432	48	43	2	9	\N	9	-1	1	3	1	2	f	0	\N
433	19	43	2	9	\N	9	1	0	0	1	2	f	0	\N
434	31	43	2	1	\N	1	1	1	0	1	2	f	0	\N
435	2	43	2	1	\N	1	1	0	0	1	2	f	0	\N
436	18	43	2	1	\N	1	1	0	0	1	2	f	0	\N
437	41	43	2	1	\N	1	1	1	0	1	2	f	0	\N
438	29	43	2	1	\N	1	1	0	0	1	2	f	0	\N
439	23	43	2	1	\N	1	1	1	0	1	2	f	0	\N
440	42	43	2	1	\N	1	1	0	0	1	2	f	0	\N
441	48	44	2	6	\N	0	-1	0	1	1	2	f	6	\N
442	38	45	2	48	\N	0	1	0	1	1	2	f	48	\N
443	48	46	2	57	\N	57	-1	1	1	1	2	f	0	\N
444	6	46	2	31	\N	31	-1	0	2	1	2	f	0	\N
445	19	46	2	25	\N	25	-1	0	0	1	2	f	0	\N
446	35	46	2	2	\N	2	-1	0	0	1	2	f	0	\N
447	27	46	2	1	\N	1	1	1	0	1	2	f	0	\N
448	36	46	2	1	\N	1	1	1	0	1	2	f	0	\N
449	5	46	2	1	\N	1	1	1	0	1	2	f	0	\N
450	42	46	2	1	\N	1	1	0	0	1	2	f	0	\N
451	39	46	1	88	\N	88	-1	1	1	1	2	f	\N	\N
452	26	47	2	345	\N	345	1	1	1	1	2	f	0	\N
453	43	47	2	256	\N	256	-1	1	2	1	2	f	0	\N
454	20	47	1	601	\N	601	-1	1	1	1	2	f	\N	\N
455	46	48	2	39	\N	0	1	1	1	1	2	f	39	\N
456	20	49	2	249	\N	0	1	1	1	1	2	f	249	\N
457	6	49	2	82	\N	0	1	0	2	1	2	f	82	\N
458	19	49	2	38	\N	0	1	1	0	1	2	f	38	\N
459	18	49	2	3	\N	0	1	1	0	1	2	f	3	\N
460	32	49	2	2	\N	0	1	1	0	1	2	f	2	\N
461	49	49	2	2	\N	0	1	1	0	1	2	f	2	\N
462	29	49	2	2	\N	0	1	1	0	1	2	f	2	\N
463	35	49	2	2	\N	0	1	1	0	1	2	f	2	\N
464	42	49	2	2	\N	0	1	1	0	1	2	f	2	\N
465	30	49	2	1	\N	0	1	1	0	1	2	f	1	\N
466	1	49	2	1	\N	0	1	1	0	1	2	f	1	\N
467	16	49	2	1	\N	0	1	1	0	1	2	f	1	\N
468	44	49	2	1	\N	0	1	1	0	1	2	f	1	\N
469	31	49	2	1	\N	0	1	1	0	1	2	f	1	\N
470	2	49	2	1	\N	0	1	0	0	1	2	f	1	\N
471	17	49	2	1	\N	0	1	1	0	1	2	f	1	\N
472	25	49	2	1	\N	0	1	1	0	1	2	f	1	\N
473	8	49	2	1	\N	0	1	1	0	1	2	f	1	\N
474	9	49	2	1	\N	0	1	1	0	1	2	f	1	\N
475	15	49	2	1	\N	0	1	1	0	1	2	f	1	\N
476	27	49	2	1	\N	0	1	1	0	1	2	f	1	\N
477	36	49	2	1	\N	0	1	1	0	1	2	f	1	\N
478	10	49	2	1	\N	0	1	1	0	1	2	f	1	\N
479	50	49	2	1	\N	0	1	1	0	1	2	f	1	\N
480	4	49	2	1	\N	0	1	1	0	1	2	f	1	\N
481	37	49	2	1	\N	0	1	1	0	1	2	f	1	\N
482	51	49	2	1	\N	0	1	1	0	1	2	f	1	\N
483	11	49	2	1	\N	0	1	1	0	1	2	f	1	\N
484	21	49	2	1	\N	0	1	1	0	1	2	f	1	\N
485	33	49	2	1	\N	0	1	1	0	1	2	f	1	\N
486	5	49	2	1	\N	0	1	1	0	1	2	f	1	\N
487	12	49	2	1	\N	0	1	1	0	1	2	f	1	\N
488	28	49	2	1	\N	0	1	1	0	1	2	f	1	\N
489	40	49	2	1	\N	0	1	1	0	1	2	f	1	\N
490	41	49	2	1	\N	0	1	1	0	1	2	f	1	\N
491	22	49	2	1	\N	0	1	1	0	1	2	f	1	\N
492	45	49	2	1	\N	0	1	1	0	1	2	f	1	\N
493	47	49	2	1	\N	0	1	1	0	1	2	f	1	\N
494	13	49	2	1	\N	0	1	1	0	1	2	f	1	\N
495	23	49	2	1	\N	0	1	1	0	1	2	f	1	\N
496	39	50	2	31	\N	0	1	0	1	1	2	f	31	\N
497	46	50	2	16	\N	0	1	0	2	1	2	f	16	\N
498	39	51	2	26	\N	0	1	0	1	1	2	f	26	\N
499	46	51	2	21	\N	0	1	0	2	1	2	f	21	\N
500	7	52	2	29	\N	0	1	1	1	1	2	f	29	\N
501	48	52	2	7	\N	0	1	1	2	1	2	f	7	\N
502	6	53	2	81	\N	0	1	0	1	1	2	f	81	\N
503	19	53	2	33	\N	0	1	0	0	1	2	f	33	\N
504	2	53	2	5	\N	0	1	0	0	1	2	f	5	\N
505	18	53	2	3	\N	0	1	1	0	1	2	f	3	\N
506	32	53	2	2	\N	0	1	1	0	1	2	f	2	\N
507	49	53	2	2	\N	0	1	1	0	1	2	f	2	\N
508	29	53	2	2	\N	0	1	1	0	1	2	f	2	\N
509	35	53	2	2	\N	0	1	1	0	1	2	f	2	\N
510	42	53	2	2	\N	0	1	1	0	1	2	f	2	\N
511	30	53	2	1	\N	0	1	1	0	1	2	f	1	\N
512	1	53	2	1	\N	0	1	1	0	1	2	f	1	\N
513	16	53	2	1	\N	0	1	1	0	1	2	f	1	\N
514	44	53	2	1	\N	0	1	1	0	1	2	f	1	\N
515	31	53	2	1	\N	0	1	1	0	1	2	f	1	\N
516	17	53	2	1	\N	0	1	1	0	1	2	f	1	\N
517	25	53	2	1	\N	0	1	1	0	1	2	f	1	\N
518	8	53	2	1	\N	0	1	1	0	1	2	f	1	\N
519	9	53	2	1	\N	0	1	1	0	1	2	f	1	\N
520	15	53	2	1	\N	0	1	1	0	1	2	f	1	\N
521	27	53	2	1	\N	0	1	1	0	1	2	f	1	\N
522	36	53	2	1	\N	0	1	1	0	1	2	f	1	\N
523	10	53	2	1	\N	0	1	1	0	1	2	f	1	\N
524	50	53	2	1	\N	0	1	1	0	1	2	f	1	\N
525	4	53	2	1	\N	0	1	1	0	1	2	f	1	\N
526	37	53	2	1	\N	0	1	1	0	1	2	f	1	\N
527	51	53	2	1	\N	0	1	1	0	1	2	f	1	\N
528	11	53	2	1	\N	0	1	1	0	1	2	f	1	\N
529	21	53	2	1	\N	0	1	1	0	1	2	f	1	\N
530	33	53	2	1	\N	0	1	1	0	1	2	f	1	\N
531	5	53	2	1	\N	0	1	1	0	1	2	f	1	\N
532	12	53	2	1	\N	0	1	1	0	1	2	f	1	\N
533	28	53	2	1	\N	0	1	1	0	1	2	f	1	\N
534	40	53	2	1	\N	0	1	1	0	1	2	f	1	\N
535	41	53	2	1	\N	0	1	1	0	1	2	f	1	\N
536	22	53	2	1	\N	0	1	1	0	1	2	f	1	\N
537	45	53	2	1	\N	0	1	1	0	1	2	f	1	\N
538	47	53	2	1	\N	0	1	1	0	1	2	f	1	\N
539	13	53	2	1	\N	0	1	1	0	1	2	f	1	\N
540	23	53	2	1	\N	0	1	1	0	1	2	f	1	\N
541	39	54	2	17	\N	0	1	0	1	1	2	f	17	\N
542	43	55	2	198	\N	0	1	1	1	1	2	f	198	\N
543	39	56	2	37	\N	0	1	1	1	1	2	f	37	\N
544	20	57	2	261	\N	261	-1	0	1	1	2	f	0	\N
545	24	57	1	261	\N	261	-1	0	1	1	2	f	\N	\N
546	3	58	2	17448	\N	0	-1	1	1	1	2	f	17448	\N
547	24	58	2	11388	\N	0	-1	1	2	1	2	f	11388	\N
548	20	58	2	10295	\N	0	-1	1	3	1	2	f	10295	\N
549	14	58	2	1909	\N	0	-1	1	4	1	2	f	1909	\N
550	6	58	2	1455	\N	0	-1	1	5	1	2	f	1455	\N
551	48	58	2	533	\N	0	-1	1	6	1	2	f	533	\N
552	38	58	2	61	\N	0	1	1	7	1	2	f	61	\N
553	46	58	2	39	\N	0	1	1	8	1	2	f	39	\N
554	34	58	2	38	\N	0	1	1	9	1	2	f	38	\N
555	39	58	2	37	\N	0	1	1	10	1	2	f	37	\N
556	19	58	2	916	\N	0	-1	1	0	1	2	f	916	\N
557	2	58	2	188	\N	0	-1	1	0	1	2	f	188	\N
558	23	58	2	57	\N	0	-1	1	0	1	2	f	57	\N
559	35	58	2	52	\N	0	-1	1	0	1	2	f	52	\N
560	42	58	2	51	\N	0	-1	1	0	1	2	f	51	\N
561	18	58	2	39	\N	0	-1	1	0	1	2	f	39	\N
562	16	58	2	28	\N	0	-1	1	0	1	2	f	28	\N
563	37	58	2	26	\N	0	-1	1	0	1	2	f	26	\N
564	41	58	2	26	\N	0	-1	1	0	1	2	f	26	\N
565	31	58	2	13	\N	0	-1	1	0	1	2	f	13	\N
566	29	58	2	11	\N	0	-1	1	0	1	2	f	11	\N
567	8	58	2	10	\N	0	-1	1	0	1	2	f	10	\N
568	32	58	2	7	\N	0	-1	1	0	1	2	f	7	\N
569	51	58	2	6	\N	0	-1	1	0	1	2	f	6	\N
570	49	58	2	2	\N	0	1	1	0	1	2	f	2	\N
571	30	58	2	1	\N	0	1	1	0	1	2	f	1	\N
572	1	58	2	1	\N	0	1	1	0	1	2	f	1	\N
573	44	58	2	1	\N	0	1	1	0	1	2	f	1	\N
574	17	58	2	1	\N	0	1	1	0	1	2	f	1	\N
575	25	58	2	1	\N	0	1	1	0	1	2	f	1	\N
576	9	58	2	1	\N	0	1	1	0	1	2	f	1	\N
577	15	58	2	1	\N	0	1	1	0	1	2	f	1	\N
578	27	58	2	1	\N	0	1	1	0	1	2	f	1	\N
579	36	58	2	1	\N	0	1	1	0	1	2	f	1	\N
580	10	58	2	1	\N	0	1	1	0	1	2	f	1	\N
581	50	58	2	1	\N	0	1	1	0	1	2	f	1	\N
582	4	58	2	1	\N	0	1	1	0	1	2	f	1	\N
583	11	58	2	1	\N	0	1	1	0	1	2	f	1	\N
584	21	58	2	1	\N	0	1	1	0	1	2	f	1	\N
585	33	58	2	1	\N	0	1	1	0	1	2	f	1	\N
586	5	58	2	1	\N	0	1	1	0	1	2	f	1	\N
587	12	58	2	1	\N	0	1	1	0	1	2	f	1	\N
588	28	58	2	1	\N	0	1	1	0	1	2	f	1	\N
589	40	58	2	1	\N	0	1	1	0	1	2	f	1	\N
590	22	58	2	1	\N	0	1	1	0	1	2	f	1	\N
591	45	58	2	1	\N	0	1	1	0	1	2	f	1	\N
592	47	58	2	1	\N	0	1	1	0	1	2	f	1	\N
593	13	58	2	1	\N	0	1	1	0	1	2	f	1	\N
594	6	59	2	87	\N	87	1	1	1	1	2	f	0	\N
595	19	59	2	38	\N	38	1	1	0	1	2	f	0	\N
596	2	59	2	6	\N	6	1	1	0	1	2	f	0	\N
597	18	59	2	3	\N	3	1	1	0	1	2	f	0	\N
598	32	59	2	2	\N	2	1	1	0	1	2	f	0	\N
599	49	59	2	2	\N	2	1	1	0	1	2	f	0	\N
600	29	59	2	2	\N	2	1	1	0	1	2	f	0	\N
601	35	59	2	2	\N	2	1	1	0	1	2	f	0	\N
602	42	59	2	2	\N	2	1	1	0	1	2	f	0	\N
603	30	59	2	1	\N	1	1	1	0	1	2	f	0	\N
604	1	59	2	1	\N	1	1	1	0	1	2	f	0	\N
605	16	59	2	1	\N	1	1	1	0	1	2	f	0	\N
606	44	59	2	1	\N	1	1	1	0	1	2	f	0	\N
607	31	59	2	1	\N	1	1	1	0	1	2	f	0	\N
608	17	59	2	1	\N	1	1	1	0	1	2	f	0	\N
609	25	59	2	1	\N	1	1	1	0	1	2	f	0	\N
610	8	59	2	1	\N	1	1	1	0	1	2	f	0	\N
611	9	59	2	1	\N	1	1	1	0	1	2	f	0	\N
612	15	59	2	1	\N	1	1	1	0	1	2	f	0	\N
613	27	59	2	1	\N	1	1	1	0	1	2	f	0	\N
614	36	59	2	1	\N	1	1	1	0	1	2	f	0	\N
615	10	59	2	1	\N	1	1	1	0	1	2	f	0	\N
616	50	59	2	1	\N	1	1	1	0	1	2	f	0	\N
617	4	59	2	1	\N	1	1	1	0	1	2	f	0	\N
618	37	59	2	1	\N	1	1	1	0	1	2	f	0	\N
619	51	59	2	1	\N	1	1	1	0	1	2	f	0	\N
620	11	59	2	1	\N	1	1	1	0	1	2	f	0	\N
621	21	59	2	1	\N	1	1	1	0	1	2	f	0	\N
622	33	59	2	1	\N	1	1	1	0	1	2	f	0	\N
623	5	59	2	1	\N	1	1	1	0	1	2	f	0	\N
624	12	59	2	1	\N	1	1	1	0	1	2	f	0	\N
625	28	59	2	1	\N	1	1	1	0	1	2	f	0	\N
626	40	59	2	1	\N	1	1	1	0	1	2	f	0	\N
627	41	59	2	1	\N	1	1	1	0	1	2	f	0	\N
628	22	59	2	1	\N	1	1	1	0	1	2	f	0	\N
629	45	59	2	1	\N	1	1	1	0	1	2	f	0	\N
630	47	59	2	1	\N	1	1	1	0	1	2	f	0	\N
631	13	59	2	1	\N	1	1	1	0	1	2	f	0	\N
632	23	59	2	1	\N	1	1	1	0	1	2	f	0	\N
633	38	59	1	87	\N	87	-1	0	1	1	2	f	\N	\N
634	34	60	2	37	\N	37	1	0	1	1	2	f	0	\N
635	48	60	2	34	\N	34	-1	1	2	1	2	f	0	\N
636	38	60	1	71	\N	71	-1	0	1	1	2	f	\N	\N
637	38	61	2	54	\N	0	1	0	1	1	2	f	54	\N
638	46	62	2	39	\N	0	1	1	1	1	2	f	39	\N
639	39	62	2	37	\N	0	1	1	2	1	2	f	37	\N
640	6	63	2	47	\N	0	-1	0	1	1	2	f	47	\N
641	34	63	2	18	\N	0	-1	0	2	1	2	f	18	\N
642	19	63	2	37	\N	0	-1	0	0	1	2	f	37	\N
643	49	63	2	2	\N	0	1	1	0	1	2	f	2	\N
644	35	63	2	2	\N	0	1	1	0	1	2	f	2	\N
645	16	63	2	1	\N	0	1	1	0	1	2	f	1	\N
646	31	63	2	1	\N	0	1	1	0	1	2	f	1	\N
647	25	63	2	1	\N	0	1	1	0	1	2	f	1	\N
648	41	63	2	1	\N	0	1	1	0	1	2	f	1	\N
649	23	63	2	1	\N	0	1	1	0	1	2	f	1	\N
650	42	63	2	1	\N	0	1	0	0	1	2	f	1	\N
651	34	64	2	17	\N	0	1	0	1	1	2	f	17	\N
652	48	65	2	7	\N	0	1	1	1	1	2	f	7	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index) FROM stdin;
1	84	14	198	\N	1
2	85	43	198	\N	1
3	86	46	49	\N	1
4	87	46	13	\N	1
5	88	46	9	\N	1
6	89	46	1	\N	1
7	90	46	1	\N	1
8	91	46	1	\N	1
9	92	46	1	\N	1
10	93	35	1	\N	0
11	93	42	1	\N	0
12	93	27	1	\N	0
13	93	6	13	\N	2
14	93	48	49	\N	1
15	93	31	1	\N	0
16	93	19	9	\N	0
17	166	42	1	\N	0
18	166	6	31	\N	1
19	166	5	1	\N	0
20	166	35	2	\N	0
21	166	19	25	\N	0
22	166	27	1	\N	0
23	166	36	1	\N	0
24	167	27	1	\N	0
25	167	6	13	\N	1
26	167	19	9	\N	0
27	167	42	1	\N	0
28	167	31	1	\N	0
29	167	35	1	\N	0
30	168	46	13	\N	2
31	168	39	31	\N	1
32	169	46	9	\N	2
33	169	39	25	\N	1
34	170	39	2	\N	1
35	170	46	1	\N	2
36	171	46	1	\N	2
37	171	39	1	\N	1
38	172	39	1	\N	1
39	172	46	1	\N	2
40	173	46	1	\N	1
41	174	39	1	\N	1
42	175	39	1	\N	1
43	178	48	345	\N	1
44	179	48	173	\N	1
45	180	48	77	\N	1
46	181	48	65	\N	1
47	182	48	57	\N	1
48	183	48	49	\N	1
49	184	48	34	\N	1
50	185	48	29	\N	1
51	186	48	81	\N	1
52	187	48	18	\N	1
53	188	48	6	\N	1
54	189	48	5	\N	1
55	190	48	4	\N	1
56	191	48	4	\N	1
57	192	48	3	\N	1
58	193	48	3	\N	1
59	194	48	3	\N	1
60	195	48	3	\N	1
61	196	48	3	\N	1
62	197	48	3	\N	1
63	198	48	3	\N	1
64	199	48	2	\N	1
65	200	48	2	\N	1
66	201	48	2	\N	1
67	202	48	2	\N	1
68	203	48	2	\N	1
69	204	48	2	\N	1
70	205	48	2	\N	1
71	206	48	2	\N	1
72	207	48	2	\N	1
73	208	48	1	\N	1
74	209	48	1	\N	1
75	210	48	1	\N	1
76	211	48	1	\N	1
77	212	48	1	\N	1
78	213	48	1	\N	1
79	214	48	1	\N	1
80	215	48	1	\N	1
81	216	48	1	\N	1
82	217	48	1	\N	1
83	218	48	1	\N	1
84	219	48	1	\N	1
85	220	48	1	\N	1
86	221	48	1	\N	1
87	222	48	1	\N	1
88	223	48	1	\N	1
89	224	22	1	\N	0
90	224	23	5	\N	0
91	224	5	1	\N	0
92	224	8	2	\N	0
93	224	49	3	\N	0
94	224	28	2	\N	0
95	224	27	1	\N	0
96	224	2	18	\N	0
97	224	39	57	\N	5
98	224	46	49	\N	6
99	224	12	2	\N	0
100	224	40	1	\N	0
101	224	19	81	\N	0
102	224	30	1	\N	0
103	224	44	2	\N	0
104	224	36	3	\N	0
105	224	11	1	\N	0
106	224	50	1	\N	0
107	224	45	2	\N	0
108	224	37	3	\N	0
109	224	31	1	\N	0
110	224	32	2	\N	0
111	224	38	34	\N	7
112	224	25	1	\N	0
113	224	4	3	\N	0
114	224	13	1	\N	0
115	224	43	65	\N	4
116	224	16	3	\N	0
117	224	6	173	\N	2
118	224	34	77	\N	3
119	224	18	4	\N	0
120	224	42	3	\N	0
121	224	10	2	\N	0
122	224	41	2	\N	0
123	224	9	3	\N	0
124	224	1	1	\N	0
125	224	7	29	\N	8
126	224	21	1	\N	0
127	224	35	6	\N	0
128	224	29	4	\N	0
129	224	17	1	\N	0
130	224	15	2	\N	0
131	224	47	1	\N	0
132	224	33	1	\N	0
133	224	26	345	\N	1
134	224	51	1	\N	0
135	228	11	1	\N	0
136	228	40	1	\N	0
137	228	45	2	\N	0
138	228	23	5	\N	0
139	228	30	1	\N	0
140	228	50	1	\N	0
141	228	1	1	\N	0
142	228	25	1	\N	0
143	228	51	1	\N	0
144	228	41	2	\N	0
145	228	22	1	\N	0
146	228	32	2	\N	0
147	228	37	3	\N	0
148	228	13	1	\N	0
149	228	6	173	\N	1
150	228	17	1	\N	0
151	228	5	1	\N	0
152	228	12	2	\N	0
153	228	8	2	\N	0
154	228	27	1	\N	0
155	228	49	3	\N	0
156	228	21	1	\N	0
157	228	47	1	\N	0
158	228	35	6	\N	0
159	228	36	3	\N	0
160	228	15	2	\N	0
161	228	10	2	\N	0
162	228	4	3	\N	0
163	228	33	1	\N	0
164	228	29	4	\N	0
165	228	18	4	\N	0
166	228	9	3	\N	0
167	228	28	2	\N	0
168	228	42	3	\N	0
169	228	2	18	\N	0
170	228	19	81	\N	0
171	228	16	3	\N	0
172	228	44	2	\N	0
173	228	31	1	\N	0
174	229	19	65	\N	0
175	229	37	3	\N	0
176	229	16	2	\N	0
177	229	31	1	\N	0
178	229	32	1	\N	0
179	229	51	1	\N	0
180	229	41	2	\N	0
181	229	35	5	\N	0
182	229	23	7	\N	0
183	229	18	2	\N	0
184	229	2	13	\N	0
185	229	42	2	\N	0
186	229	6	106	\N	1
187	229	8	1	\N	0
188	229	29	1	\N	0
189	230	44	1	\N	0
190	230	17	1	\N	0
191	230	4	1	\N	0
192	230	23	1	\N	0
193	230	18	3	\N	0
194	230	32	2	\N	0
195	230	16	1	\N	0
196	230	6	83	\N	1
197	230	27	1	\N	0
198	230	21	2	\N	0
199	230	33	1	\N	0
200	230	31	1	\N	0
201	230	19	35	\N	0
202	230	36	1	\N	0
203	230	40	1	\N	0
204	230	13	1	\N	0
205	230	2	5	\N	0
206	230	49	2	\N	0
207	230	37	1	\N	0
208	230	41	1	\N	0
209	230	22	1	\N	0
210	230	42	2	\N	0
211	230	1	1	\N	0
212	230	9	1	\N	0
213	230	10	1	\N	0
214	230	50	1	\N	0
215	230	29	2	\N	0
216	230	35	2	\N	0
217	230	30	1	\N	0
218	230	8	1	\N	0
219	230	15	1	\N	0
220	230	12	1	\N	0
221	230	25	1	\N	0
222	230	51	1	\N	0
223	230	28	1	\N	0
224	230	11	1	\N	0
225	230	5	1	\N	0
226	230	47	1	\N	0
227	231	34	83	\N	3
228	231	48	173	\N	1
229	231	26	106	\N	2
230	232	26	65	\N	2
231	232	34	35	\N	3
232	232	48	81	\N	1
233	233	34	5	\N	3
234	233	26	13	\N	2
235	233	48	18	\N	1
236	234	48	6	\N	1
237	234	26	5	\N	2
238	234	34	2	\N	3
239	235	48	5	\N	2
240	235	34	1	\N	3
241	235	26	7	\N	1
242	236	34	3	\N	2
243	236	26	2	\N	3
244	236	48	4	\N	1
245	237	26	3	\N	2
246	237	48	3	\N	1
247	237	34	1	\N	3
248	238	48	4	\N	1
249	238	34	2	\N	2
250	238	26	1	\N	3
251	239	34	2	\N	2
252	239	48	3	\N	1
253	239	26	2	\N	3
254	240	26	2	\N	2
255	240	34	1	\N	3
256	240	48	3	\N	1
257	241	34	2	\N	2
258	241	48	2	\N	1
259	241	26	1	\N	3
260	242	48	3	\N	1
261	242	34	2	\N	2
262	243	48	2	\N	1
263	243	26	2	\N	2
264	243	34	1	\N	3
265	244	48	2	\N	1
266	244	34	1	\N	2
267	244	26	1	\N	3
268	245	34	1	\N	2
269	245	48	3	\N	1
270	246	34	1	\N	2
271	246	48	3	\N	1
272	247	34	1	\N	2
273	247	48	3	\N	1
274	248	34	1	\N	2
275	248	48	2	\N	1
276	249	26	1	\N	3
277	249	34	1	\N	2
278	249	48	1	\N	1
279	250	48	2	\N	1
280	250	34	1	\N	2
281	251	48	2	\N	1
282	251	34	1	\N	2
283	252	48	1	\N	1
284	252	26	1	\N	3
285	252	34	1	\N	2
286	253	34	2	\N	1
287	253	48	1	\N	2
288	254	48	2	\N	1
289	254	34	1	\N	2
290	255	48	2	\N	1
291	255	34	1	\N	2
292	256	48	1	\N	1
293	256	34	1	\N	2
294	257	48	1	\N	1
295	257	34	1	\N	2
296	258	34	1	\N	2
297	258	48	1	\N	1
298	259	48	1	\N	1
299	259	34	1	\N	2
300	260	34	1	\N	2
301	260	48	1	\N	1
302	261	48	1	\N	1
303	261	34	1	\N	2
304	262	48	1	\N	1
305	262	34	1	\N	2
306	263	34	1	\N	2
307	263	48	1	\N	1
308	264	48	1	\N	1
309	264	34	1	\N	2
310	265	48	1	\N	1
311	265	34	1	\N	2
312	266	48	1	\N	1
313	266	34	1	\N	2
314	267	48	2	\N	1
315	268	48	1	\N	1
316	268	34	1	\N	2
317	269	48	1	\N	1
318	269	34	1	\N	2
319	270	24	3	\N	2
320	270	3	48	\N	1
321	271	20	48	\N	1
322	272	20	3	\N	1
323	278	34	87	\N	1
324	287	34	38	\N	1
325	288	34	6	\N	1
326	289	34	3	\N	1
327	290	34	2	\N	1
328	291	34	2	\N	1
329	292	34	2	\N	1
330	293	34	2	\N	1
331	294	34	2	\N	1
332	295	34	1	\N	1
333	296	34	1	\N	1
334	297	34	1	\N	1
335	298	34	1	\N	1
336	299	34	1	\N	1
337	300	34	1	\N	1
338	301	34	1	\N	1
339	302	34	1	\N	1
340	303	34	1	\N	1
341	304	34	1	\N	1
342	305	34	1	\N	1
343	306	34	1	\N	1
344	307	34	1	\N	1
345	308	34	1	\N	1
346	309	34	1	\N	1
347	310	34	1	\N	1
348	311	34	1	\N	1
349	312	34	1	\N	1
350	313	34	1	\N	1
351	314	34	1	\N	1
352	315	34	1	\N	1
353	316	34	1	\N	1
354	317	34	1	\N	1
355	318	34	1	\N	1
356	319	34	1	\N	1
357	320	34	1	\N	1
358	321	34	1	\N	1
359	322	34	1	\N	1
360	323	34	1	\N	1
361	324	34	1	\N	1
362	325	33	1	\N	0
363	325	36	1	\N	0
364	325	11	1	\N	0
365	325	30	1	\N	0
366	325	32	2	\N	0
367	325	21	1	\N	0
368	325	40	1	\N	0
369	325	1	1	\N	0
370	325	17	1	\N	0
371	325	18	3	\N	0
372	325	37	1	\N	0
373	325	12	1	\N	0
374	325	22	1	\N	0
375	325	6	87	\N	1
376	325	2	6	\N	0
377	325	15	1	\N	0
378	325	28	1	\N	0
379	325	27	1	\N	0
380	325	5	1	\N	0
381	325	29	2	\N	0
382	325	45	1	\N	0
383	325	47	1	\N	0
384	325	35	2	\N	0
385	325	19	38	\N	0
386	325	44	1	\N	0
387	325	31	1	\N	0
388	325	50	1	\N	0
389	325	4	1	\N	0
390	325	23	1	\N	0
391	325	25	1	\N	0
392	325	10	1	\N	0
393	325	41	1	\N	0
394	325	13	1	\N	0
395	325	16	1	\N	0
396	325	8	1	\N	0
397	325	9	1	\N	0
398	325	49	2	\N	0
399	325	51	1	\N	0
400	325	42	2	\N	0
401	326	24	16	\N	2
402	326	3	212	\N	1
403	327	20	212	\N	1
404	328	20	16	\N	1
405	330	24	195	\N	1
406	331	24	22	\N	1
407	332	24	22	\N	2
408	332	3	195	\N	1
409	333	30	1	\N	0
410	333	6	87	\N	1
411	333	1	1	\N	0
412	333	17	1	\N	0
413	333	25	1	\N	0
414	333	33	1	\N	0
415	333	31	1	\N	0
416	333	8	1	\N	0
417	333	11	1	\N	0
418	333	35	2	\N	0
419	333	2	6	\N	0
420	333	50	1	\N	0
421	333	5	1	\N	0
422	333	18	3	\N	0
423	333	27	1	\N	0
424	333	22	1	\N	0
425	333	15	1	\N	0
426	333	4	1	\N	0
427	333	13	1	\N	0
428	333	44	1	\N	0
429	333	19	38	\N	0
430	333	32	2	\N	0
431	333	49	2	\N	0
432	333	29	2	\N	0
433	333	45	1	\N	0
434	333	9	1	\N	0
435	333	37	1	\N	0
436	333	47	1	\N	0
437	333	23	1	\N	0
438	333	21	1	\N	0
439	333	16	1	\N	0
440	333	36	1	\N	0
441	333	10	1	\N	0
442	333	51	1	\N	0
443	333	28	1	\N	0
444	333	40	1	\N	0
445	333	12	1	\N	0
446	333	41	1	\N	0
447	333	42	2	\N	0
448	334	38	87	\N	1
449	335	38	38	\N	1
450	336	38	6	\N	1
451	337	38	3	\N	1
452	338	38	2	\N	1
453	339	38	2	\N	1
454	340	38	2	\N	1
455	341	38	2	\N	1
456	342	38	2	\N	1
457	343	38	1	\N	1
458	344	38	1	\N	1
459	345	38	1	\N	1
460	346	38	1	\N	1
461	347	38	1	\N	1
462	348	38	1	\N	1
463	349	38	1	\N	1
464	350	38	1	\N	1
465	351	38	1	\N	1
466	352	38	1	\N	1
467	353	38	1	\N	1
468	354	38	1	\N	1
469	355	38	1	\N	1
470	356	38	1	\N	1
471	357	38	1	\N	1
472	358	38	1	\N	1
473	359	38	1	\N	1
474	360	38	1	\N	1
475	361	38	1	\N	1
476	362	38	1	\N	1
477	363	38	1	\N	1
478	364	38	1	\N	1
479	365	38	1	\N	1
480	366	38	1	\N	1
481	367	38	1	\N	1
482	368	38	1	\N	1
483	369	38	1	\N	1
484	370	38	1	\N	1
485	371	38	1	\N	1
486	372	38	1	\N	1
487	376	24	32	\N	1
488	376	3	2	\N	2
489	377	3	22	\N	1
490	377	24	10	\N	2
491	378	7	32	\N	1
492	378	48	10	\N	2
493	379	48	22	\N	1
494	379	7	2	\N	2
495	400	26	345	\N	1
496	401	20	249	\N	1
497	402	43	198	\N	1
498	403	3	195	\N	1
499	404	14	62	\N	1
500	405	24	41	\N	1
501	407	7	29	\N	1
502	423	26	345	\N	1
503	424	20	249	\N	1
504	425	43	198	\N	1
505	426	3	195	\N	1
506	427	14	62	\N	1
507	428	24	41	\N	1
508	429	7	29	\N	1
509	443	39	57	\N	1
510	444	39	31	\N	1
511	445	39	25	\N	1
512	446	39	2	\N	1
513	447	39	1	\N	1
514	448	39	1	\N	1
515	449	39	1	\N	1
516	450	39	1	\N	1
517	451	42	1	\N	0
518	451	19	25	\N	0
519	451	27	1	\N	0
520	451	35	2	\N	0
521	451	6	31	\N	2
522	451	5	1	\N	0
523	451	36	1	\N	0
524	451	48	57	\N	1
525	452	20	345	\N	1
526	453	20	256	\N	1
527	454	43	256	\N	2
528	454	26	345	\N	1
529	544	24	261	\N	1
530	545	20	261	\N	1
531	594	38	87	\N	1
532	595	38	38	\N	1
533	596	38	6	\N	1
534	597	38	3	\N	1
535	598	38	2	\N	1
536	599	38	2	\N	1
537	600	38	2	\N	1
538	601	38	2	\N	1
539	602	38	2	\N	1
540	603	38	1	\N	1
541	604	38	1	\N	1
542	605	38	1	\N	1
543	606	38	1	\N	1
544	607	38	1	\N	1
545	608	38	1	\N	1
546	609	38	1	\N	1
547	610	38	1	\N	1
548	611	38	1	\N	1
549	612	38	1	\N	1
550	613	38	1	\N	1
551	614	38	1	\N	1
552	615	38	1	\N	1
553	616	38	1	\N	1
554	617	38	1	\N	1
555	618	38	1	\N	1
556	619	38	1	\N	1
557	620	38	1	\N	1
558	621	38	1	\N	1
559	622	38	1	\N	1
560	623	38	1	\N	1
561	624	38	1	\N	1
562	625	38	1	\N	1
563	626	38	1	\N	1
564	627	38	1	\N	1
565	628	38	1	\N	1
566	629	38	1	\N	1
567	630	38	1	\N	1
568	631	38	1	\N	1
569	632	38	1	\N	1
570	633	12	1	\N	0
571	633	2	6	\N	0
572	633	29	2	\N	0
573	633	15	1	\N	0
574	633	6	87	\N	1
575	633	19	38	\N	0
576	633	9	1	\N	0
577	633	17	1	\N	0
578	633	4	1	\N	0
579	633	31	1	\N	0
580	633	33	1	\N	0
581	633	27	1	\N	0
582	633	25	1	\N	0
583	633	13	1	\N	0
584	633	50	1	\N	0
585	633	32	2	\N	0
586	633	51	1	\N	0
587	633	36	1	\N	0
588	633	37	1	\N	0
589	633	23	1	\N	0
590	633	22	1	\N	0
591	633	41	1	\N	0
592	633	30	1	\N	0
593	633	47	1	\N	0
594	633	49	2	\N	0
595	633	21	1	\N	0
596	633	10	1	\N	0
597	633	18	3	\N	0
598	633	40	1	\N	0
599	633	28	1	\N	0
600	633	35	2	\N	0
601	633	16	1	\N	0
602	633	11	1	\N	0
603	633	45	1	\N	0
604	633	8	1	\N	0
605	633	5	1	\N	0
606	633	42	2	\N	0
607	633	44	1	\N	0
608	633	1	1	\N	0
609	634	38	37	\N	1
610	635	38	34	\N	1
611	636	48	34	\N	2
612	636	34	37	\N	1
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.cpd_rels (id, cp_rel_id, datatype_id, cnt, data) FROM stdin;
1	1	1	59	\N
2	2	1	22	\N
3	3	1	4	\N
4	4	1	2	\N
5	5	1	2	\N
6	6	1	2	\N
7	7	1	1	\N
8	8	1	1	\N
9	9	1	1	\N
10	10	1	1	\N
11	11	1	1	\N
12	12	1	1	\N
13	13	1	1	\N
14	14	1	1	\N
15	15	1	1	\N
16	16	1	1	\N
17	17	1	1	\N
18	18	1	1	\N
19	19	1	1	\N
20	20	1	1	\N
21	21	1	1	\N
22	22	1	1	\N
23	23	1	1	\N
24	24	1	1	\N
25	25	1	1	\N
26	26	1	1	\N
27	27	1	1	\N
28	28	1	1	\N
29	29	1	1	\N
30	30	1	1	\N
31	31	1	1	\N
32	32	1	1	\N
33	33	1	1	\N
34	34	2	7	\N
35	35	3	345	\N
36	36	2	31	\N
37	37	2	29	\N
38	38	2	43	\N
39	39	3	101	\N
40	40	3	88	\N
41	41	3	37	\N
42	42	3	8	\N
43	43	3	3	\N
44	44	3	3	\N
45	45	3	3	\N
46	46	3	3	\N
47	47	3	2	\N
48	48	3	2	\N
49	49	3	2	\N
50	50	3	2	\N
51	51	3	2	\N
52	52	3	2	\N
53	53	3	2	\N
54	54	3	2	\N
55	55	3	2	\N
56	56	3	2	\N
57	57	3	2	\N
58	58	3	2	\N
59	59	3	1	\N
60	60	3	1	\N
61	61	3	1	\N
62	62	3	1	\N
63	63	3	1	\N
64	64	3	1	\N
65	65	3	1	\N
66	66	3	1	\N
67	67	3	1	\N
68	68	3	1	\N
69	69	3	1	\N
70	70	3	1	\N
71	71	3	1	\N
72	72	3	1	\N
73	73	3	1	\N
74	74	3	1	\N
75	75	3	1	\N
76	76	3	1	\N
77	77	3	1	\N
78	78	3	1	\N
79	79	1	35	\N
80	80	2	48	\N
81	81	2	38	\N
82	82	2	33	\N
83	83	1	10	\N
84	94	2	39	\N
85	95	2	36	\N
86	97	3	86	\N
87	98	3	69	\N
88	99	3	37	\N
89	100	3	7	\N
90	101	3	3	\N
91	102	3	2	\N
92	103	3	2	\N
93	104	3	2	\N
94	105	3	2	\N
95	106	3	2	\N
96	107	3	2	\N
97	108	3	1	\N
98	109	3	1	\N
99	110	3	1	\N
100	111	3	1	\N
101	112	3	1	\N
102	113	3	1	\N
103	114	3	1	\N
104	115	3	1	\N
105	116	3	1	\N
106	117	3	1	\N
107	118	3	1	\N
108	119	3	1	\N
109	120	3	1	\N
110	121	3	1	\N
111	122	3	1	\N
112	123	3	1	\N
113	124	3	1	\N
114	125	3	1	\N
115	126	3	1	\N
116	127	3	1	\N
117	128	3	1	\N
118	129	3	1	\N
119	130	3	1	\N
120	131	3	1	\N
121	132	3	1	\N
122	133	3	1	\N
123	134	3	1	\N
124	135	3	6	\N
125	136	3	6	\N
126	137	1	38	\N
127	138	1	36	\N
128	139	4	3995	\N
129	140	3	33	\N
130	140	4	410	\N
131	141	3	6	\N
132	141	4	185	\N
133	142	3	11	\N
134	143	3	8	\N
135	144	3	6	\N
136	145	3	5	\N
137	146	3	21	\N
138	146	4	276	\N
139	147	3	3	\N
140	147	4	28	\N
141	148	3	1	\N
142	148	4	19	\N
143	149	3	1	\N
144	149	4	17	\N
145	150	3	1	\N
146	150	4	16	\N
147	151	3	1	\N
148	151	4	12	\N
149	152	3	1	\N
150	152	4	10	\N
151	153	4	8	\N
152	154	4	8	\N
153	155	4	5	\N
154	156	4	3	\N
155	157	4	3	\N
156	158	4	3	\N
157	159	4	2	\N
158	160	3	1	\N
159	161	3	1	\N
160	162	3	1	\N
161	163	3	1	\N
162	164	3	45	\N
163	165	1	1	\N
164	165	2	25	\N
165	176	3	38	\N
166	177	3	37	\N
167	225	3	36	\N
168	226	1	12	\N
169	227	3	198	\N
170	273	2	48	\N
171	329	2	44	\N
172	373	3	5	\N
173	374	3	5	\N
174	375	5	254	\N
175	380	1	35	\N
176	381	3	35	\N
177	381	4	11774	\N
178	382	2	38	\N
179	383	2	29	\N
180	384	3	43	\N
181	385	3	26	\N
182	386	3	3	\N
183	387	3	2	\N
184	388	3	1	\N
185	389	3	1	\N
186	390	3	1	\N
187	391	3	1	\N
188	392	3	1	\N
189	393	3	1	\N
190	394	3	1	\N
191	395	3	1	\N
192	396	3	1	\N
193	397	3	1	\N
194	398	3	1	\N
195	399	3	1	\N
196	441	1	6	\N
197	442	3	48	\N
198	455	3	39	\N
199	456	3	249	\N
200	457	3	82	\N
201	458	3	38	\N
202	459	3	3	\N
203	460	3	2	\N
204	461	3	2	\N
205	462	3	2	\N
206	463	3	2	\N
207	464	3	2	\N
208	465	3	1	\N
209	466	3	1	\N
210	467	3	1	\N
211	468	3	1	\N
212	469	3	1	\N
213	470	3	1	\N
214	471	3	1	\N
215	472	3	1	\N
216	473	3	1	\N
217	474	3	1	\N
218	475	3	1	\N
219	476	3	1	\N
220	477	3	1	\N
221	478	3	1	\N
222	479	3	1	\N
223	480	3	1	\N
224	481	3	1	\N
225	482	3	1	\N
226	483	3	1	\N
227	484	3	1	\N
228	485	3	1	\N
229	486	3	1	\N
230	487	3	1	\N
231	488	3	1	\N
232	489	3	1	\N
233	490	3	1	\N
234	491	3	1	\N
235	492	3	1	\N
236	493	3	1	\N
237	494	3	1	\N
238	495	3	1	\N
239	496	3	31	\N
240	497	3	16	\N
241	498	2	26	\N
242	499	2	21	\N
243	500	5	29	\N
244	501	5	7	\N
245	502	1	81	\N
246	503	1	33	\N
247	504	1	5	\N
248	505	1	3	\N
249	506	1	2	\N
250	507	1	2	\N
251	508	1	2	\N
252	509	1	2	\N
253	510	1	2	\N
254	511	1	1	\N
255	512	1	1	\N
256	513	1	1	\N
257	514	1	1	\N
258	515	1	1	\N
259	516	1	1	\N
260	517	1	1	\N
261	518	1	1	\N
262	519	1	1	\N
263	520	1	1	\N
264	521	1	1	\N
265	522	1	1	\N
266	523	1	1	\N
267	524	1	1	\N
268	525	1	1	\N
269	526	1	1	\N
270	527	1	1	\N
271	528	1	1	\N
272	529	1	1	\N
273	530	1	1	\N
274	531	1	1	\N
275	532	1	1	\N
276	533	1	1	\N
277	534	1	1	\N
278	535	1	1	\N
279	536	1	1	\N
280	537	1	1	\N
281	538	1	1	\N
282	539	1	1	\N
283	540	1	1	\N
284	541	2	17	\N
285	542	5	198	\N
286	543	3	37	\N
287	546	4	17448	\N
288	547	4	11388	\N
289	548	4	10295	\N
290	549	4	1909	\N
291	550	3	87	\N
292	550	4	1368	\N
293	551	3	7	\N
294	551	4	526	\N
295	552	3	61	\N
296	553	3	39	\N
297	554	3	38	\N
298	555	3	37	\N
299	556	3	38	\N
300	556	4	878	\N
301	557	3	6	\N
302	557	4	182	\N
303	558	3	1	\N
304	558	4	56	\N
305	559	3	2	\N
306	559	4	50	\N
307	560	3	2	\N
308	560	4	49	\N
309	561	3	3	\N
310	561	4	36	\N
311	562	3	1	\N
312	562	4	27	\N
313	563	3	1	\N
314	563	4	25	\N
315	564	3	1	\N
316	564	4	25	\N
317	565	3	1	\N
318	565	4	12	\N
319	566	3	2	\N
320	566	4	9	\N
321	567	3	1	\N
322	567	4	9	\N
323	568	3	2	\N
324	568	4	5	\N
325	569	3	1	\N
326	569	4	5	\N
327	570	3	2	\N
328	571	3	1	\N
329	572	3	1	\N
330	573	3	1	\N
331	574	3	1	\N
332	575	3	1	\N
333	576	3	1	\N
334	577	3	1	\N
335	578	3	1	\N
336	579	3	1	\N
337	580	3	1	\N
338	581	3	1	\N
339	582	3	1	\N
340	583	3	1	\N
341	584	3	1	\N
342	585	3	1	\N
343	586	3	1	\N
344	587	3	1	\N
345	588	3	1	\N
346	589	3	1	\N
347	590	3	1	\N
348	591	3	1	\N
349	592	3	1	\N
350	593	3	1	\N
351	637	3	54	\N
352	638	3	39	\N
353	639	3	37	\N
354	640	3	47	\N
355	641	3	18	\N
356	642	3	37	\N
357	643	3	2	\N
358	644	3	2	\N
359	645	3	1	\N
360	646	3	1	\N
361	647	3	1	\N
362	648	3	1	\N
363	649	3	1	\N
364	650	3	1	\N
365	651	3	17	\N
366	652	3	7	\N
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.datatypes (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2001/XMLSchema#decimal	3	decimal
2	http://www.w3.org/2001/XMLSchema#integer	3	integer
3	http://www.w3.org/2001/XMLSchema#string	3	string
4	http://www.w3.org/1999/02/22-rdf-syntax-ns#langString	1	langString
5	http://www.w3.org/2001/XMLSchema#date	3	date
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
1	rdf	http://www.w3.org/1999/02/22-rdf-syntax-ns#	0	f	0
2	rdfs	http://www.w3.org/2000/01/rdf-schema#	0	f	0
3	xsd	http://www.w3.org/2001/XMLSchema#	0	f	0
4	skos	http://www.w3.org/2004/02/skos/core#	0	f	0
5	dct	http://purl.org/dc/terms/	0	f	0
6	dc	http://purl.org/dc/elements/1.1/	0	f	0
7	owl	http://www.w3.org/2002/07/owl#	0	f	0
8	foaf	http://xmlns.com/foaf/0.1/	0	f	0
9	schema	http://schema.org/	0	f	0
10	dbo	http://dbpedia.org/ontology/	0	f	0
11	yago	http://dbpedia.org/class/yago/	0	f	0
12	wd	http://www.wikidata.org/entity/	0	f	0
13	wdt	http://www.wikidata.org/prop/direct/	0	f	0
14	shacl	http://www.w3.org/ns/shacl#	0	f	0
15	dcat	http://www.w3.org/ns/dcat#	0	f	0
16	void	http://rdfs.org/ns/void#	0	f	0
17	virtrdf	http://www.openlinksw.com/schemas/virtrdf#	0	f	0
18	dav	http://www.openlinksw.com/schemas/DAV#	0	f	0
19	dbp	http://dbpedia.org/property/	0	f	0
20	dbr	http://dbpedia.org/resource/	0	f	0
21	dbt	http://dbpedia.org/resource/Template:	0	f	0
22	dbc	http://dbpedia.org/resource/Category:	0	f	0
23	cc	http://creativecommons.org/ns#	0	f	0
24	vann	http://purl.org/vocab/vann/	0	f	0
25	geo	http://www.w3.org/2003/01/geo/wgs84_pos#	0	f	0
26	prov	http://www.w3.org/ns/prov#	0	f	0
27	sd	http://www.w3.org/ns/sparql-service-description#	0	f	0
28	frbr	http://vocab.org/frbr/core#	0	f	0
29	georss	http://www.georss.org/georss/	0	f	0
30	gold	http://purl.org/linguistics/gold/	0	f	0
31	bibo	http://purl.org/ontology/bibo/	0	f	0
32	umbel	http://umbel.org/umbel#	0	f	0
33	umbel-rc	http://umbel.org/umbel/rc/	0	f	0
34	dul	http://www.ontologydesignpatterns.org/ont/dul/DUL.owl#	0	f	0
35	voaf	http://purl.org/vocommons/voaf#	0	f	0
36	gr	http://purl.org/goodrelations/v1#	0	f	0
37	org	http://www.w3.org/ns/org#	0	f	0
38	sioc	http://rdfs.org/sioc/ns#	0	f	0
39	vcard	http://www.w3.org/2006/vcard/ns#	0	f	0
40	obo	http://purl.obolibrary.org/obo/	0	f	0
68		https://swapi.co/vocabulary/	0	t	0
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
210	instance_name_pattern	\N	\N	Default pattern for instance name presentation in visual query fields. Work in progress. Can be overriden on individual class level. Leave empty to present instances by their URIs.	10
330	use_instance_table	\N	\N	Mark, if a dedicated instance table is installed within the data schema (requires a custom solution).	8
230	instance_lookup_mode	\N	\N	table - use instances table, default - use data endpoint	19
250	direct_class_role	\N	\N	Default property to be used for instance-to-class relationship. Leave empty in the most typical case of the property being rdf:type.	5
260	indirect_class_role	\N	\N	Fill in, if an indirect class membership is to be used in the environment, along with the direct membership (normally leave empty).	6
100	tree_profile_name	\N	\N	Look up public tree profile by this name (mutually exclusive with local tree_profile).	14
110	tree_profile	\N	\N	A custom configuration of the entity lookup pane tree (copy the initial value from the parameters of a similar schema).	11
220	show_instance_tab	\N	\N	Show instance tab in the entity lookup pane in the visual environment.	15
10	display_name_default	StarWars	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	starwars	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
20	schema_description	Star Wars	\N	Description of the schema.	2
30	endpoint_url	http://85.254.199.72:8890/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
40	named_graph	http://starwars.org	\N	Default named graph for visual environment projects using this schema.	4
60	endpoint_public_url	http://85.254.199.72:8890/sparql	\N	Human readable web site of the endpoint, if available.	16
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	virtuoso	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"graphName": "http://starwars.org", "endpointUrl": "http://85.254.199.72:8890/sparql", "correlationId": "3466276589409364350", "enableLogging": true, "includedLabels": [], "includedClasses": [], "calculateDataTypes": true, "excludedNamespaces": [], "includedProperties": [], "checkInstanceNamespaces": false, "calculateClosedClassSets": false, "classificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateCardinalitiesMode": "propertyLevelAndClassContext", "calculateImportanceIndexes": true, "calculateSubClassRelations": true, "calculateSourceAndTargetPairs": true, "calculatePropertyPropertyRelations": true}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-02-02T15:41:02.498Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2023-11-03	\N	\N	33
240	use_pp_rels	\N	true	Use the property-property relationships from the data schema in the query auto-completion (the property-property relationships must be retrieved from the data and stored in the pp_rels table).	9
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.pd_rels (id, property_id, datatype_id, cnt, data) FROM stdin;
1	1	1	59	\N
2	2	2	7	\N
3	3	3	345	\N
4	4	2	60	\N
5	5	2	43	\N
6	6	3	189	\N
7	7	1	35	\N
8	8	2	48	\N
9	9	2	71	\N
10	10	1	10	\N
11	13	2	75	\N
12	15	3	155	\N
13	16	3	6	\N
14	17	1	74	\N
15	18	3	69	\N
16	18	4	4590	\N
17	19	3	45	\N
18	20	1	1	\N
19	20	2	25	\N
20	22	3	75	\N
21	24	3	36	\N
22	25	1	12	\N
23	26	3	198	\N
24	29	2	48	\N
25	32	2	44	\N
26	35	3	5	\N
27	36	5	254	\N
28	38	1	35	\N
29	39	3	35	\N
30	39	4	11774	\N
31	40	2	67	\N
32	41	3	43	\N
33	44	1	6	\N
34	45	3	48	\N
35	48	3	39	\N
36	49	3	331	\N
37	50	3	47	\N
38	51	2	47	\N
39	52	5	36	\N
40	53	1	81	\N
41	54	2	17	\N
42	55	5	198	\N
43	56	3	37	\N
44	58	3	269	\N
45	58	4	42934	\N
46	61	3	54	\N
47	62	3	76	\N
48	63	3	65	\N
49	64	3	17	\N
50	65	3	7	\N
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data) FROM stdin;
1	1	58	2	1173	\N
2	1	18	2	353	\N
3	1	23	2	137	\N
4	1	30	2	118	\N
5	1	6	2	72	\N
6	1	53	2	59	\N
7	1	59	2	59	\N
8	1	1	2	59	\N
9	1	15	2	58	\N
10	1	49	2	55	\N
11	1	41	2	36	\N
12	1	63	2	29	\N
13	1	46	2	28	\N
14	1	42	2	26	\N
15	1	43	2	13	\N
16	1	12	2	13	\N
17	1	35	2	5	\N
18	1	16	2	4	\N
19	2	58	2	533	\N
20	2	18	2	191	\N
21	2	27	2	173	\N
22	2	46	2	57	\N
23	2	12	2	49	\N
24	2	60	2	34	\N
25	2	37	2	32	\N
26	2	25	2	12	\N
27	2	10	2	10	\N
28	2	43	2	9	\N
29	2	30	2	7	\N
30	2	2	2	7	\N
31	2	65	2	7	\N
32	2	52	2	7	\N
33	2	42	2	7	\N
34	2	44	2	6	\N
35	3	30	2	345	\N
36	3	23	2	345	\N
37	3	47	2	345	\N
38	3	3	2	345	\N
39	3	42	2	345	\N
40	3	27	2	106	\N
41	4	23	2	89	\N
42	4	30	2	60	\N
43	4	58	2	60	\N
44	4	4	2	60	\N
45	4	13	2	60	\N
46	4	17	2	60	\N
47	4	22	2	60	\N
48	4	62	2	60	\N
49	4	9	2	59	\N
50	4	40	2	55	\N
51	4	50	2	44	\N
52	4	51	2	42	\N
53	4	21	2	37	\N
54	4	48	2	31	\N
55	4	38	2	29	\N
56	4	56	2	29	\N
57	4	54	2	16	\N
58	4	18	2	12	\N
59	5	34	2	63	\N
60	5	30	2	43	\N
61	5	58	2	43	\N
62	5	5	2	43	\N
63	5	61	2	43	\N
64	5	45	2	42	\N
65	5	8	2	42	\N
66	5	29	2	42	\N
67	5	32	2	39	\N
68	5	19	2	39	\N
69	5	23	2	29	\N
70	5	20	2	24	\N
71	5	18	2	8	\N
72	6	58	2	1647	\N
73	6	18	2	474	\N
74	6	6	2	429	\N
75	6	23	2	375	\N
76	6	15	2	298	\N
77	6	30	2	290	\N
78	6	27	2	245	\N
79	6	14	2	176	\N
80	6	59	2	101	\N
81	6	53	2	97	\N
82	6	49	2	95	\N
83	6	60	2	88	\N
84	6	63	2	87	\N
85	6	24	2	87	\N
86	6	7	2	85	\N
87	6	1	2	72	\N
88	6	41	2	44	\N
89	6	42	2	41	\N
90	6	64	2	40	\N
91	6	46	2	30	\N
92	6	43	2	19	\N
93	6	12	2	15	\N
94	6	16	2	8	\N
95	6	35	2	5	\N
96	7	6	2	85	\N
97	7	27	2	76	\N
98	7	14	2	70	\N
99	7	15	2	67	\N
100	7	23	2	66	\N
101	7	30	2	35	\N
102	7	58	2	35	\N
103	7	7	2	35	\N
104	7	24	2	35	\N
105	7	60	2	35	\N
106	7	63	2	18	\N
107	7	64	2	16	\N
108	7	18	2	4	\N
109	8	34	2	75	\N
110	8	30	2	48	\N
111	8	58	2	48	\N
112	8	8	2	48	\N
113	8	29	2	48	\N
114	8	61	2	46	\N
115	8	45	2	45	\N
116	8	32	2	43	\N
117	8	19	2	43	\N
118	8	5	2	42	\N
119	8	23	2	33	\N
120	8	20	2	25	\N
121	8	18	2	10	\N
122	9	23	2	101	\N
123	9	30	2	71	\N
124	9	58	2	71	\N
125	9	17	2	71	\N
126	9	22	2	71	\N
127	9	62	2	71	\N
128	9	9	2	71	\N
129	9	13	2	70	\N
130	9	40	2	65	\N
131	9	4	2	59	\N
132	9	50	2	46	\N
133	9	51	2	46	\N
134	9	21	2	41	\N
135	9	48	2	38	\N
136	9	56	2	33	\N
137	9	38	2	32	\N
138	9	54	2	17	\N
139	9	18	2	14	\N
140	10	58	2	782	\N
141	10	18	2	308	\N
142	10	27	2	206	\N
143	10	46	2	63	\N
144	10	37	2	53	\N
145	10	12	2	49	\N
146	10	60	2	37	\N
147	10	25	2	36	\N
148	10	10	2	22	\N
149	10	44	2	12	\N
150	10	43	2	12	\N
151	10	30	2	10	\N
152	10	2	2	10	\N
153	10	65	2	10	\N
154	10	52	2	10	\N
155	10	42	2	10	\N
156	11	58	1	10472	\N
157	11	30	1	198	\N
158	11	42	1	198	\N
159	11	11	3	3410	\N
160	11	42	3	198	\N
161	11	39	2	11809	\N
162	11	47	2	256	\N
163	11	30	2	198	\N
164	11	11	2	198	\N
165	11	55	2	198	\N
166	11	26	2	198	\N
167	11	42	2	198	\N
168	11	23	2	65	\N
169	12	23	1	85	\N
170	12	30	1	62	\N
171	12	58	1	62	\N
172	12	13	1	62	\N
173	12	62	1	62	\N
174	12	48	1	62	\N
175	12	17	1	61	\N
176	12	22	1	61	\N
177	12	40	1	61	\N
178	12	9	1	61	\N
179	12	4	1	51	\N
180	12	21	1	33	\N
181	12	51	1	28	\N
182	12	50	1	24	\N
183	12	18	1	11	\N
184	12	12	3	118	\N
185	12	58	2	4076	\N
186	12	27	2	1448	\N
187	12	18	2	1352	\N
188	12	46	2	492	\N
189	12	12	2	472	\N
190	12	60	2	321	\N
191	12	37	2	227	\N
192	12	43	2	77	\N
193	12	30	2	75	\N
194	12	42	2	59	\N
195	12	10	2	49	\N
196	12	2	2	49	\N
197	12	65	2	49	\N
198	12	52	2	49	\N
199	12	23	2	41	\N
200	12	44	2	28	\N
201	12	25	2	28	\N
202	12	6	2	15	\N
203	12	15	2	14	\N
204	12	49	2	13	\N
205	12	53	2	13	\N
206	12	59	2	13	\N
207	12	1	2	13	\N
208	12	63	2	12	\N
209	12	41	2	11	\N
210	12	35	2	4	\N
211	13	23	2	105	\N
212	13	30	2	75	\N
213	13	58	2	75	\N
214	13	13	2	75	\N
215	13	62	2	75	\N
216	13	22	2	74	\N
217	13	17	2	73	\N
218	13	9	2	70	\N
219	13	40	2	67	\N
220	13	4	2	60	\N
221	13	50	2	47	\N
222	13	51	2	47	\N
223	13	21	2	44	\N
224	13	48	2	39	\N
225	13	56	2	36	\N
226	13	38	2	35	\N
227	13	54	2	17	\N
228	13	18	2	14	\N
229	14	14	3	1856	\N
230	14	6	2	176	\N
231	14	27	2	166	\N
232	14	23	2	154	\N
233	14	14	2	152	\N
234	14	15	2	138	\N
235	14	30	2	76	\N
236	14	58	2	76	\N
237	14	60	2	74	\N
238	14	24	2	72	\N
239	14	7	2	70	\N
240	14	63	2	36	\N
241	14	64	2	34	\N
242	14	18	2	10	\N
243	15	58	2	1523	\N
244	15	18	2	459	\N
245	15	23	2	355	\N
246	15	15	2	315	\N
247	15	6	2	298	\N
248	15	27	2	294	\N
249	15	30	2	241	\N
250	15	14	2	138	\N
251	15	63	2	113	\N
252	15	59	2	86	\N
253	15	49	2	81	\N
254	15	53	2	81	\N
255	15	60	2	69	\N
256	15	7	2	67	\N
257	15	24	2	67	\N
258	15	1	2	58	\N
259	15	41	2	43	\N
260	15	42	2	38	\N
261	15	64	2	34	\N
262	15	46	2	32	\N
263	15	43	2	16	\N
264	15	12	2	14	\N
265	15	16	2	7	\N
266	15	35	2	5	\N
267	16	58	2	188	\N
268	16	18	2	31	\N
269	16	23	2	18	\N
270	16	30	2	12	\N
271	16	6	2	8	\N
272	16	15	2	7	\N
273	16	16	2	6	\N
274	16	59	2	6	\N
275	16	53	2	5	\N
276	16	1	2	4	\N
277	16	41	2	3	\N
278	16	42	2	2	\N
279	16	49	2	1	\N
280	16	43	2	1	\N
281	17	23	2	104	\N
282	17	30	2	74	\N
283	17	58	2	74	\N
284	17	17	2	74	\N
285	17	22	2	74	\N
286	17	62	2	74	\N
287	17	13	2	73	\N
288	17	9	2	71	\N
289	17	40	2	67	\N
290	17	4	2	60	\N
291	17	50	2	47	\N
292	17	51	2	47	\N
293	17	21	2	43	\N
294	17	48	2	38	\N
295	17	56	2	36	\N
296	17	38	2	35	\N
297	17	54	2	17	\N
298	17	18	2	14	\N
299	18	58	2	231127	\N
300	18	18	2	93805	\N
301	18	30	2	5102	\N
302	18	42	2	4618	\N
303	18	27	2	4531	\N
304	18	49	2	4407	\N
305	18	57	2	4321	\N
306	18	36	2	4082	\N
307	18	31	2	3844	\N
308	18	43	2	3364	\N
309	18	46	2	1829	\N
310	18	23	2	1461	\N
311	18	12	2	1352	\N
312	18	28	2	1066	\N
313	18	37	2	890	\N
314	18	60	2	842	\N
315	18	6	2	474	\N
316	18	15	2	459	\N
317	18	59	2	443	\N
318	18	25	2	418	\N
319	18	53	2	402	\N
320	18	41	2	358	\N
321	18	1	2	353	\N
322	18	63	2	344	\N
323	18	10	2	308	\N
324	18	2	2	191	\N
325	18	65	2	191	\N
326	18	52	2	191	\N
327	18	44	2	184	\N
328	18	35	2	123	\N
329	18	16	2	31	\N
330	18	34	2	31	\N
331	18	13	2	14	\N
332	18	17	2	14	\N
333	18	22	2	14	\N
334	18	62	2	14	\N
335	18	9	2	14	\N
336	18	4	2	12	\N
337	18	40	2	12	\N
338	18	50	2	11	\N
339	18	61	2	11	\N
340	18	14	2	10	\N
341	18	45	2	10	\N
342	18	51	2	10	\N
343	18	32	2	10	\N
344	18	19	2	10	\N
345	18	8	2	10	\N
346	18	21	2	10	\N
347	18	29	2	10	\N
348	18	20	2	9	\N
349	18	38	2	8	\N
350	18	5	2	8	\N
351	18	56	2	8	\N
352	18	54	2	7	\N
353	18	48	2	6	\N
354	18	7	2	4	\N
355	18	64	2	4	\N
356	18	24	2	4	\N
357	19	34	2	64	\N
358	19	30	2	45	\N
359	19	58	2	45	\N
360	19	45	2	45	\N
361	19	19	2	45	\N
362	19	61	2	44	\N
363	19	8	2	43	\N
364	19	29	2	43	\N
365	19	32	2	40	\N
366	19	5	2	39	\N
367	19	23	2	32	\N
368	19	20	2	24	\N
369	19	18	2	10	\N
370	20	34	2	46	\N
371	20	30	2	26	\N
372	20	58	2	26	\N
373	20	45	2	26	\N
374	20	20	2	26	\N
375	20	61	2	26	\N
376	20	23	2	25	\N
377	20	8	2	25	\N
378	20	29	2	25	\N
379	20	32	2	24	\N
380	20	19	2	24	\N
381	20	5	2	24	\N
382	20	18	2	9	\N
383	21	58	1	1727	\N
384	21	18	1	553	\N
385	21	23	1	141	\N
386	21	46	1	89	\N
387	21	30	1	88	\N
388	21	15	1	46	\N
389	21	6	1	45	\N
390	21	49	1	44	\N
391	21	59	1	44	\N
392	21	63	1	43	\N
393	21	53	1	42	\N
394	21	1	1	41	\N
395	21	12	1	37	\N
396	21	41	1	35	\N
397	21	42	1	33	\N
398	21	43	1	19	\N
399	21	35	1	12	\N
400	21	27	3	312	\N
401	21	21	3	126	\N
402	21	34	3	44	\N
403	21	21	2	96	\N
404	21	23	2	74	\N
405	21	30	2	44	\N
406	21	58	2	44	\N
407	21	13	2	44	\N
408	21	22	2	44	\N
409	21	62	2	44	\N
410	21	17	2	43	\N
411	21	40	2	43	\N
412	21	9	2	41	\N
413	21	4	2	37	\N
414	21	56	2	31	\N
415	21	51	2	30	\N
416	21	38	2	30	\N
417	21	50	2	28	\N
418	21	54	2	14	\N
419	21	48	2	13	\N
420	21	18	2	10	\N
421	22	23	2	105	\N
422	22	30	2	75	\N
423	22	58	2	75	\N
424	22	22	2	75	\N
425	22	62	2	75	\N
426	22	13	2	74	\N
427	22	17	2	74	\N
428	22	9	2	71	\N
429	22	40	2	67	\N
430	22	4	2	60	\N
431	22	50	2	47	\N
432	22	51	2	47	\N
433	22	21	2	44	\N
434	22	48	2	38	\N
435	22	56	2	37	\N
436	22	38	2	35	\N
437	22	54	2	17	\N
438	22	18	2	14	\N
439	23	58	1	62688	\N
440	23	18	1	22337	\N
441	23	27	1	21408	\N
442	23	46	1	6901	\N
443	23	12	1	6137	\N
444	23	60	1	4300	\N
445	23	37	1	3879	\N
446	23	25	1	1285	\N
447	23	10	1	1135	\N
448	23	43	1	1089	\N
449	23	30	1	829	\N
450	23	2	1	829	\N
451	23	65	1	829	\N
452	23	52	1	829	\N
453	23	42	1	829	\N
454	23	44	1	673	\N
455	23	23	3	99719	\N
456	23	39	2	5134	\N
457	23	58	2	5046	\N
458	23	23	2	1467	\N
459	23	18	2	1461	\N
460	23	30	2	1002	\N
461	23	42	2	536	\N
462	23	47	2	468	\N
463	23	27	2	466	\N
464	23	6	2	375	\N
465	23	15	2	355	\N
466	23	3	2	345	\N
467	23	59	2	173	\N
468	23	63	2	170	\N
469	23	53	2	167	\N
470	23	49	2	157	\N
471	23	14	2	154	\N
472	23	1	2	137	\N
473	23	34	2	122	\N
474	23	41	2	115	\N
475	23	62	2	106	\N
476	23	13	2	105	\N
477	23	22	2	105	\N
478	23	17	2	104	\N
479	23	9	2	101	\N
480	23	46	2	100	\N
481	23	40	2	94	\N
482	23	4	2	89	\N
483	23	21	2	74	\N
484	23	50	2	73	\N
485	23	60	2	70	\N
486	23	24	2	68	\N
487	23	7	2	66	\N
488	23	11	2	65	\N
489	23	55	2	65	\N
490	23	26	2	65	\N
491	23	51	2	64	\N
492	23	56	2	57	\N
493	23	38	2	55	\N
494	23	48	2	49	\N
495	23	43	2	47	\N
496	23	64	2	44	\N
497	23	12	2	41	\N
498	23	37	2	34	\N
499	23	61	2	34	\N
500	23	45	2	33	\N
501	23	32	2	33	\N
502	23	54	2	33	\N
503	23	8	2	33	\N
504	23	29	2	33	\N
505	23	19	2	32	\N
506	23	5	2	29	\N
507	23	52	2	29	\N
508	23	20	2	25	\N
509	23	35	2	20	\N
510	23	16	2	18	\N
511	24	6	2	87	\N
512	24	27	2	77	\N
513	24	14	2	72	\N
514	24	23	2	68	\N
515	24	15	2	67	\N
516	24	30	2	36	\N
517	24	58	2	36	\N
518	24	24	2	36	\N
519	24	60	2	36	\N
520	24	7	2	35	\N
521	24	63	2	18	\N
522	24	64	2	16	\N
523	24	18	2	4	\N
524	25	58	2	971	\N
525	25	18	2	418	\N
526	25	27	2	196	\N
527	25	37	2	73	\N
528	25	25	2	68	\N
529	25	46	2	47	\N
530	25	10	2	36	\N
531	25	12	2	28	\N
532	25	60	2	23	\N
533	25	44	2	20	\N
534	25	43	2	14	\N
535	25	30	2	12	\N
536	25	2	2	12	\N
537	25	65	2	12	\N
538	25	52	2	12	\N
539	25	42	2	12	\N
540	26	39	2	11809	\N
541	26	47	2	256	\N
542	26	30	2	198	\N
543	26	11	2	198	\N
544	26	55	2	198	\N
545	26	26	2	198	\N
546	26	42	2	198	\N
547	26	23	2	65	\N
548	27	58	1	11707	\N
549	27	18	1	3428	\N
550	27	23	1	1078	\N
551	27	30	1	724	\N
552	27	6	1	404	\N
553	27	59	1	362	\N
554	27	15	1	361	\N
555	27	53	1	348	\N
556	27	49	1	328	\N
557	27	1	1	288	\N
558	27	41	1	249	\N
559	27	42	1	241	\N
560	27	63	1	229	\N
561	27	46	1	226	\N
562	27	43	1	121	\N
563	27	12	1	86	\N
564	27	35	1	59	\N
565	27	16	1	36	\N
566	27	27	3	2416	\N
567	27	34	3	362	\N
568	27	21	3	312	\N
569	27	58	2	12972	\N
570	27	27	2	6434	\N
571	27	18	2	4531	\N
572	27	46	2	1488	\N
573	27	12	2	1448	\N
574	27	60	2	1051	\N
575	27	37	2	851	\N
576	27	23	2	466	\N
577	27	30	2	362	\N
578	27	15	2	294	\N
579	27	42	2	279	\N
580	27	43	2	253	\N
581	27	6	2	245	\N
582	27	10	2	206	\N
583	27	25	2	196	\N
584	27	2	2	173	\N
585	27	65	2	173	\N
586	27	52	2	173	\N
587	27	14	2	166	\N
588	27	63	2	159	\N
589	27	44	2	130	\N
590	27	47	2	106	\N
591	27	3	2	106	\N
592	27	24	2	77	\N
593	27	7	2	76	\N
594	27	64	2	57	\N
595	28	58	1	6689	\N
596	28	30	1	51	\N
597	28	33	1	51	\N
598	28	42	1	51	\N
599	28	57	3	201	\N
600	28	31	3	171	\N
601	28	33	3	135	\N
602	28	28	3	85	\N
603	28	42	3	51	\N
604	28	37	3	21	\N
605	28	58	2	3550	\N
606	28	18	2	1066	\N
607	28	28	2	95	\N
608	28	57	2	65	\N
609	28	30	2	51	\N
610	28	36	2	51	\N
611	28	31	2	51	\N
612	28	49	2	51	\N
613	28	43	2	51	\N
614	28	42	2	51	\N
615	29	34	2	75	\N
616	29	30	2	48	\N
617	29	58	2	48	\N
618	29	8	2	48	\N
619	29	29	2	48	\N
620	29	61	2	46	\N
621	29	45	2	45	\N
622	29	32	2	43	\N
623	29	19	2	43	\N
624	29	5	2	42	\N
625	29	23	2	33	\N
626	29	20	2	25	\N
627	29	18	2	10	\N
628	30	27	1	1419	\N
629	30	23	1	388	\N
630	30	15	1	312	\N
631	30	6	1	257	\N
632	30	14	1	174	\N
633	30	63	1	171	\N
634	30	30	1	87	\N
635	30	58	1	87	\N
636	30	60	1	81	\N
637	30	24	1	80	\N
638	30	7	1	79	\N
639	30	64	1	61	\N
640	30	18	1	48	\N
641	30	30	3	281833	\N
642	30	58	2	44658	\N
643	30	39	2	11809	\N
644	30	18	2	5102	\N
645	30	30	2	1649	\N
646	30	42	2	1202	\N
647	30	23	2	1002	\N
648	30	47	2	601	\N
649	30	49	2	413	\N
650	30	27	2	362	\N
651	30	3	2	345	\N
652	30	6	2	290	\N
653	30	57	2	261	\N
654	30	36	2	254	\N
655	30	15	2	241	\N
656	30	31	2	228	\N
657	30	33	2	217	\N
658	30	11	2	198	\N
659	30	55	2	198	\N
660	30	26	2	198	\N
661	30	43	2	188	\N
662	30	59	2	174	\N
663	30	53	2	162	\N
664	30	46	2	119	\N
665	30	1	2	118	\N
666	30	63	2	112	\N
667	30	34	2	87	\N
668	30	41	2	86	\N
669	30	14	2	76	\N
670	30	62	2	76	\N
671	30	13	2	75	\N
672	30	22	2	75	\N
673	30	12	2	75	\N
674	30	17	2	74	\N
675	30	9	2	71	\N
676	30	60	2	71	\N
677	30	40	2	67	\N
678	30	37	2	66	\N
679	30	4	2	60	\N
680	30	61	2	54	\N
681	30	28	2	51	\N
682	30	45	2	48	\N
683	30	8	2	48	\N
684	30	29	2	48	\N
685	30	50	2	47	\N
686	30	51	2	47	\N
687	30	19	2	45	\N
688	30	32	2	44	\N
689	30	21	2	44	\N
690	30	5	2	43	\N
691	30	48	2	39	\N
692	30	56	2	37	\N
693	30	24	2	36	\N
694	30	52	2	36	\N
695	30	7	2	35	\N
696	30	38	2	35	\N
697	30	20	2	26	\N
698	30	64	2	17	\N
699	30	54	2	17	\N
700	30	16	2	12	\N
701	30	25	2	12	\N
702	30	10	2	10	\N
703	30	35	2	10	\N
704	30	2	2	7	\N
705	30	65	2	7	\N
706	30	44	2	6	\N
707	31	58	1	31799	\N
708	31	30	1	228	\N
709	31	33	1	228	\N
710	31	42	1	228	\N
711	31	31	3	838	\N
712	31	57	3	432	\N
713	31	33	3	300	\N
714	31	42	3	228	\N
715	31	28	3	171	\N
716	31	37	3	36	\N
717	31	58	2	9786	\N
718	31	18	2	3844	\N
719	31	57	2	243	\N
720	31	36	2	233	\N
721	31	30	2	228	\N
722	31	31	2	228	\N
723	31	49	2	228	\N
724	31	42	2	228	\N
725	31	43	2	145	\N
726	31	28	2	51	\N
727	32	34	2	71	\N
728	32	30	2	44	\N
729	32	58	2	44	\N
730	32	32	2	44	\N
731	32	8	2	43	\N
732	32	29	2	43	\N
733	32	45	2	42	\N
734	32	61	2	42	\N
735	32	19	2	40	\N
736	32	5	2	39	\N
737	32	23	2	33	\N
738	32	20	2	24	\N
739	32	18	2	10	\N
740	33	58	1	66738	\N
741	33	30	1	217	\N
742	33	42	1	217	\N
743	33	33	1	194	\N
744	33	57	3	14749	\N
745	33	33	3	11195	\N
746	33	37	3	705	\N
747	33	31	3	300	\N
748	33	42	3	217	\N
749	33	28	3	135	\N
750	33	58	2	23736	\N
751	33	30	2	217	\N
752	33	33	2	217	\N
753	33	42	2	217	\N
754	34	58	1	1455	\N
755	34	18	1	443	\N
756	34	30	1	174	\N
757	34	23	1	173	\N
758	34	6	1	101	\N
759	34	59	1	87	\N
760	34	15	1	86	\N
761	34	49	1	82	\N
762	34	53	1	81	\N
763	34	1	1	59	\N
764	34	63	1	47	\N
765	34	41	1	43	\N
766	34	42	1	38	\N
767	34	46	1	31	\N
768	34	43	1	16	\N
769	34	12	1	13	\N
770	34	16	1	6	\N
771	34	35	1	5	\N
772	34	27	3	362	\N
773	34	34	3	87	\N
774	34	21	3	44	\N
775	34	34	2	403	\N
776	34	23	2	122	\N
777	34	30	2	87	\N
778	34	58	2	87	\N
779	34	8	2	75	\N
780	34	29	2	75	\N
781	34	61	2	72	\N
782	34	32	2	71	\N
783	34	45	2	66	\N
784	34	19	2	64	\N
785	34	5	2	63	\N
786	34	20	2	46	\N
787	34	18	2	31	\N
788	35	58	2	372	\N
789	35	18	2	123	\N
790	35	23	2	20	\N
791	35	35	2	11	\N
792	35	30	2	10	\N
793	35	46	2	8	\N
794	35	41	2	5	\N
795	35	15	2	5	\N
796	35	49	2	5	\N
797	35	53	2	5	\N
798	35	59	2	5	\N
799	35	43	2	5	\N
800	35	1	2	5	\N
801	35	6	2	5	\N
802	35	42	2	5	\N
803	35	12	2	4	\N
804	35	63	2	2	\N
805	36	58	2	10507	\N
806	36	18	2	4082	\N
807	36	36	2	266	\N
808	36	57	2	266	\N
809	36	30	2	254	\N
810	36	49	2	254	\N
811	36	42	2	254	\N
812	36	31	2	233	\N
813	36	43	2	150	\N
814	36	28	2	51	\N
815	37	58	1	15420	\N
816	37	30	1	66	\N
817	37	33	1	66	\N
818	37	42	1	66	\N
819	37	57	3	910	\N
820	37	33	3	705	\N
821	37	37	3	214	\N
822	37	42	3	66	\N
823	37	31	3	36	\N
824	37	28	3	21	\N
825	37	58	2	2419	\N
826	37	18	2	890	\N
827	37	27	2	851	\N
828	37	46	2	243	\N
829	37	12	2	227	\N
830	37	37	2	226	\N
831	37	60	2	155	\N
832	37	25	2	73	\N
833	37	30	2	66	\N
834	37	52	2	66	\N
835	37	42	2	66	\N
836	37	10	2	53	\N
837	37	43	2	48	\N
838	37	23	2	34	\N
839	37	2	2	32	\N
840	37	65	2	32	\N
841	37	44	2	31	\N
842	38	23	2	55	\N
843	38	30	2	35	\N
844	38	58	2	35	\N
845	38	13	2	35	\N
846	38	38	2	35	\N
847	38	17	2	35	\N
848	38	22	2	35	\N
849	38	62	2	35	\N
850	38	56	2	35	\N
851	38	9	2	32	\N
852	38	50	2	31	\N
853	38	21	2	30	\N
854	38	4	2	29	\N
855	38	40	2	29	\N
856	38	51	2	26	\N
857	38	54	2	17	\N
858	38	18	2	8	\N
859	39	39	2	807199	\N
860	39	47	2	16378	\N
861	39	30	2	11809	\N
862	39	11	2	11809	\N
863	39	55	2	11809	\N
864	39	26	2	11809	\N
865	39	42	2	11809	\N
866	39	23	2	5134	\N
867	40	23	2	94	\N
868	40	30	2	67	\N
869	40	58	2	67	\N
870	40	13	2	67	\N
871	40	17	2	67	\N
872	40	22	2	67	\N
873	40	40	2	67	\N
874	40	62	2	67	\N
875	40	9	2	65	\N
876	40	4	2	55	\N
877	40	51	2	43	\N
878	40	21	2	43	\N
879	40	50	2	41	\N
880	40	48	2	38	\N
881	40	38	2	29	\N
882	40	56	2	29	\N
883	40	54	2	14	\N
884	40	18	2	12	\N
885	41	58	2	1172	\N
886	41	18	2	358	\N
887	41	23	2	115	\N
888	41	30	2	86	\N
889	41	6	2	44	\N
890	41	41	2	43	\N
891	41	15	2	43	\N
892	41	53	2	43	\N
893	41	59	2	43	\N
894	41	49	2	40	\N
895	41	1	2	36	\N
896	41	63	2	32	\N
897	41	42	2	26	\N
898	41	46	2	24	\N
899	41	43	2	13	\N
900	41	12	2	11	\N
901	41	35	2	5	\N
902	41	16	2	3	\N
903	42	58	1	41040	\N
904	42	39	1	11809	\N
905	42	18	1	3995	\N
906	42	30	1	1119	\N
907	42	42	1	1119	\N
908	42	47	1	601	\N
909	42	23	1	439	\N
910	42	3	1	345	\N
911	42	57	1	261	\N
912	42	36	1	254	\N
913	42	49	1	249	\N
914	42	31	1	228	\N
915	42	33	1	217	\N
916	42	11	1	198	\N
917	42	55	1	198	\N
918	42	26	1	198	\N
919	42	43	1	147	\N
920	42	27	1	106	\N
921	42	28	1	51	\N
922	42	37	1	34	\N
923	42	52	1	29	\N
924	42	42	3	1164	\N
925	42	47	3	601	\N
926	42	57	3	261	\N
927	42	31	3	228	\N
928	42	33	3	217	\N
929	42	11	3	198	\N
930	42	37	3	66	\N
931	42	28	3	51	\N
932	42	58	2	42979	\N
933	42	39	2	11809	\N
934	42	18	2	4618	\N
935	42	30	2	1202	\N
936	42	42	2	1164	\N
937	42	47	2	601	\N
938	42	23	2	536	\N
939	42	3	2	345	\N
940	42	49	2	285	\N
941	42	27	2	279	\N
942	42	57	2	261	\N
943	42	36	2	254	\N
944	42	31	2	228	\N
945	42	33	2	217	\N
946	42	11	2	198	\N
947	42	55	2	198	\N
948	42	26	2	198	\N
949	42	43	2	172	\N
950	42	46	2	80	\N
951	42	37	2	66	\N
952	42	12	2	59	\N
953	42	28	2	51	\N
954	42	6	2	41	\N
955	42	15	2	38	\N
956	42	59	2	38	\N
957	42	52	2	36	\N
958	42	53	2	35	\N
959	42	60	2	34	\N
960	42	63	2	28	\N
961	42	41	2	26	\N
962	42	1	2	26	\N
963	42	25	2	12	\N
964	42	10	2	10	\N
965	42	2	2	7	\N
966	42	65	2	7	\N
967	42	44	2	6	\N
968	42	35	2	5	\N
969	42	16	2	2	\N
970	43	43	3	172	\N
971	43	58	2	8821	\N
972	43	18	2	3364	\N
973	43	27	2	253	\N
974	43	43	2	194	\N
975	43	30	2	188	\N
976	43	42	2	172	\N
977	43	49	2	162	\N
978	43	57	2	159	\N
979	43	36	2	150	\N
980	43	31	2	145	\N
981	43	46	2	88	\N
982	43	12	2	77	\N
983	43	28	2	51	\N
984	43	37	2	48	\N
985	43	23	2	47	\N
986	43	60	2	44	\N
987	43	6	2	19	\N
988	43	15	2	16	\N
989	43	53	2	16	\N
990	43	59	2	16	\N
991	43	25	2	14	\N
992	43	41	2	13	\N
993	43	1	2	13	\N
994	43	10	2	12	\N
995	43	63	2	11	\N
996	43	2	2	9	\N
997	43	65	2	9	\N
998	43	52	2	9	\N
999	43	44	2	8	\N
1000	43	35	2	5	\N
1001	43	16	2	1	\N
1002	44	58	2	473	\N
1003	44	18	2	184	\N
1004	44	27	2	130	\N
1005	44	46	2	35	\N
1006	44	37	2	31	\N
1007	44	12	2	28	\N
1008	44	25	2	20	\N
1009	44	60	2	17	\N
1010	44	10	2	12	\N
1011	44	44	2	8	\N
1012	44	43	2	8	\N
1013	44	30	2	6	\N
1014	44	2	2	6	\N
1015	44	65	2	6	\N
1016	44	52	2	6	\N
1017	44	42	2	6	\N
1018	45	34	2	66	\N
1019	45	30	2	48	\N
1020	45	58	2	48	\N
1021	45	45	2	48	\N
1022	45	61	2	47	\N
1023	45	19	2	45	\N
1024	45	8	2	45	\N
1025	45	29	2	45	\N
1026	45	32	2	42	\N
1027	45	5	2	42	\N
1028	45	23	2	33	\N
1029	45	20	2	26	\N
1030	45	18	2	10	\N
1031	46	23	1	173	\N
1032	46	21	1	137	\N
1033	46	30	1	88	\N
1034	46	58	1	88	\N
1035	46	22	1	88	\N
1036	46	62	1	88	\N
1037	46	56	1	88	\N
1038	46	13	1	87	\N
1039	46	17	1	86	\N
1040	46	38	1	85	\N
1041	46	9	1	81	\N
1042	46	50	1	77	\N
1043	46	40	1	76	\N
1044	46	4	1	75	\N
1045	46	51	1	66	\N
1046	46	54	1	47	\N
1047	46	18	1	27	\N
1048	46	46	3	310	\N
1049	46	58	2	5482	\N
1050	46	18	2	1829	\N
1051	46	27	2	1488	\N
1052	46	46	2	612	\N
1053	46	12	2	492	\N
1054	46	60	2	338	\N
1055	46	37	2	243	\N
1056	46	30	2	119	\N
1057	46	23	2	100	\N
1058	46	43	2	88	\N
1059	46	42	2	80	\N
1060	46	10	2	63	\N
1061	46	2	2	57	\N
1062	46	65	2	57	\N
1063	46	52	2	57	\N
1064	46	25	2	47	\N
1065	46	44	2	35	\N
1066	46	15	2	32	\N
1067	46	49	2	31	\N
1068	46	63	2	31	\N
1069	46	59	2	31	\N
1070	46	6	2	30	\N
1071	46	53	2	29	\N
1072	46	1	2	28	\N
1073	46	41	2	24	\N
1074	46	35	2	8	\N
1075	47	58	1	30680	\N
1076	47	18	1	10228	\N
1077	47	57	1	632	\N
1078	47	36	1	617	\N
1079	47	30	1	601	\N
1080	47	49	1	601	\N
1081	47	42	1	601	\N
1082	47	31	1	573	\N
1083	47	43	1	443	\N
1084	47	28	1	153	\N
1085	47	47	3	6843	\N
1086	47	42	3	601	\N
1087	47	39	2	16378	\N
1088	47	47	2	831	\N
1089	47	30	2	601	\N
1090	47	42	2	601	\N
1091	47	23	2	468	\N
1092	47	3	2	345	\N
1093	47	11	2	256	\N
1094	47	55	2	256	\N
1095	47	26	2	256	\N
1096	47	27	2	106	\N
1097	48	23	2	49	\N
1098	48	30	2	39	\N
1099	48	58	2	39	\N
1100	48	13	2	39	\N
1101	48	62	2	39	\N
1102	48	48	2	39	\N
1103	48	17	2	38	\N
1104	48	22	2	38	\N
1105	48	40	2	38	\N
1106	48	9	2	38	\N
1107	48	4	2	31	\N
1108	48	51	2	21	\N
1109	48	50	2	16	\N
1110	48	21	2	13	\N
1111	48	18	2	6	\N
1112	49	58	2	11563	\N
1113	49	18	2	4407	\N
1114	49	30	2	413	\N
1115	49	49	2	331	\N
1116	49	42	2	285	\N
1117	49	57	2	261	\N
1118	49	36	2	254	\N
1119	49	31	2	228	\N
1120	49	43	2	162	\N
1121	49	23	2	157	\N
1122	49	6	2	95	\N
1123	49	59	2	82	\N
1124	49	15	2	81	\N
1125	49	53	2	77	\N
1126	49	1	2	55	\N
1127	49	28	2	51	\N
1128	49	63	2	47	\N
1129	49	41	2	40	\N
1130	49	46	2	31	\N
1131	49	12	2	13	\N
1132	49	35	2	5	\N
1133	49	16	2	1	\N
1134	50	23	2	73	\N
1135	50	30	2	47	\N
1136	50	58	2	47	\N
1137	50	50	2	47	\N
1138	50	13	2	47	\N
1139	50	17	2	47	\N
1140	50	22	2	47	\N
1141	50	62	2	47	\N
1142	50	9	2	46	\N
1143	50	4	2	44	\N
1144	50	40	2	41	\N
1145	50	51	2	36	\N
1146	50	38	2	31	\N
1147	50	56	2	31	\N
1148	50	21	2	28	\N
1149	50	54	2	17	\N
1150	50	48	2	16	\N
1151	50	18	2	11	\N
1152	51	23	2	64	\N
1153	51	30	2	47	\N
1154	51	58	2	47	\N
1155	51	51	2	47	\N
1156	51	13	2	47	\N
1157	51	17	2	47	\N
1158	51	22	2	47	\N
1159	51	62	2	47	\N
1160	51	9	2	46	\N
1161	51	40	2	43	\N
1162	51	4	2	42	\N
1163	51	50	2	36	\N
1164	51	21	2	30	\N
1165	51	38	2	26	\N
1166	51	56	2	26	\N
1167	51	48	2	21	\N
1168	51	54	2	14	\N
1169	51	18	2	10	\N
1170	52	58	2	533	\N
1171	52	18	2	191	\N
1172	52	27	2	173	\N
1173	52	37	2	66	\N
1174	52	46	2	57	\N
1175	52	12	2	49	\N
1176	52	30	2	36	\N
1177	52	52	2	36	\N
1178	52	42	2	36	\N
1179	52	60	2	34	\N
1180	52	23	2	29	\N
1181	52	25	2	12	\N
1182	52	10	2	10	\N
1183	52	43	2	9	\N
1184	52	2	2	7	\N
1185	52	65	2	7	\N
1186	52	44	2	6	\N
1187	53	58	2	1312	\N
1188	53	18	2	402	\N
1189	53	23	2	167	\N
1190	53	30	2	162	\N
1191	53	6	2	97	\N
1192	53	15	2	81	\N
1193	53	53	2	81	\N
1194	53	59	2	81	\N
1195	53	49	2	77	\N
1196	53	1	2	59	\N
1197	53	41	2	43	\N
1198	53	63	2	43	\N
1199	53	42	2	35	\N
1200	53	46	2	29	\N
1201	53	43	2	16	\N
1202	53	12	2	13	\N
1203	53	35	2	5	\N
1204	53	16	2	5	\N
1205	54	23	2	33	\N
1206	54	30	2	17	\N
1207	54	58	2	17	\N
1208	54	50	2	17	\N
1209	54	13	2	17	\N
1210	54	38	2	17	\N
1211	54	17	2	17	\N
1212	54	22	2	17	\N
1213	54	54	2	17	\N
1214	54	62	2	17	\N
1215	54	9	2	17	\N
1216	54	56	2	17	\N
1217	54	4	2	16	\N
1218	54	51	2	14	\N
1219	54	40	2	14	\N
1220	54	21	2	14	\N
1221	54	18	2	7	\N
1222	55	39	2	11809	\N
1223	55	47	2	256	\N
1224	55	30	2	198	\N
1225	55	11	2	198	\N
1226	55	55	2	198	\N
1227	55	26	2	198	\N
1228	55	42	2	198	\N
1229	55	23	2	65	\N
1230	56	23	2	57	\N
1231	56	30	2	37	\N
1232	56	58	2	37	\N
1233	56	22	2	37	\N
1234	56	62	2	37	\N
1235	56	56	2	37	\N
1236	56	13	2	36	\N
1237	56	17	2	36	\N
1238	56	38	2	35	\N
1239	56	9	2	33	\N
1240	56	50	2	31	\N
1241	56	21	2	31	\N
1242	56	4	2	29	\N
1243	56	40	2	29	\N
1244	56	51	2	26	\N
1245	56	54	2	17	\N
1246	56	18	2	8	\N
1247	57	58	1	79449	\N
1248	57	30	1	261	\N
1249	57	42	1	261	\N
1250	57	33	1	235	\N
1251	57	57	3	19745	\N
1252	57	33	3	14749	\N
1253	57	37	3	910	\N
1254	57	31	3	432	\N
1255	57	42	3	261	\N
1256	57	28	3	201	\N
1257	57	58	2	11441	\N
1258	57	18	2	4321	\N
1259	57	57	2	301	\N
1260	57	36	2	266	\N
1261	57	30	2	261	\N
1262	57	49	2	261	\N
1263	57	42	2	261	\N
1264	57	31	2	243	\N
1265	57	43	2	159	\N
1266	57	28	2	65	\N
1267	58	58	2	6616403	\N
1268	58	18	2	231127	\N
1269	58	30	2	44658	\N
1270	58	42	2	42979	\N
1271	58	33	2	23736	\N
1272	58	27	2	12972	\N
1273	58	49	2	11563	\N
1274	58	57	2	11441	\N
1275	58	36	2	10507	\N
1276	58	31	2	9786	\N
1277	58	43	2	8821	\N
1278	58	46	2	5482	\N
1279	58	23	2	5046	\N
1280	58	12	2	4076	\N
1281	58	28	2	3550	\N
1282	58	60	2	2501	\N
1283	58	37	2	2419	\N
1284	58	6	2	1647	\N
1285	58	15	2	1523	\N
1286	58	59	2	1455	\N
1287	58	53	2	1312	\N
1288	58	1	2	1173	\N
1289	58	41	2	1172	\N
1290	58	63	2	1056	\N
1291	58	25	2	971	\N
1292	58	10	2	782	\N
1293	58	2	2	533	\N
1294	58	65	2	533	\N
1295	58	52	2	533	\N
1296	58	44	2	473	\N
1297	58	35	2	372	\N
1298	58	16	2	188	\N
1299	58	34	2	87	\N
1300	58	14	2	76	\N
1301	58	62	2	76	\N
1302	58	13	2	75	\N
1303	58	22	2	75	\N
1304	58	17	2	74	\N
1305	58	9	2	71	\N
1306	58	40	2	67	\N
1307	58	4	2	60	\N
1308	58	61	2	54	\N
1309	58	45	2	48	\N
1310	58	8	2	48	\N
1311	58	29	2	48	\N
1312	58	50	2	47	\N
1313	58	51	2	47	\N
1314	58	19	2	45	\N
1315	58	32	2	44	\N
1316	58	21	2	44	\N
1317	58	5	2	43	\N
1318	58	48	2	39	\N
1319	58	56	2	37	\N
1320	58	24	2	36	\N
1321	58	7	2	35	\N
1322	58	38	2	35	\N
1323	58	20	2	26	\N
1324	58	64	2	17	\N
1325	58	54	2	17	\N
1326	59	34	1	403	\N
1327	59	23	1	122	\N
1328	59	30	1	87	\N
1329	59	58	1	87	\N
1330	59	8	1	75	\N
1331	59	29	1	75	\N
1332	59	61	1	72	\N
1333	59	32	1	71	\N
1334	59	45	1	66	\N
1335	59	19	1	64	\N
1336	59	5	1	63	\N
1337	59	20	1	46	\N
1338	59	18	1	31	\N
1339	59	59	3	403	\N
1340	59	60	3	184	\N
1341	59	58	2	1455	\N
1342	59	18	2	443	\N
1343	59	30	2	174	\N
1344	59	23	2	173	\N
1345	59	6	2	101	\N
1346	59	59	2	87	\N
1347	59	15	2	86	\N
1348	59	49	2	82	\N
1349	59	53	2	81	\N
1350	59	1	2	59	\N
1351	59	63	2	47	\N
1352	59	41	2	43	\N
1353	59	42	2	38	\N
1354	59	46	2	31	\N
1355	59	43	2	16	\N
1356	59	12	2	13	\N
1357	59	16	2	6	\N
1358	59	35	2	5	\N
1359	60	34	1	184	\N
1360	60	23	1	100	\N
1361	60	30	1	71	\N
1362	60	58	1	71	\N
1363	60	61	1	64	\N
1364	60	8	1	61	\N
1365	60	29	1	61	\N
1366	60	45	1	60	\N
1367	60	19	1	58	\N
1368	60	32	1	56	\N
1369	60	5	1	54	\N
1370	60	20	1	39	\N
1371	60	18	1	28	\N
1372	60	59	3	184	\N
1373	60	60	3	151	\N
1374	60	58	2	2501	\N
1375	60	27	2	1051	\N
1376	60	18	2	842	\N
1377	60	46	2	338	\N
1378	60	12	2	321	\N
1379	60	60	2	291	\N
1380	60	37	2	155	\N
1381	60	6	2	88	\N
1382	60	14	2	74	\N
1383	60	30	2	71	\N
1384	60	23	2	70	\N
1385	60	15	2	69	\N
1386	60	43	2	44	\N
1387	60	10	2	37	\N
1388	60	24	2	36	\N
1389	60	7	2	35	\N
1390	60	2	2	34	\N
1391	60	65	2	34	\N
1392	60	52	2	34	\N
1393	60	42	2	34	\N
1394	60	25	2	23	\N
1395	60	63	2	18	\N
1396	60	44	2	17	\N
1397	60	64	2	16	\N
1398	61	34	2	72	\N
1399	61	30	2	54	\N
1400	61	58	2	54	\N
1401	61	61	2	54	\N
1402	61	45	2	47	\N
1403	61	8	2	46	\N
1404	61	29	2	46	\N
1405	61	19	2	44	\N
1406	61	5	2	43	\N
1407	61	32	2	42	\N
1408	61	23	2	34	\N
1409	61	20	2	26	\N
1410	61	18	2	11	\N
1411	62	23	2	106	\N
1412	62	30	2	76	\N
1413	62	58	2	76	\N
1414	62	62	2	76	\N
1415	62	13	2	75	\N
1416	62	22	2	75	\N
1417	62	17	2	74	\N
1418	62	9	2	71	\N
1419	62	40	2	67	\N
1420	62	4	2	60	\N
1421	62	50	2	47	\N
1422	62	51	2	47	\N
1423	62	21	2	44	\N
1424	62	48	2	39	\N
1425	62	56	2	37	\N
1426	62	38	2	35	\N
1427	62	54	2	17	\N
1428	62	18	2	14	\N
1429	63	58	2	1056	\N
1430	63	18	2	344	\N
1431	63	23	2	170	\N
1432	63	27	2	159	\N
1433	63	15	2	113	\N
1434	63	30	2	112	\N
1435	63	63	2	107	\N
1436	63	6	2	87	\N
1437	63	49	2	47	\N
1438	63	59	2	47	\N
1439	63	53	2	43	\N
1440	63	14	2	36	\N
1441	63	41	2	32	\N
1442	63	46	2	31	\N
1443	63	1	2	29	\N
1444	63	42	2	28	\N
1445	63	7	2	18	\N
1446	63	24	2	18	\N
1447	63	60	2	18	\N
1448	63	12	2	12	\N
1449	63	43	2	11	\N
1450	63	64	2	8	\N
1451	63	35	2	2	\N
1452	64	27	2	57	\N
1453	64	23	2	44	\N
1454	64	6	2	40	\N
1455	64	14	2	34	\N
1456	64	15	2	34	\N
1457	64	30	2	17	\N
1458	64	58	2	17	\N
1459	64	64	2	17	\N
1460	64	7	2	16	\N
1461	64	24	2	16	\N
1462	64	60	2	16	\N
1463	64	63	2	8	\N
1464	64	18	2	4	\N
1465	65	58	2	533	\N
1466	65	18	2	191	\N
1467	65	27	2	173	\N
1468	65	46	2	57	\N
1469	65	12	2	49	\N
1470	65	60	2	34	\N
1471	65	37	2	32	\N
1472	65	25	2	12	\N
1473	65	10	2	10	\N
1474	65	43	2	9	\N
1475	65	30	2	7	\N
1476	65	2	2	7	\N
1477	65	65	2	7	\N
1478	65	52	2	7	\N
1479	65	42	2	7	\N
1480	65	44	2	6	\N
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint) FROM stdin;
1	https://swapi.co/vocabulary/mass	59	\N	68	mass	mass	f	0	1	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
2	https://swapi.co/vocabulary/episodeId	7	\N	68	episodeId	episodeId	f	0	1	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
3	https://swapi.co/vocabulary/role	345	\N	68	role	role	f	0	1	\N	f	f	26	\N	\N	t	f	\N	\N	\N	t	f	f
4	https://swapi.co/vocabulary/cargoCapacity	60	\N	68	cargoCapacity	cargoCapacity	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
5	https://swapi.co/vocabulary/population	43	\N	68	population	population	f	0	1	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
6	https://swapi.co/vocabulary/skinColor	189	\N	68	skinColor	skinColor	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
7	https://swapi.co/vocabulary/averageHeight	35	\N	68	averageHeight	averageHeight	f	0	1	\N	f	f	34	\N	\N	t	f	\N	\N	\N	t	f	f
8	https://swapi.co/vocabulary/orbitalPeriod	48	\N	68	orbitalPeriod	orbitalPeriod	f	0	1	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
9	https://swapi.co/vocabulary/passengers	71	\N	68	passengers	passengers	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
10	https://swapi.co/vocabulary/boxOffice	10	\N	68	boxOffice	boxOffice	f	0	-1	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
11	https://swapi.co/vocabulary/award	198	\N	68	award	award	f	198	1	-1	f	f	43	14	\N	t	f	\N	\N	\N	t	f	f
12	https://swapi.co/vocabulary/vehicle	62	\N	68	vehicle	vehicle	f	62	-1	-1	f	f	\N	46	\N	t	f	\N	\N	\N	t	f	f
13	https://swapi.co/vocabulary/crew	75	\N	68	crew	crew	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
14	http://www.w3.org/2000/01/rdf-schema#subClassOf	76	\N	2	subClassOf	subClassOf	f	76	-1	-1	f	f	34	\N	\N	t	f	\N	\N	\N	t	f	f
15	https://swapi.co/vocabulary/eyeColor	155	\N	68	eyeColor	eyeColor	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
16	https://swapi.co/vocabulary/degree	6	\N	68	degree	degree	f	0	1	\N	f	f	2	\N	\N	t	f	\N	\N	\N	t	f	f
17	https://swapi.co/vocabulary/length	74	\N	68	length	length	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
18	https://swapi.co/vocabulary/desc	4659	\N	68	desc	desc	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
19	https://swapi.co/vocabulary/gravity	45	\N	68	gravity	gravity	f	0	1	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
20	https://swapi.co/vocabulary/surfaceWater	26	\N	68	surfaceWater	surfaceWater	f	0	1	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
21	https://swapi.co/vocabulary/pilot	44	\N	68	pilot	pilot	f	44	-1	-1	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
22	https://swapi.co/vocabulary/manufacturer	75	\N	68	manufacturer	manufacturer	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
23	https://swapi.co/vocabulary/film	829	\N	68	film	film	f	829	-1	-1	f	f	\N	48	\N	t	f	\N	\N	\N	t	f	f
24	https://swapi.co/vocabulary/language	36	\N	68	language	language	f	0	1	\N	f	f	34	\N	\N	t	f	\N	\N	\N	t	f	f
25	https://swapi.co/vocabulary/returnOnInvestment	12	\N	68	returnOnInvestment	returnOnInvestment	f	0	-1	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
26	https://swapi.co/vocabulary/awardStatus	198	\N	68	awardStatus	awardStatus	f	0	1	\N	f	f	43	\N	\N	t	f	\N	\N	\N	t	f	f
27	https://swapi.co/vocabulary/character	362	\N	68	character	character	f	362	-1	-1	f	f	\N	6	\N	t	f	\N	\N	\N	t	f	f
28	https://swapi.co/vocabulary/residentOf	51	\N	68	residentOf	residentOf	f	51	-1	-1	f	f	20	\N	\N	t	f	\N	\N	\N	t	f	f
29	https://swapi.co/vocabulary/rotationPeriod	48	\N	68	rotationPeriod	rotationPeriod	f	0	1	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
30	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	1475	\N	1	type	type	f	1475	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
31	https://swapi.co/vocabulary/birthPlace	228	\N	68	birthPlace	birthPlace	f	228	1	-1	f	f	20	\N	\N	t	f	\N	\N	\N	t	f	f
32	https://swapi.co/vocabulary/diameter	44	\N	68	diameter	diameter	f	0	1	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
33	https://swapi.co/vocabulary/country	217	\N	68	country	country	f	217	1	-1	f	f	\N	24	\N	t	f	\N	\N	\N	t	f	f
34	https://swapi.co/vocabulary/resident	87	\N	68	resident	resident	f	87	-1	1	f	f	38	6	\N	t	f	\N	\N	\N	t	f	f
35	https://swapi.co/vocabulary/cybernetics	5	\N	68	cybernetics	cybernetics	f	0	-1	\N	f	f	19	\N	\N	t	f	\N	\N	\N	t	f	f
36	https://swapi.co/vocabulary/birthDate	254	\N	68	birthDate	birthDate	f	0	-1	\N	f	f	20	\N	\N	t	f	\N	\N	\N	t	f	f
37	https://swapi.co/vocabulary/location	66	\N	68	location	location	f	66	-1	-1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
38	https://swapi.co/vocabulary/hyperdriveRating	35	\N	68	hyperdriveRating	hyperdriveRating	f	0	1	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
39	https://swapi.co/vocabulary/forWork	11809	\N	68	forWork	forWork	f	0	-1	\N	f	f	43	\N	\N	t	f	\N	\N	\N	t	f	f
40	https://swapi.co/vocabulary/maxAtmospheringSpeed	67	\N	68	maxAtmospheringSpeed	maxAtmospheringSpeed	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
41	https://swapi.co/vocabulary/birthYear	43	\N	68	birthYear	birthYear	f	0	1	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
42	https://swapi.co/vocabulary/wikidataLink	1164	\N	68	wikidataLink	wikidataLink	f	1164	1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
43	https://swapi.co/vocabulary/image	172	\N	68	image	image	f	172	-1	1	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
44	https://swapi.co/vocabulary/cost	6	\N	68	cost	cost	f	0	-1	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
45	https://swapi.co/vocabulary/climate	48	\N	68	climate	climate	f	0	1	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
46	https://swapi.co/vocabulary/starship	88	\N	68	starship	starship	f	88	-1	-1	f	f	\N	39	\N	t	f	\N	\N	\N	t	f	f
47	https://swapi.co/vocabulary/person	601	\N	68	person	person	f	601	-1	-1	f	f	\N	20	\N	t	f	\N	\N	\N	t	f	f
48	https://swapi.co/vocabulary/vehicleClass	39	\N	68	vehicleClass	vehicleClass	f	0	1	\N	f	f	46	\N	\N	t	f	\N	\N	\N	t	f	f
49	https://swapi.co/vocabulary/gender	331	\N	68	gender	gender	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
50	https://swapi.co/vocabulary/consumables	47	\N	68	consumables	consumables	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
51	https://swapi.co/vocabulary/costInCredits	47	\N	68	costInCredits	costInCredits	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
52	https://swapi.co/vocabulary/releaseDate	36	\N	68	releaseDate	releaseDate	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
53	https://swapi.co/vocabulary/height	81	\N	68	height	height	f	0	1	\N	f	f	6	\N	\N	t	f	\N	\N	\N	t	f	f
54	https://swapi.co/vocabulary/mglt	17	\N	68	mglt	mglt	f	0	1	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
55	https://swapi.co/vocabulary/awardDate	198	\N	68	awardDate	awardDate	f	0	1	\N	f	f	43	\N	\N	t	f	\N	\N	\N	t	f	f
56	https://swapi.co/vocabulary/starshipClass	37	\N	68	starshipClass	starshipClass	f	0	1	\N	f	f	39	\N	\N	t	f	\N	\N	\N	t	f	f
57	https://swapi.co/vocabulary/citizenOf	261	\N	68	citizenOf	citizenOf	f	261	-1	-1	f	f	20	24	\N	t	f	\N	\N	\N	t	f	f
58	http://www.w3.org/2000/01/rdf-schema#label	43203	\N	2	label	label	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
59	https://swapi.co/vocabulary/homeworld	87	\N	68	homeworld	homeworld	f	87	1	-1	f	f	6	38	\N	t	f	\N	\N	\N	t	f	f
60	https://swapi.co/vocabulary/planet	71	\N	68	planet	planet	f	71	-1	-1	f	f	\N	38	\N	t	f	\N	\N	\N	t	f	f
61	https://swapi.co/vocabulary/terrain	54	\N	68	terrain	terrain	f	0	1	\N	f	f	38	\N	\N	t	f	\N	\N	\N	t	f	f
62	https://swapi.co/vocabulary/model	76	\N	68	model	model	f	0	1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
63	https://swapi.co/vocabulary/hairColor	65	\N	68	hairColor	hairColor	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f
64	https://swapi.co/vocabulary/averageLifespan	17	\N	68	averageLifespan	averageLifespan	f	0	1	\N	f	f	34	\N	\N	t	f	\N	\N	\N	t	f	f
65	https://swapi.co/vocabulary/openingCrawl	7	\N	68	openingCrawl	openingCrawl	f	0	1	\N	f	f	48	\N	\N	t	f	\N	\N	\N	t	f	f
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: starwars; Owner: -
--

COPY starwars.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.annot_types_id_seq', 7, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.cc_rel_types_id_seq', 2, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.cc_rels_id_seq', 38, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.class_annots_id_seq', 1, false);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.classes_id_seq', 51, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.cp_rels_id_seq', 652, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.cpc_rels_id_seq', 612, true);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.cpd_rels_id_seq', 366, true);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.datatypes_id_seq', 5, true);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.ns_id_seq', 68, true);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.parameters_id_seq', 34, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.pd_rels_id_seq', 50, true);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.pp_rels_id_seq', 1480, true);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.properties_id_seq', 65, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: starwars; Owner: -
--

SELECT pg_catalog.setval('starwars.property_annots_id_seq', 1, false);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON starwars.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON starwars.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON starwars.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON starwars.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON starwars.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON starwars.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON starwars.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON starwars.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON starwars.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON starwars.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON starwars.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON starwars.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON starwars.datatypes USING btree (ns_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON starwars.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON starwars.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON starwars.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON starwars.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON starwars.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_cc_rels_data ON starwars.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_classes_cnt ON starwars.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_classes_data ON starwars.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_classes_iri ON starwars.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON starwars.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON starwars.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON starwars.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_cp_rels_data ON starwars.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON starwars.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_instances_local_name ON starwars.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_instances_test ON starwars.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_pp_rels_data ON starwars.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON starwars.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON starwars.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON starwars.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON starwars.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON starwars.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON starwars.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_properties_cnt ON starwars.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_properties_data ON starwars.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: starwars; Owner: -
--

CREATE INDEX idx_properties_iri ON starwars.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES starwars.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES starwars.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES starwars.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES starwars.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES starwars.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES starwars.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES starwars.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES starwars.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES starwars.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES starwars.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES starwars.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES starwars.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES starwars.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES starwars.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES starwars.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES starwars.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES starwars.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES starwars.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES starwars.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES starwars.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES starwars.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES starwars.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES starwars.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES starwars.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES starwars.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES starwars.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES starwars.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES starwars.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: starwars; Owner: -
--

ALTER TABLE ONLY starwars.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES starwars.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

