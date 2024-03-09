-- bikes.bike_tree_row definition

-- DROP TYPE bikes.bike_tree_row;

CREATE TYPE bikes.bike_tree_row AS (
	bike_id int8,
	brand text,
	model_family text,
	model_yr text,
	row_num int8,
	prev_brand text,
	prev_model_family text,
	prev_model_yr text,
	prev_row_number int8,
	last_row int8);