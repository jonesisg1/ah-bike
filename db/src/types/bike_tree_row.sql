-- bikes.bike_tree_row definition

-- DROP TYPE bikes.bike_tree_row;

CREATE TYPE bikes.bike_tree_row AS (
	cur_brand text,
	cur_model_family text,
	cur_model_yr text,
	cur_row_number int8,
	prev_brand text,
	prev_model_family text,
	prev_model_yr text,
	prev_row_number int8,
	last_row int8);