-- bikes.bike definition

-- Drop table

-- DROP TABLE bikes.bike;

CREATE TABLE bikes.bike (
	bike_id int4 NOT NULL,
	created_at timestamptz NULL,
	bike_alt_ref text NULL,
	brand text NULL,
	category text NULL,
	model_family text NULL,
	model_name text NULL,
	model_year int4 NULL,
	frame_material text NULL,
	rear_travel int4 NULL,
	book_price_from int4 NULL,
	book_price_to int4 NULL,
	img_src text NULL,
	CONSTRAINT bike_pkey PRIMARY KEY (bike_id)
);