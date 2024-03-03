-- DROP FUNCTION bikes.html_tr_bike_spec(int4);

CREATE OR REPLACE FUNCTION bikes.html_tr_bike_spec(_bike_id integer)
 RETURNS text
 LANGUAGE sql
AS $function$
  select 
	string_agg(format('<tr><td><strong>%1$s</strong> - %2$s</td></tr>',
	bc.component_type, coalesce(replace(translate(bc.sizes::text, '{}', ''), ',', ', ')||' - ', '')||bc.details), '') html_row
 	from bikes.bike_component bc
	join bikes.bike b on b.bike_id = bc.bike_id
	where b.bike_id = _bike_id;
$function$
;
