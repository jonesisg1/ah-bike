-- DROP FUNCTION bikes.html_filter_checkbox(text, text, bool);

CREATE OR REPLACE FUNCTION bikes.html_filter_checkbox(_filter_type text, _filter_value text, _checked boolean DEFAULT false)
 RETURNS text
 LANGUAGE sql
 STABLE
AS $function$
select format('
	<sl-checkbox
		id="%1$s-%4$s"
		data-filter-type="%1$s" 
		value="%2$s"
		hx-post="/api/proxy/html_bike_cards"
		hx-target="#bike-cards"
		hx-trigger="sl-change"
		%3$s
	>%2$s
	</sl-checkbox>',
	_filter_type,
	_filter_value,
	case when _checked then 'CHECKED' else '' end,
	replace(lower(_filter_value), ' ', '-')
	);
$function$
;
