-- DROP FUNCTION bikes_api.html_tr_bike_stock_input(int4);

CREATE OR REPLACE FUNCTION bikes_api.html_tr_bike_stock_input(_bike_id integer)
 RETURNS bikes_api."text/html"
 LANGUAGE sql
AS $function$
	select string_agg(format(
	   '<tr>
	        <td class="size">%1$s</td>
	        <td><sl-input name="%1$s-%2$s-quantity" size="small" class="qty" type="number"  min="0" value="%3$s"></sl-input></td>
	        <td>
	            <sl-input name="%1$s-%2$s-offer_price" class="price" size="small" type="text" inputmode="numeric" min="0" pattern="^[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$" value="%4$s">
	                <sl-icon name="currency-pound" slot="prefix"></sl-icon>
	            </sl-input>
	        </td>
	    </tr>',
	    t.frame_size, coalesce(t.bike_stock_seq,0),
	    t.quantity, t.offer_price
	    ),'') as html
	from (
	select bike_sizes.frame_size, bike_sizes.size_order, stock.bike_stock_seq, stock.quantity, stock.offer_price, stock.colour, stock.wheel_size from (
	-- TREK sizes
	select fs.frame_size, fs.size_order, bc.bike_id
	  from bikes.bike_component bc
	 cross join unnest(string_to_array(details,',')) as dets
	  join bikes.frame_size as fs on substring(dets, '[XSML/]+') = fs.frame_size
	 where bc.component_type = 'Sizes'
	union
	-- Giant sizes
	select distinct s as frame_size, fs.size_order, bc.bike_id --, bs.quantity, bs.offer_price, bs.bike_stock_seq
	  from bikes.bike_component bc
	 cross join unnest(bc.sizes) as s
	  join bikes.frame_size fs on fs.frame_size = s
	 where bc.component_type like '*%' -- only TREK have *
	) as bike_sizes
	left join bikes.bike_stock as stock on stock.bike_id = bike_sizes.bike_id and stock.frame_size = bike_sizes.frame_size
	where bike_sizes.bike_id = _bike_id
	  order by bike_sizes.size_order
	) as t; 
$function$
;
