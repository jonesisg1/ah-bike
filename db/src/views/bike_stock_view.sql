-- bikes.bike_stock_view source

CREATE OR REPLACE VIEW bikes.bike_stock_view
AS SELECT bike_id,
    frame_size,
    quantity
   FROM ( SELECT bs_1.bike_id,
            bs_1.frame_size,
            bs_1.quantity
           FROM bikes.bike_stock bs_1
             JOIN bikes.frame_size fs ON fs.frame_size = bs_1.frame_size
          WHERE bs_1.bike_stock_seq = (( SELECT max(cur.bike_stock_seq) AS max
                   FROM bikes.bike_stock cur
                  WHERE cur.bike_id = bs_1.bike_id AND cur.frame_size = bs_1.frame_size AND COALESCE(cur.colour, '#'::text) = COALESCE(bs_1.colour, '#'::text))) AND bs_1.quantity > 0
          ORDER BY bs_1.bike_id, fs.size_order) bs;