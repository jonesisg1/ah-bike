-- DROP FUNCTION bikes_api.html_bike_cards(int4, text);

CREATE OR REPLACE FUNCTION bikes_api.html_bike_cards(_row_limit integer DEFAULT 0, _options text DEFAULT '{"order":"model_name ASC","filters":{},"priceFrom":"100", "priceTo":"1500"}'::text)
 RETURNS bikes_api."text/html"
 LANGUAGE plpgsql
AS $function$
declare
  v_query text;
  v_return text;
begin
	  if coalesce(_options::json->>'gridTree','Grid') = 'Grid' then
		  v_query := format(
		  $$ select coalesce (string_agg(html_bike_card, '')||
				case when 
		  	 		(select count(1) 
		  	 		   from bikes.bike_view sq
		  	 	 	  where %3$s
		  	 	 	   and  sq.bike_type = '%6$s'
		  	 	 	   and ((lower(sq.model_name) like '%7$s') or ('%7$s' = ''))
			    		and sq.book_price_from between %4$s and %5$s) = max(row_cnt)
			    	then '<div id="EoF" class="invisible"></div>'
			    	else ''
			    end, '<div id="EoF" class="invisible"></div><div class="mx-3 mt-3"><p>No matching bikes found</p></div>')
		   from
		(select bikes.html_bike_card(b) as html_bike_card,
				row_number () over (order by b.%1$s) as row_cnt
		   from bikes.bike_view b
		  where %3$s
		    and b.book_price_from between %4$s and %5$s
		    and b.bike_type = '%6$s'
		    and ((lower(b.model_name) like '%7$s') or ('%7$s' = ''))
		   order by b.%1$s
		   limit %2$s) sq $$,
		coalesce(replace(_options::json->>'order','-',' '),'model_name'),
		_row_limit,
		bikes.build_where_sql(_options::json->'filters'),
		coalesce((_options::json->>'priceFrom'), '0')::numeric * 100,
		coalesce((_options::json->>'priceTo'), '9999999')::numeric * 100,
		coalesce((_options::json->>'bikeType'), 'Mountain'),
		lower(coalesce('%%'||(_options::json->>'search')||'%%', ''))
		  );
--		raise notice 'SQL: %', v_query;
		execute v_query into v_return;	 
 	else
		v_return = coalesce('<sl-tree id="bike-tree"><sl-icon name="plus-square" slot="expand-icon"></sl-icon><sl-icon name="dash-square" slot="collapse-icon"></sl-icon>'
							||nullif(bikes_api.html_bike_tree(_options),'')||'</sl-tree>',
							'<div class="mx-3 mt-3"><p>No matching bikes found</p></div>');
	end if;
  return v_return;
end
$function$
;
