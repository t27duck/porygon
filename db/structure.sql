SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: chat_data_points; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE chat_data_points (
    id integer NOT NULL,
    channel character varying NOT NULL,
    nick character varying NOT NULL,
    full_date date NOT NULL,
    day integer DEFAULT 0 NOT NULL,
    hour integer DEFAULT 0 NOT NULL,
    line_count integer DEFAULT 0 NOT NULL,
    word_count integer DEFAULT 0 NOT NULL,
    random_quote text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: chat_data_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE chat_data_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_data_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE chat_data_points_id_seq OWNED BY chat_data_points.id;


--
-- Name: nick_whitelists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE nick_whitelists (
    id integer NOT NULL,
    nick character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: nick_whitelists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE nick_whitelists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nick_whitelists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE nick_whitelists_id_seq OWNED BY nick_whitelists.id;


--
-- Name: pokemons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pokemons (
    id integer NOT NULL,
    name character varying NOT NULL,
    national_dex integer NOT NULL,
    types character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    species character varying NOT NULL,
    descriptions text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pokemons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pokemons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pokemons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pokemons_id_seq OWNED BY pokemons.id;


--
-- Name: raw_chat_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE raw_chat_logs (
    id integer NOT NULL,
    channel character varying NOT NULL,
    event integer NOT NULL,
    nick character varying NOT NULL,
    host character varying NOT NULL,
    message text NOT NULL,
    parsed boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_on date NOT NULL
);


--
-- Name: raw_chat_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE raw_chat_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: raw_chat_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE raw_chat_logs_id_seq OWNED BY raw_chat_logs.id;


--
-- Name: saying_responses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE saying_responses (
    id integer NOT NULL,
    saying_id integer NOT NULL,
    content text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: saying_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE saying_responses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: saying_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE saying_responses_id_seq OWNED BY saying_responses.id;


--
-- Name: sayings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sayings (
    id integer NOT NULL,
    name character varying NOT NULL,
    pattern character varying NOT NULL,
    trigger_percentage integer DEFAULT 100 NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sayings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sayings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sayings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sayings_id_seq OWNED BY sayings.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: seen_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE seen_activities (
    id bigint NOT NULL,
    channel character varying NOT NULL,
    nick character varying NOT NULL,
    message text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: seen_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE seen_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seen_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE seen_activities_id_seq OWNED BY seen_activities.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: chat_data_points id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY chat_data_points ALTER COLUMN id SET DEFAULT nextval('chat_data_points_id_seq'::regclass);


--
-- Name: nick_whitelists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY nick_whitelists ALTER COLUMN id SET DEFAULT nextval('nick_whitelists_id_seq'::regclass);


--
-- Name: pokemons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pokemons ALTER COLUMN id SET DEFAULT nextval('pokemons_id_seq'::regclass);


--
-- Name: raw_chat_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY raw_chat_logs ALTER COLUMN id SET DEFAULT nextval('raw_chat_logs_id_seq'::regclass);


--
-- Name: saying_responses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY saying_responses ALTER COLUMN id SET DEFAULT nextval('saying_responses_id_seq'::regclass);


--
-- Name: sayings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sayings ALTER COLUMN id SET DEFAULT nextval('sayings_id_seq'::regclass);


--
-- Name: seen_activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY seen_activities ALTER COLUMN id SET DEFAULT nextval('seen_activities_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: chat_data_points chat_data_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY chat_data_points
    ADD CONSTRAINT chat_data_points_pkey PRIMARY KEY (id);


--
-- Name: nick_whitelists nick_whitelists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY nick_whitelists
    ADD CONSTRAINT nick_whitelists_pkey PRIMARY KEY (id);


--
-- Name: pokemons pokemons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pokemons
    ADD CONSTRAINT pokemons_pkey PRIMARY KEY (id);


--
-- Name: raw_chat_logs raw_chat_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY raw_chat_logs
    ADD CONSTRAINT raw_chat_logs_pkey PRIMARY KEY (id);


--
-- Name: saying_responses saying_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY saying_responses
    ADD CONSTRAINT saying_responses_pkey PRIMARY KEY (id);


--
-- Name: sayings sayings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sayings
    ADD CONSTRAINT sayings_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: seen_activities seen_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY seen_activities
    ADD CONSTRAINT seen_activities_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_chat_data_points_on_channel; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_data_points_on_channel ON chat_data_points USING btree (channel);


--
-- Name: index_chat_data_points_on_day; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_data_points_on_day ON chat_data_points USING btree (day);


--
-- Name: index_chat_data_points_on_full_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_data_points_on_full_date ON chat_data_points USING btree (full_date);


--
-- Name: index_chat_data_points_on_hour; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_data_points_on_hour ON chat_data_points USING btree (hour);


--
-- Name: index_chat_data_points_on_nick; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chat_data_points_on_nick ON chat_data_points USING btree (nick);


--
-- Name: index_nick_whitelists_on_nick; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_nick_whitelists_on_nick ON nick_whitelists USING btree (nick);


--
-- Name: index_pokemons_on_national_dex; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pokemons_on_national_dex ON pokemons USING btree (national_dex);


--
-- Name: index_raw_chat_logs_on_channel; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_raw_chat_logs_on_channel ON raw_chat_logs USING btree (channel);


--
-- Name: index_raw_chat_logs_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_raw_chat_logs_on_created_at ON raw_chat_logs USING btree (created_at);


--
-- Name: index_raw_chat_logs_on_created_on; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_raw_chat_logs_on_created_on ON raw_chat_logs USING btree (created_on);


--
-- Name: index_raw_chat_logs_on_event; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_raw_chat_logs_on_event ON raw_chat_logs USING btree (event);


--
-- Name: index_saying_responses_on_saying_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_saying_responses_on_saying_id ON saying_responses USING btree (saying_id);


--
-- Name: index_sayings_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sayings_on_name ON sayings USING btree (name);


--
-- Name: index_sayings_on_pattern; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sayings_on_pattern ON sayings USING btree (pattern);


--
-- Name: index_seen_activities_on_channel_and_nick; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_seen_activities_on_channel_and_nick ON seen_activities USING btree (channel, nick);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: saying_responses fk_rails_5fd42566f6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY saying_responses
    ADD CONSTRAINT fk_rails_5fd42566f6 FOREIGN KEY (saying_id) REFERENCES sayings(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('1001'),
('1002'),
('1003'),
('20160329213559'),
('20160329230046'),
('20160330000551'),
('20160402195249'),
('20160408230120'),
('20160410212525'),
('20180120190617');


