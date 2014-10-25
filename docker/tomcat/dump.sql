--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

CREATE ROLE appfuse WITH PASSWORD 'appfuse' LOGIN;
CREATE DATABASE appfuse WITH OWNER = appfuse TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';

\connect appfuse


--
-- Name: app_user; Type: TABLE; Schema: public; Owner: appfuse; Tablespace: 
--

CREATE TABLE app_user (
    id bigint NOT NULL,
    account_expired boolean NOT NULL,
    account_locked boolean NOT NULL,
    address character varying(150),
    city character varying(50),
    country character varying(100),
    postal_code character varying(15),
    province character varying(100),
    credentials_expired boolean NOT NULL,
    email character varying(255) NOT NULL,
    account_enabled boolean,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    password_hint character varying(255),
    phone_number character varying(255),
    username character varying(50) NOT NULL,
    version integer,
    website character varying(255)
);


ALTER TABLE public.app_user OWNER TO appfuse;

--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: appfuse
--

CREATE SEQUENCE hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hibernate_sequence OWNER TO appfuse;

--
-- Name: hibernate_sequence; Type: SEQUENCE SET; Schema: public; Owner: appfuse
--

SELECT pg_catalog.setval('hibernate_sequence', 1, true);


--
-- Name: role; Type: TABLE; Schema: public; Owner: appfuse; Tablespace: 
--

CREATE TABLE role (
    id bigint NOT NULL,
    description character varying(64),
    name character varying(20)
);


ALTER TABLE public.role OWNER TO appfuse;

--
-- Name: user_role; Type: TABLE; Schema: public; Owner: appfuse; Tablespace: 
--

CREATE TABLE user_role (
    user_id bigint NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE public.user_role OWNER TO appfuse;

--
-- Data for Name: app_user; Type: TABLE DATA; Schema: public; Owner: appfuse
--

COPY app_user (id, account_expired, account_locked, address, city, country, postal_code, province, credentials_expired, email, account_enabled, first_name, last_name, password, password_hint, phone_number, username, version, website) FROM stdin;
-1	f	f		Denver	US	80210	CO	f	matt_raible@yahoo.com	t	Tomcat	User	12dea96fec20593566ab75692c9949596833adc9	A male kitty.		user	1	http://tomcat.apache.org
-2	f	f		Denver	US	80210	CO	f	matt@raibledesigns.com	t	Matt	Raible	d033e22ae348aeb5660fc2140aec35850c4da997	Not a female kitty.		admin	1	http://raibledesigns.com
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: appfuse
--

COPY role (id, description, name) FROM stdin;
-1	Administrator role (can edit Users)	ROLE_ADMIN
-2	Default role for all Users	ROLE_USER
\.


--
-- Data for Name: user_role; Type: TABLE DATA; Schema: public; Owner: appfuse
--

COPY user_role (user_id, role_id) FROM stdin;
-1	-2
-2	-1
\.


--
-- Name: app_user_email_key; Type: CONSTRAINT; Schema: public; Owner: appfuse; Tablespace: 
--

ALTER TABLE ONLY app_user
    ADD CONSTRAINT app_user_email_key UNIQUE (email);


--
-- Name: app_user_pkey; Type: CONSTRAINT; Schema: public; Owner: appfuse; Tablespace: 
--

ALTER TABLE ONLY app_user
    ADD CONSTRAINT app_user_pkey PRIMARY KEY (id);


--
-- Name: app_user_username_key; Type: CONSTRAINT; Schema: public; Owner: appfuse; Tablespace: 
--

ALTER TABLE ONLY app_user
    ADD CONSTRAINT app_user_username_key UNIQUE (username);


--
-- Name: role_pkey; Type: CONSTRAINT; Schema: public; Owner: appfuse; Tablespace: 
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- Name: user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: appfuse; Tablespace: 
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT user_role_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: fk143bf46a4fd90d75; Type: FK CONSTRAINT; Schema: public; Owner: appfuse
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT fk143bf46a4fd90d75 FOREIGN KEY (role_id) REFERENCES role(id);


--
-- Name: fk143bf46af503d155; Type: FK CONSTRAINT; Schema: public; Owner: appfuse
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT fk143bf46af503d155 FOREIGN KEY (user_id) REFERENCES app_user(id);



--
-- PostgreSQL database dump complete
--

