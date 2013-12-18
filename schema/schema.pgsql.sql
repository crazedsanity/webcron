--
-- Interpreters Table
--	Stores a list of known interpreters, so they can be differentiated from the 
--	script itself (versus arguments)
--
CREATE TABLE cswc_interpreter_table (
	interpreter_id serial NOT NULL PRIMARY KEY,
	interpreter_name text NOT NULL UNIQUE,
	date_created timestamp NOT NULL DEFAULT NOW()
);

INSERT INTO cswc_interpreter_table (interpreter_name) VALUES ('php');
INSERT INTO cswc_interpreter_table (interpreter_name) VALUES ('php5');
INSERT INTO cswc_interpreter_table (interpreter_name) VALUES ('php-cli');
INSERT INTO cswc_interpreter_table (interpreter_name) VALUES ('php5-cli');
INSERT INTO cswc_interpreter_table (interpreter_name) VALUES ('perl');
INSERT INTO cswc_interpreter_table (interpreter_name) VALUES ('python');
INSERT INTO cswc_interpreter_table (interpreter_name) VALUES ('sh');
INSERT INTO cswc_interpreter_table (interpreter_name) VALUES ('bash');

--
-- HOST Table
--
CREATE TABLE cswc_host_table (
	host_id serial NOT NULL PRIMARY KEY,
	host_name text NOT NULL,
	is_active boolean NOT NULL DEFAULT true
);


--
-- Daemon Table (links daemon's API keys to hosts)
--
CREATE TABLE cswc_daemon_table (
	daemon_id serial NOT NULL PRIMARY KEY,
	api_key varchar(40) NOT NULL UNIQUE,
	host_id integer NOT NULL REFERENCES cswc_host_table(host_id),
	is_active boolean NOT NULL DEFAULT true
);


--
-- Scripts table
-- NOTE: it may be important, when calculating max/average run times, to link
--	the script to a specific host?  (maybe it should be different when running
--	on a different server... probably a fringe case)
--
CREATE TABLE cswc_script_table (
	script_id serial NOT NULL PRIMARY KEY,
	script_name text NOT NULL UNIQUE,
	max_run_time integer,
	average_run_time integer
);

--
-- Thresholds Table
--	Helps determine if a script ran properly or not based on how long it ran, 
--	or if there's a problem in the even that it's still running.
--
CREATE TABLE cswc_threshold_table (
	threshold_id integer NOT NULL PRIMARY KEY,
	minimum integer NOT NULL default 0,
	maximum integer NOT NULL default 30,
	date_created timestamp NOT NULL DEFAULT NOW(),
	date_updated timestamp
);

--
-- Log Table
--	the "combined_output" column interweaves STDOUT and STDERR outputs in the 
--	order they occurred (or close to it).
--
CREATE TABLE cswc_log_table (
	log_id serial NOT NULL PRIMARY KEY,
	script_id integer NOT NULL REFERENCES cswc_script_table(script_id),
	full_command text NOT NULL,
	daemon_id integer NOT NULL REFERENCES cswc_daemon_table(daemon_id),
	start_time timestamp NOT NULL DEFAULT NOW(),
	last_checkin timestamp,
	end_time timestamp,
	stdout text,
	stderr text,
	combined_output text,
	exit_code integer
);


--
-- Create our user (NOTE::: when loading this, the password should be modified
--		to be whatever is set during setup.
--
--CREATE USER cli WITH UNENCRYPTED PASSWORD '{dbPass}';
-- 
-- GRANT ALL ON SCHEMA public TO cli;
-- GRANT ALL ON TABLE cswc_host_table TO cli;
-- GRANT ALL ON TABLE cswc_internal_log_table TO cli;
-- GRANT ALL ON TABLE cswc_log_table TO cli;
-- GRANT ALL ON TABLE cswc_script_table TO cli;
-- 
-- 
-- INSERT INTO cswc_internal_log_table (log_data) VALUES ('Database initialized, {project} v{version}');

