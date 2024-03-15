-- bikes.bike_stock definition

-- Drop table

-- DROP TABLE bikes.bike_stock;

CREATE TABLE bikes.bike_stock (
	bike_stock_seq bigserial NOT NULL,
	bike_id int4 NOT NULL,
	frame_size text NOT NULL,
	colour text NULL,
	wheel_size text NULL,
	bike_shop_id int4 NULL,
	quantity int4 NOT NULL,
	offer_price int4 NULL
);