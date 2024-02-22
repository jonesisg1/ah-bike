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
			<img loading="lazy" src="trek/%8$s.webp" alt="Image of %1$s" />
			<h4 class="pb-3">%1$s <small>(%10$s)</small></h4></a>
			<h6><strong>Brand: </strong>%2$s</h6>
			<h6><strong>Wheel Sizes: </strong>%3$s</h6>
			<h6><strong>Frame Material: </strong>%4$s</h6>
			<h6><strong>Fork Travel: </strong>%5$s</h6>
			<h6><strong>Rear Travel: </strong>%6$s</h6>
			<div slot="footer">
				<strong>Price:</strong> £%7$s
			</div>
		</sl-card>
	</div>',
  $1.model_name, $1.brand, $1.wheel_sizes, $1.frame_material,
  $1.fork_travel, $1.rear_travel, $1.book_price_from/100,
  $1.img_src, $1.bike_id, $1.model_year);
$function$
;
