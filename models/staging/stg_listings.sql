{{
    config(
        materialized='view'
    )
}}

with raw_listings as (
    select 
    *
    from {{ ref('raw_listings') }}
),

regular_prices as (SELECT 
  listing_id,
  listing_name,
  room_type,
  CASE
    WHEN minimum_nights = 0 THEN 1
    ELSE minimum_nights
  END AS minimum_nights,
  host_id,
  REPLACE(
    price_str,
    '$'
  ) :: NUMBER(
    10,
    2
  ) AS price,
  created_at,
  date(created_at) as created_date,
  updated_at,
  date(updated_at) as updated_date
FROM
  raw_listings
)

select 
listing_id, 
listing_name, room_type, 
minimum_nights, host_id,
price,
case when room_type = 'Entire home/apt' then round(price * 0.90,1)
     when room_type = 'Private room' then round(price * 0.95,1)
     ELSE NULL
     END as discount_price,
created_at,
created_date,
updated_at,
updated_date

from 
regular_prices