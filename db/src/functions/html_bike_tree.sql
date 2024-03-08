-- DROP FUNCTION bikes.html_bike_tree(text);

CREATE OR REPLACE FUNCTION bikes.html_bike_tree(_options text DEFAULT '{"order":"model_name ASC","filters":{},"priceFrom":"100", "priceTo":"1500"}'::text)
 RETURNS "text/html"
 LANGUAGE plpgsql
AS $function$
declare
--	_options json := '{"order":"model_name ASC","filters":{},"priceFrom":"100", "priceTo":"1500", "bike_type":"Mountain"}'::json;
	v_query text;
	v_return text;
begin
	v_query = format($sql$
	select string_agg(bikes.format_bike_tree_item(q2),'')
	from (select q.* from ((
		select 
	 		brand as cur_brand, model_family as cur_model_family, model_name||' ('||model_year||')' as cur_model_yr, 
	 		row_number() over(order by brand, model_family, model_name||' ('||model_year||')') as cur_row_number
	 	 from bikes.bike_view 
	 	where %1$s
		  and book_price_from between %2$s and %3$s
		  and bike_type = '%4$s'
		  and ((lower(model_name) like '%5$s') or ('%5$s' = ''))
	 	order by 1,2,3) cur
	left join (
	   select 
			brand as prev_brand, model_family as prev_model_family, model_name||' ('||model_year||')' as prev_model_yr, 
			row_number() over(order by brand, model_family, model_name||' ('||model_year||')') as prev_row_number
	     from bikes.bike_view 
	    where %1$s
		  and book_price_from between %2$s and %3$s
		  and bike_type = '%4$s'
		  and ((lower(model_name) like '%5$s') or ('%5$s' = ''))
	    order by 1,2,3) prev on prev_row_number = cur_row_number -1
	join (
		select count(1) as last_row from bikes.bike_view 
		 where %1$s
		  and book_price_from between %2$s and %3$s
		  and bike_type = '%4$s'
		  and ((lower(model_name) like '%5$s') or ('%5$s' = ''))) c on true
	) q order by q.cur_row_number ) q2
$sql$,
	bikes.build_where_sql(_options::json->'filters'),
	coalesce((_options::json->>'priceFrom'), '0')::numeric * 100,
	coalesce((_options::json->>'priceTo'), '9999999')::numeric * 100,
	coalesce((_options::json->>'bikeType'), 'Mountain'),
	lower(coalesce('%%'||(_options::json->>'search')||'%%', ''))
	);
	execute v_query into v_return;
--	raise notice '%', v_return;
	return v_return;
end;
$function$
;
