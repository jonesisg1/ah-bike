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
				case when filter_name in ('fork_travel', 'wheel_sizes') 
					then format($l$ string_to_array(%1$s,',') @> '{%2$s}' $l$,filter_name, filter_value) 
					else format($e$ %1$s = '%2$s'$e$,filter_name, filter_value) 
				end;
			prev_filter_name := filter_name;
		end loop;
	end loop;
  return '(' || trim (leading '( OR ' from v_query) || ')';
end
$function$
;
