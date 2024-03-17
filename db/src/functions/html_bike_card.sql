-- DROP FUNCTION bikes.html_bike_card(bikes.bike_view);

CREATE OR REPLACE FUNCTION bikes.html_bike_card(_bike bikes.bike_view)
 RETURNS text
 LANGUAGE sql
 STABLE
AS $function$
select format(/*html*/'
	<div class="bike-card-wrapper">
		<sl-card class="zoom">	
			<a href="/bike?id=%9$s">
			<img loading="lazy" src="%11$s/%8$s" alt="Image of %1$s" />
			<h4 class="pb-3">%2$s %1$s <small>(%10$s)</small></h4></a>
			%12$s
			<div class="bike-card-badge-wrapper flex justify-center gap-3">
				%14$s
				<sl-badge id="price-badge"  pill><sl-format-number class="%15$s" type="currency" currency="GBP" value="%7$s" lang="en-GB"></sl-format-number></sl-badge>
			</div>
			%13$s
		</sl-card>
	</div>
	<style>
    .bike-card-badge-wrapper>sl-badge::part(base) {
        margin-top: 0.75rem;
        font-size: inherit;
    }
.stock-wrapper { padding-top: 0.5rem; }
    sl-card::part(footer) {
        padding-top: 1rem;        
		padding-bottom: 1rem;        
    }
	.line-through {
		text-decoration-line: line-through;
	}
	sl-badge.sale-badge::part(base) { background-color: var(--sl-color-red-700); }
	</style>',
  $1.model_name, $1.brand,
  $1.wheel_sizes, $1.frame_material,
  $1.fork_travel, $1.rear_travel,
  $1.book_price_from/100, $1.img_src, 
  $1.bike_id, $1.model_year,
  lower($1.brand),
  format('%1$s%2$s%3$s %4$s %5$s Bike.%6$s',
      coalesce($1.wheel_sizes ||' wheel ', ''),
	  coalesce($1.fork_travel || coalesce('/'|| nullif($1.rear_travel,'0'),'') || 'mm travel ', ''),
	  $1.frame_material, $1.category, $1.bike_type, '<div class ="flex justify-center stock-wrapper"><span><strong>Sizes in stock:</strong> '||$1.sizes_in_stock||'</span></div>'),
  case when current_setting('request.jwt.claims', true)::json->>'role' = 'bike_user' 
  	then 
   '<div slot="footer" class ="flex justify-center"><sl-button class="stock-btn" variant="primary" size="small" outline data-bike-id='||$1.bike_id||'>
    	<sl-icon slot="prefix" name="bar-chart-line" style="font-size: 1rem;"></sl-icon>
    	Stock
  	</sl-button></div>'
  	else ''
  end,
  '<sl-badge class="sale-badge" pill><sl-format-number type="currency" currency="GBP" value="'||
  (select min(offer_price/100) from bikes.bike_stock_view bsv where bsv.bike_id = $1.bike_id)||
  '" lang="en-GB"></sl-format-number></sl-badge>',
  case when (select min(offer_price/100) from bikes.bike_stock_view bsv where bsv.bike_id = $1.bike_id) is not null then 'line-through' else '' end
  );
$function$
;
