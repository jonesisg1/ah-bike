-- DROP FUNCTION bikes.build_where_sql(json);

CREATE OR REPLACE FUNCTION bikes.build_where_sql(_filters json)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
  v_query text := '(';
  v_return text;
  filter_name text;
  prev_filter_name text;
  filter_value text;
begin
	if coalesce(_filters::text, '{}') = '{}' then 
		return 'true'; 
	end if;
	for filter_name in (select * from json_object_keys(_filters)) loop
		for filter_value in (select * from json_array_elements_text( _filters->filter_name )) loop
			v_query := v_query || 
				case when prev_filter_name is null or prev_filter_name = filter_name then ' OR ' else ') AND (' end || 
				filter_name || 
				case when filter_name in ('fork_travel', 'wheel_sizes') 
					then format($l$ ~ '(^| )%1$s:'$l$, filter_value) 
					else format($e$ = '%1$s'$e$,filter_value) 
				end;
			prev_filter_name := filter_name;
		end loop;
	end loop;
  return '(' || trim (leading '( OR ' from v_query) || ')';
end
$function$
;
