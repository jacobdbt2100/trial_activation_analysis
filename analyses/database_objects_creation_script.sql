
CREATE DATABASE trial_to_conversion_analytics_dev;

CREATE SCHEMA source_schema_trial_to_conversion_dev;

CREATE TABLE source_schema_trial_to_conversion_dev.trial_events (
    ORGANIZATION_ID		VARCHAR(50),
    ACTIVITY_NAME		VARCHAR(50),
    TIMESTAMP			TIMESTAMP,
    CONVERTED			BOOLEAN,
    CONVERTED_AT		TIMESTAMP,
    TRIAL_START			TIMESTAMP,
    TRIAL_END			TIMESTAMP
);

-- inspect table
select * from source_schema_trial_to_conversion_dev.trial_events limit 3;
