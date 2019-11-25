
-- Department table
CREATE TABLE department_info (
	did integer NOT NULL,
	department character varying(32),
	gid integer NOT NULL,
	CONSTRAINT department_info_pkey PRIMARY KEY (did)
);

-- Employee table
CREATE TABLE employee_info (
	eid integer NOT NULL,
	username character varying(32),
	uid integer NOT NULL,
	fullname character varying(48),
	CONSTRAINT employee_info_pkey PRIMARY KEY (eid)
);

-- Company table
CREATE TABLE company (
	eid integer NOT NULL,
	did integer NOT NULL,
	CONSTRAINT company_did_fkey FOREIGN KEY (did)
		REFERENCES department_info (did) MATCH SIMPLE
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT company_did_fkey1 FOREIGN KEY (did)
		REFERENCES department_info (did) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT company_eid_fkey FOREIGN KEY (eid)
		REFERENCES employee_info (eid) MATCH SIMPLE
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT company_eid_fkey1 FOREIGN KEY (eid)
		REFERENCES employee_info (eid) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

