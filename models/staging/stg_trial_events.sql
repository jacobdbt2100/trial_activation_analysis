-- =============================================================================
-- stg_trial_events.sql
-- Staging layer: casts, cleans and standardises the raw behavioural events table
-- Grain: one row per event (organization_id + activity_name + timestamp)
-- =============================================================================

-- config(materialized = 'view')

WITH source_data AS (

    -- Standardise data types from raw source
    SELECT
        CAST(organization_id AS text)        AS organization_id,
        CAST(activity_name AS text)          AS activity_name,
        CAST(timestamp AS timestamp)         AS event_timestamp,
        CAST(converted AS boolean)           AS converted,
        CAST(converted_at AS timestamp)      AS converted_at,
        CAST(trial_start AS timestamp)       AS trial_start,
        CAST(trial_end AS timestamp)         AS trial_end

    FROM {{ source('raw_trial_events', 'trial_events') }}

),

deduplicated AS (

    -- Remove exact duplicate events
    -- Grain enforced: organization_id + activity_name + event_timestamp
    SELECT
        organization_id,
        activity_name,
        event_timestamp,
        converted,
        converted_at,
        trial_start,
        trial_end,

        ROW_NUMBER() OVER (
            PARTITION BY
                organization_id,
                activity_name,
                event_timestamp
            ORDER BY event_timestamp
        ) AS row_num

    FROM source_data

),

cleaned AS (

    -- Keep unique events and derive reusable fields
    SELECT
        organization_id,
        activity_name,

        -- Extract functional module from dot-notation activity name
        SPLIT_PART(activity_name, '.', 1)
            AS activity_module,

        event_timestamp,
        converted,
        converted_at,
        trial_start,
        trial_end,

        -- Event timing relative to trial start (in fractional days)
        ROUND(
            EXTRACT(EPOCH FROM (event_timestamp - trial_start)) / 86400.0,
            2
        ) AS days_since_trial_start

    FROM deduplicated

    -- Retain first occurrence only
    WHERE row_num = 1

)

-- Final cleaned dataset at event grain
SELECT
    organization_id,
    activity_name,
    activity_module,
    event_timestamp,
    converted,
    converted_at,
    trial_start,
    trial_end,
    days_since_trial_start

FROM cleaned
