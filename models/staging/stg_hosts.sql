{{
    config(
        materialized='view'
    )
}}



WITH raw_hosts AS (
    SELECT
        *
    FROM
        {{ ref('raw_hosts') }}
)
SELECT
    host_id,
    NVL(
        host_name,
        'Anonymous'
    ) AS host_name,
    is_superhost,
    created_at,
    date(created_at) as created_date,
    updated_at,
    date(updated_at) as updated_date
FROM
    raw_hosts