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
    b.bike_type,
    ft.fork_travel,
    w.wheel_sizes,
    bs.sizes_in_stock
   FROM bikes.bike b
     LEFT JOIN ( SELECT wsq.bike_id,
            string_agg(wsq.wheel_size, ', '::text) AS wheel_sizes
           FROM ( SELECT bws.bike_id,
                    bws.wheel_size
                   FROM bikes.bike_wheel_size bws
                  GROUP BY bws.bike_id, bws.wheel_size
                  ORDER BY bws.bike_id, bws.wheel_size) wsq
          GROUP BY wsq.bike_id) w ON w.bike_id = b.bike_id
     LEFT JOIN ( SELECT ftq.bike_id,
            string_agg(ftq.fork_travel, ', '::text) AS fork_travel
           FROM ( SELECT bft.bike_id,
                    bft.fork_travel::text AS fork_travel
                   FROM bikes.bike_fork_travel bft
                  GROUP BY bft.bike_id, bft.fork_travel
                  ORDER BY bft.bike_id, bft.fork_travel) ftq
          GROUP BY ftq.bike_id) ft ON ft.bike_id = b.bike_id
     LEFT JOIN ( SELECT bike_stock_view.bike_id,
            string_agg(bike_stock_view.frame_size, ','::text) AS sizes_in_stock
           FROM bikes.bike_stock_view
          GROUP BY bike_stock_view.bike_id) bs ON bs.bike_id = b.bike_id;