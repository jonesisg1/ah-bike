-- DROP FUNCTION bikes.html_bike_detail(int4);

CREATE OR REPLACE FUNCTION bikes.html_bike_detail(_bike_id integer)
 RETURNS "text/html"
 LANGUAGE sql
AS $function$
	select format(
		'<div class="m-3 min-w-72">
			<img loading="lazy" src="%2$s/%1$s" alt="Image of %1$s" class="mx-auto"/>
			<h3 class="pb-3" style="text-align: center;">%3$s %4$s <small>(%6$s)</small></h3>
			<table class="table-auto">
				<thead>
					<tr>
					  <th>Specification</th>
					</tr>
				</thead>
				<tbody>
					%5$s
				</tbody>
			</table>
		</div>',
		b.img_src, /* 1 */
		lower(b.brand), 
		b.brand,
		b.model_name,
		bikes.html_tr_bike_spec(_bike_id),
		b.model_year /* 6 */)
	  from bikes.bike_view b
	 where b.bike_id = _bike_id;
$function$
;
