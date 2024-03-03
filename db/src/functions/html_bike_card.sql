-- DROP FUNCTION bikes.html_bike_card(bikes.bike_view);

CREATE OR REPLACE FUNCTION bikes.html_bike_card(_bike bikes.bike_view)
 RETURNS text
 LANGUAGE sql
 STABLE
AS $function$
select format(/*html*/'
	<div class="m-3 min-w-72 basis-80 grow">
		<sl-card class="zoom">
			<a href="/bike?id=%9$s">
			<img loading="lazy" src="%11$s/%8$s" alt="Image of %1$s" />
			<h4 class="pb-3">%2$s %1$s <small>(%10$s)</small></h4></a>
			%12$s
			<h6><strong>Frame Material: </strong>%4$s</h6>
			%13$s
			<h6><strong>Wheel Sizes: </strong>%3$s</h6>				
			<div slot="footer">
				<strong>Price:</strong> £%7$s
			</div>
		</sl-card>
	</div>',
  $1.model_name, $1.brand,
  $1.wheel_sizes, $1.frame_material,
  $1.fork_travel, $1.rear_travel,
  $1.book_price_from/100, $1.img_src, 
  $1.bike_id, $1.model_year,
  lower($1.brand),
  case when coalesce($1.fork_travel, '') = '' then ''
  	else format('<h6><strong>Fork Travel: </strong>%1$s</h6>',$1.fork_travel)
  end,
  case when coalesce($1.rear_travel, 0) = 0 then ''
  	else format('<h6><strong>Rear Travel: </strong>%1$s</h6>',$1.rear_travel)
  end
  );
$function$
;
