-- DROP FUNCTION bikes_api.update_stock(text);

CREATE OR REPLACE FUNCTION bikes_api.update_stock(_options text)
 RETURNS bikes_api."text/html"
 LANGUAGE plpgsql
AS $function$
declare
  v_bike_id integer;
  v_return text;
begin
	select distinct bike_id into v_bike_id
	  from json_to_recordset(_options::json->'updates')
	    as rows("bike_id" integer, "frame_size" text, "bike_stock_seq" text, "quantity" text, "offer_price" text);
	
	insert into bikes.bike_stock (
	  bike_id, 
	  frame_size,
	  colour,
	  wheel_size,
	  bike_shop_id,
	  quantity,
	  offer_price,
	  user_email,
	  update_ts)
	select bike_id,
		   frame_size, 
		   null as colour, 
		   null as wheel_size, 
		   null as bike_shop_id, 
		   coalesce(nullif(quantity, ''), '0')::numeric as quantity,
		   case when nullif(offer_price,'') is null then null 
		   		else offer_price::numeric * 100
		   end as offer_price,
	       coalesce(current_setting('request.jwt.claims', true)::json->>'email','admin') as user_email,
	       current_timestamp
	from json_to_recordset(_options::json->'updates')
	  as rows("bike_id" integer, "frame_size" text, "bike_stock_seq" text, "quantity" text, "offer_price" text)
	;
	
  	return bikes_api.html_tr_bike_stock_input(v_bike_id)||'<tr class="invisible stock-updated"></tr>';
end
$function$
;
