-- =============================================================================
-- fct_trial_goals.sql
-- Mart layer: tracks whether each trialist organisation has completed
-- each of the 5 defined trial goals.
--
-- Grain: one row per organization_id
--
-- Trial Goals (evidence-based hypotheses):
-- Goal 1 - Core Scheduling   	   : Created >= 5 shifts
-- Goal 2 - Schedule Mgmt     	   : Applied a template OR approved >= 1 shift
-- Goal 3 - Mobile Visibility 	   : Loaded mobile schedule >= 3 times
-- Goal 4 - Time Tracking		   : Recorded >= 1 punch-in
-- Goal 5 - Early Activity Breadth : >= 3 unique activities in first 7 days
-- =============================================================================

WITH events AS (

    SELECT * FROM {{ ref('stg_trial_events') }}

),

-- org spine
org_spine AS (

    SELECT DISTINCT
        organization_id,
        converted,
        converted_at,
        trial_start,
        trial_end
    FROM events

),

-- goal 1: core scheduling
goal_1 AS (

    SELECT
        organization_id,
        COUNT(*) AS shifts_created
    FROM events
    WHERE activity_name = 'Scheduling.Shift.Created'
    GROUP BY 1

),

-- goal 2: schedule managemen
goal_2 AS (

    SELECT
        organization_id,

        COUNT(*) FILTER (
            WHERE activity_name =
            'Scheduling.Template.ApplyModal.Applied'
        ) AS templates_applied,

        COUNT(*) FILTER (
            WHERE activity_name =
            'Scheduling.Shift.Approved'
        ) AS shifts_approved

    FROM events
    GROUP BY 1

),

-- goal 3: mobile schedule visibility
goal_3 AS (

    SELECT
        organization_id,
        COUNT(*) AS mobile_schedule_loads
    FROM events
    WHERE activity_name = 'Mobile.Schedule.Loaded'
    GROUP BY 1

),

-- goal 4: time tracking
goal_4 AS (

    SELECT
        organization_id,
        COUNT(*) AS punch_ins
    FROM events
    WHERE activity_name = 'PunchClock.PunchedIn'
    GROUP BY 1

),

-- goal 5: early activity breadth
goal_5 AS (
	
    SELECT
        organization_id,
        COUNT(DISTINCT activity_name) AS week1_unique_activity_count
    FROM events
    WHERE days_since_trial_start <= 7
    GROUP BY 1
	
),

-- combine
final AS (

    SELECT
        s.organization_id,
        s.converted,
        s.converted_at,
        s.trial_start,
        s.trial_end,

        -- goal 1 --
        COALESCE(g1.shifts_created, 0) AS shifts_created,

        CASE
            WHEN COALESCE(g1.shifts_created, 0) >= 5
            THEN TRUE ELSE FALSE
        END AS goal_1_core_scheduling,

        -- goal 2 --
        COALESCE(g2.templates_applied, 0) AS templates_applied,
        COALESCE(g2.shifts_approved, 0)   AS shifts_approved,

        CASE
            WHEN COALESCE(g2.templates_applied, 0) >= 1
              OR COALESCE(g2.shifts_approved, 0) >= 1
            THEN TRUE ELSE FALSE
        END AS goal_2_schedule_management,

        -- goal 3 --
        COALESCE(g3.mobile_schedule_loads, 0)
            AS mobile_schedule_loads,

        CASE
            WHEN COALESCE(g3.mobile_schedule_loads, 0) >= 3
            THEN TRUE ELSE FALSE
        END AS goal_3_mobile_visibility,

        -- goal 4 --
        COALESCE(g4.punch_ins, 0) AS punch_ins,

        CASE
            WHEN COALESCE(g4.punch_ins, 0) >= 1
            THEN TRUE ELSE FALSE
        END AS goal_4_time_tracking,

        -- goal 5 --
        COALESCE(g5.week1_unique_activity_count, 0) AS week1_unique_activity_count,

        CASE
            WHEN COALESCE(g5.week1_unique_activity_count, 0) >= 3
            THEN TRUE ELSE FALSE
        END AS goal_5_early_activity_breadth,

        -- summary
        (
            CASE WHEN COALESCE(g1.shifts_created, 0) >= 5 THEN 1 ELSE 0 END +
            CASE WHEN COALESCE(g2.templates_applied, 0) >= 1
                   OR COALESCE(g2.shifts_approved, 0) >= 1
                 THEN 1 ELSE 0 END +
            CASE WHEN COALESCE(g3.mobile_schedule_loads, 0) >= 3
                 THEN 1 ELSE 0 END +
            CASE WHEN COALESCE(g4.punch_ins, 0) >= 1
                 THEN 1 ELSE 0 END +
            CASE WHEN COALESCE(g5.week1_unique_activity_count, 0) >= 3
                 THEN 1 ELSE 0 END
        ) AS goals_completed_count,

        CURRENT_TIMESTAMP AS updated_at

    FROM org_spine s
    LEFT JOIN goal_1 g1
        ON s.organization_id = g1.organization_id
    LEFT JOIN goal_2 g2
        ON s.organization_id = g2.organization_id
    LEFT JOIN goal_3 g3
        ON s.organization_id = g3.organization_id
    LEFT JOIN goal_4 g4
        ON s.organization_id = g4.organization_id
    LEFT JOIN goal_5 g5
        ON s.organization_id = g5.organization_id

)

SELECT * FROM final
