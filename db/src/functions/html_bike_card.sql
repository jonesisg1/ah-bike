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
			%12$s<br>
			<div class="bike-card-badge-wrapper flex justify-center items-center">
				<div id="bike-edit-area-%9$s"></div>
				<sl-badge id="price-badge" variant="neutral" pill><sl-format-number type="currency" currency="GBP" value="%7$s" lang="en-GB"></sl-format-number></sl-badge>
				%13$s
			</div>
		</sl-card>
	</div>
	<style>
    .bike-card-badge-wrapper>sl-badge::part(base) {
        margin: 0.25rem;
        font-size: inherit;
    }
	</style>',
  $1.model_name, $1.brand,
  $1.wheel_sizes, $1.frame_material,
  $1.fork_travel, $1.rear_travel,
  $1.book_price_from/100, $1.img_src, 
  $1.bike_id, $1.model_year,
  lower($1.brand),
  format('%1$s%2$s%3$s %4$s %5$s Bike.',
      coalesce($1.wheel_sizes ||' wheel ', ''),
	  coalesce($1.fork_travel || coalesce('/'|| nullif($1.rear_travel,'0'),'') || 'mm travel ', ''),
	  $1.frame_material, $1.category, $1.bike_type),
  case when current_setting('request.jwt.claims', true)::json->>'role' = 'bike_user' 
  	then 
   '<sl-button class="stock-btn" variant="primary" size="small" outline data-bike-id='||$1.bike_id||'>
    	<sl-icon slot="prefix" name="bar-chart-line" style="font-size: 1rem;"></sl-icon>
    	Stock
  	</sl-button>'
  	else ''
  end
  );
$function$
;
