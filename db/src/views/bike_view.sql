-- bikes.bike_view source

CREATE OR REPLACE VIEW bikes.bike_view
AS SELECT b.bike_id,
    b.created_at,
    b.bike_alt_ref,
    b.brand,
    b.category,
    b.model_family,
    b.model_name,
    b.model_year,
    b.frame_material,
    b.rear_travel,
    b.book_price_from,
    b.book_price_to,
    b.img_src,
    ft.fork_travel,
    w.wheel_sizes
   FROM bikes.bike b
     JOIN ( SELECT unnamed_subquery.alt_ref,
            string_agg(((unnamed_subquery.wheel_size || ': ('::text) || unnamed_subquery.f_sizes) || ')'::text, ', '::text) AS wheel_sizes
           FROM ( SELECT bike_wheel_size.alt_ref,
                    bike_wheel_size.wheel_size,
                    string_agg(bike_wheel_size.frame_size, ', '::text) AS f_sizes
                   FROM bikes.bike_wheel_size
                  GROUP BY bike_wheel_size.alt_ref, bike_wheel_size.wheel_size
                  ORDER BY bike_wheel_size.alt_ref, bike_wheel_size.wheel_size) unnamed_subquery
          GROUP BY unnamed_subquery.alt_ref) w ON w.alt_ref = b.bike_alt_ref
     LEFT JOIN ( SELECT unnamed_subquery.alt_ref,
            string_agg(((unnamed_subquery.fork_travel || ': ('::text) || unnamed_subquery.f_sizes) || ')'::text, ', '::text) AS fork_travel
           FROM ( SELECT bike_fork_travel.alt_ref,
                    bike_fork_travel.fork_travel,
                    string_agg(bike_fork_travel.frame_size, ', '::text) AS f_sizes
                   FROM bikes.bike_fork_travel
                  GROUP BY bike_fork_travel.alt_ref, bike_fork_travel.fork_travel
                  ORDER BY bike_fork_travel.alt_ref, bike_fork_travel.fork_travel) unnamed_subquery
          GROUP BY unnamed_subquery.alt_ref) ft ON ft.alt_ref = b.bike_alt_ref;