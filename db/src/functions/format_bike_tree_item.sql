-- DROP FUNCTION bikes.format_bike_tree_item(bikes.bike_tree_row);

CREATE OR REPLACE FUNCTION bikes.format_bike_tree_item(bikes.bike_tree_row)
 RETURNS text
 LANGUAGE sql
 STABLE
AS $function$
	select format('%s%s%s%s',
	 format('%s%s'
			,case 
				when coalesce($1.prev_brand,'#N') = '#N' then ''
				when $1.cur_brand != coalesce($1.prev_brand,'#N') then '</sl-tree-item></sl-tree-item>'
				else ''
		      end
		    ,case 
			    when coalesce($1.prev_brand,'#N') = '#N' then '<sl-tree-item expanded>'||$1.cur_brand
			    when $1.cur_brand != coalesce($1.prev_brand,'#N') then '<sl-tree-item expanded>'||$1.cur_brand
				else ''
		      end) --as brand
	 ,format('%s%s'
			,case 
				when coalesce($1.prev_model_family,'#N') = '#N' then ''
				when $1.cur_brand != coalesce($1.prev_brand,'#N') then ''
				when $1.cur_model_family != coalesce($1.prev_model_family,'#N') then '</sl-tree-item>'
				else ''
		      end
		    ,case 
			    when coalesce($1.prev_model_family,'#N') = '#N' then '<sl-tree-item>'||$1.cur_model_family
			    when $1.cur_model_family != coalesce($1.prev_model_family,'#N') then '<sl-tree-item>'||$1.cur_model_family
				else ''
		      end) --as model_family
	 ,format('<sl-tree-item>%s</sl-tree-item>',$1.cur_model_yr) --as model_name
	 ,format('%s',case when $1.cur_row_number = $1.last_row then '</sl-tree-item></sl-tree-item>' else '' end));
$function$
;
