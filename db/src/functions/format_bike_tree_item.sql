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
				when $1.brand != coalesce($1.prev_brand,'#N') then '</sl-tree-item></sl-tree-item>'
				else ''
		      end
		    ,case 
			    when coalesce($1.prev_brand,'#N') = '#N' then '<sl-tree-item expanded>'||$1.brand
			    when $1.brand != coalesce($1.prev_brand,'#N') then '<sl-tree-item expanded>'||$1.brand
				else ''
		      end) --as brand
	 ,format('%s%s'
			,case 
				when coalesce($1.prev_model_family,'#N') = '#N' then ''
				when $1.brand != coalesce($1.prev_brand,'#N') then ''
				when $1.model_family != coalesce($1.prev_model_family,'#N') then '</sl-tree-item>'
				else ''
		      end
		    ,case 
			    when coalesce($1.prev_model_family,'#N') = '#N' then '<sl-tree-item>'||$1.model_family
			    when $1.model_family != coalesce($1.prev_model_family,'#N') then '<sl-tree-item>'||$1.model_family
				else ''
		      end) --as model_family
	 ,format('<sl-tree-item><a href="/bike?id=%s">%s</a>%s</sl-tree-item>',$1.bike_id,$1.model_yr,
  case when current_setting('request.jwt.claims', true)::json->>'role' = 'bike_user' 
  	then 
   '<sl-button class="stock-btn" variant="primary" size="small" outline data-bike-id='||$1.bike_id||' style="padding-left:0.5rem;">
    	<sl-icon slot="prefix" name="bar-chart-line" style="font-size: 1rem;"></sl-icon>
    	Stock
  	</sl-button>'
  	else ''
  end) --as model_name
	 ,format('%s',case when $1.row_num = $1.last_row then '</sl-tree-item></sl-tree-item>' else '' end));
$function$
;
