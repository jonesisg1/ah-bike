-- DROP FUNCTION bikes_api.html_bike_filters(text);

-- DROP FUNCTION bikes_api.html_bike_filters(text);

CREATE OR REPLACE FUNCTION bikes_api.html_bike_filters(_options text DEFAULT '{}'::text)
 RETURNS bikes_api."text/html"
 LANGUAGE sql
 STABLE
AS $function$
select string_agg(html, '') from (
	select format(
		'<sl-details summary="%1$s" class="mt-3 text-filter" open>
			%2$s		
		</sl-details>',
		'Category',
		string_agg(bikes.html_filter_checkbox('category', b.cat,
			_options::jsonb#>'{filters,category}' @> format('"%1$s"',b.cat)::jsonb ), '')
		) as html
	 from (select distinct category as cat
		  from bikes.bike 
		  where bike_type = coalesce((_options::json->>'bikeType'), 'Mountain')
		  order by 1) as b
union
	select format(
		'<sl-details summary="%1$s" class="mt-3 text-filter" open>
			%2$s		
		</sl-details>',
		'Frame Material',
		string_agg(bikes.html_filter_checkbox('frame_material', b.fm,
			_options::jsonb#>'{filters,frame_material}' @> format('"%1$s"',b.fm)::jsonb ), '')
		) as html
	 from (select distinct frame_material as fm
		  from bikes.bike
		  where frame_material is not null
		  and bike_type = coalesce((_options::json->>'bikeType'), 'Mountain')
		  order by 1) as b
union
	select case when coalesce((_options::json->>'bikeType'), 'Mountain') = 'Mountain' then 
		format(
		'<sl-details summary="%1$s" class="mt-3" open>
			%2$s		
		</sl-details>',
		'Fork Travel',
		string_agg(bikes.html_filter_checkbox('fork_travel', b.ft::text,
			_options::jsonb#>'{filters,fork_travel}' @> format('"%1$s"',b.ft::text)::jsonb ), '')
		)
		else '' end as html
	 from (select distinct fork_travel as ft
		  from bikes.bike_fork_travel
		  where coalesce((_options::json->>'bikeType'), 'Mountain') = 'Mountain'
		  order by 1) as b
union
	select format(
		'<sl-details summary="%1$s" class="mt-3" open>
			%2$s		
		</sl-details>',
		'Wheel Sizes',
		string_agg(bikes.html_filter_checkbox('wheel_sizes', b.ws::text,
			_options::jsonb#>'{filters,wheel_sizes}' @> format('"%1$s"',b.ws::text)::jsonb ), '')
		) as html
	 from (select distinct wheel_size as ws
		  from bikes.bike_wheel_size w join bikes.bike b on b.bike_id = w.bike_id
		  where wheel_size is not null
		  and bike_type = coalesce((_options::json->>'bikeType'), 'Mountain')
		  order by 1) as b
union
	select case when coalesce((_options::json->>'bikeType'), 'Mountain') = 'Mountain' then 
		format(
		'<sl-details summary="%1$s" class="mt-3" open>
			%2$s		
		</sl-details>',
		'Rear Travel',
		string_agg(bikes.html_filter_checkbox('rear_travel', b.rt::text,
			_options::jsonb#>'{filters,rear_travel}' @> format('"%1$s"',b.rt::text)::jsonb ), '')
		)
		else '' end as html
 	 from (select distinct rear_travel as rt
		  from bikes.bike 
		  where coalesce((_options::json->>'bikeType'), 'Mountain') = 'Mountain'
		  order by 1) as b
union
	select format(
		'<sl-details summary="%1$s" class="mt-3" open>
			%2$s		
		</sl-details>',
		'Model Year',
		string_agg(bikes.html_filter_checkbox('model_year', b.my::text,
			_options::jsonb#>'{filters,model_year}' @> format('"%1$s"',b.my::text)::jsonb ), '')
		) as html
 	 from (select distinct model_year as my
		  from bikes.bike 
		  where bike_type = coalesce((_options::json->>'bikeType'), 'Mountain')
		  order by 1) as b
union
	select format(
		'<sl-details summary="%1$s" class="mt-3 text-filter" open>
			%2$s		
		</sl-details>',
		'Brand',
		string_agg(bikes.html_filter_checkbox('brand', b.fm,
			_options::jsonb#>'{filters,brand}' @> format('"%1$s"',b.fm)::jsonb ), '')
		) as html
	 from (select distinct brand as fm 
		  from bikes.bike 
		  where bike_type = coalesce((_options::json->>'bikeType'), 'Mountain')
		  order by 1) as b
union
	select format(
		'<sl-details summary="%1$s" class="mt-3" open>
			%2$s		
		</sl-details>',
		'Sizes In Stock',
		string_agg(bikes.html_filter_checkbox('sizes_in_stock', b.fs::text,
			_options::jsonb#>'{filters,sizes_in_stock}' @> format('"%1$s"',b.fs::text)::jsonb 
			), '')
		) as html
	 from (select distinct bsv.frame_size as fs, fs.size_order
		  from bikes.bike_stock_view bsv 
		  join bikes.bike b on b.bike_id = bsv.bike_id
		  join bikes.frame_size as fs on fs.frame_size = bsv.frame_size
		  where bike_type = coalesce((_options::json->>'bikeType'), 'Mountain')
		  order by fs.size_order) as b
order by 1
) as main;
$function$
;
;
