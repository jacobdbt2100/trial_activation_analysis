-- =============================================================================
-- fct_trial_activation.sql
-- Mart layer: flags which organisations have achieved "Trial Activation"
-- by completing all 5 trial goals.
--
-- Grain: one row per organization_id
--
-- Definition of Trial Activation:
--   An organisation is "Activated" when it has completed all 5 trial goals,
--   demonstrating that it has experienced the core value of the platform
--   across scheduling creation, management, visibility, attendance, and
--   early product features diversity.
-- =============================================================================

WITH goals AS (

    -- Base table containing trial goal completion flags
    SELECT
        organization_id,
        converted,
        converted_at,
        trial_start,
        trial_end,

        -- Individual goal completion flags
        goal_1_core_scheduling,
        goal_2_schedule_management,
        goal_3_mobile_visibility,
        goal_4_time_tracking,
        goal_5_early_activity_breadth,

        -- Total number of goals completed
        goals_completed_count

    FROM {{ ref('fct_trial_goals') }}

),

final AS (

    SELECT
        organization_id,
        converted,
        converted_at,
        trial_start,
        trial_end,

        -- Goal completion visibility --
        -- Expose individual goal flags for transparency and analysis
        goal_1_core_scheduling,
        goal_2_schedule_management,
        goal_3_mobile_visibility,
        goal_4_time_tracking,
        goal_5_early_activity_breadth,
        goals_completed_count,

        -- Activation flag --
        -- TRUE when all defined goals are completed
        CASE
            WHEN goals_completed_count = 5 THEN TRUE
            ELSE FALSE
        END AS is_activated,

        -- Activation tier segmentation --
        -- Groups organisations by engagement depth
        CASE
            WHEN goals_completed_count = 5 THEN 'Fully Activated'
            WHEN goals_completed_count >= 3 THEN 'Partially Activated'
            WHEN goals_completed_count >= 1 THEN 'Early Engaged'
            ELSE 'Dormant'
        END AS activation_tier,

        -- Time-to-activation metric --
        -- Measures days from trial start to conversion
        -- Only calculated for fully activated and converted organisations
        CASE
            WHEN goals_completed_count = 5
                 AND converted_at IS NOT NULL
            THEN ROUND(
                EXTRACT(EPOCH FROM (converted_at - trial_start)) / 86400.0,
                2
            )
            ELSE NULL
        END AS days_from_trial_start_to_goals_and_conversion,

        -- Metadata --
        CURRENT_TIMESTAMP AS updated_at

    FROM goals

)

-- Final output table
SELECT
    organization_id,
    converted,
    converted_at,
    trial_start,
    trial_end,

    goal_1_core_scheduling,
    goal_2_schedule_management,
    goal_3_mobile_visibility,
    goal_4_time_tracking,
    goal_5_early_activity_breadth,
    goals_completed_count,

    is_activated,
    activation_tier,
    days_from_trial_start_to_goals_and_conversion,
    updated_at

FROM final
