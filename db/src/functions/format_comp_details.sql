-- DROP FUNCTION bikes.format_comp_details(text);

CREATE OR REPLACE FUNCTION bikes.format_comp_details(_details text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
  -- Swap ML for MZ and XS for XZ to aviod confusion with L and S
  vDetails text := replace(replace(replace(_details, 'ML', 'MZ'), 'XXS', 'XYZ' ), 'XS', 'XZ');
  vLeft text;
  remain text;
  sizes text:= 'R1,R2,R3,XYZ,XZ,S,M,MZ,L,XL,XXL';
  subSizes text:= 'S,M,L,XL';
  i integer;
  pos integer;
begin
  for i in reverse 8..1 loop
  	pos := strpos(vDetails, split_part(sizes,',',i));
	if pos > 0 then
		vLeft := substring(vDetails from 1 for pos - 1 + length(split_part(sizes,',',i)));
-- 		raise notice '% - %- %',i, pos, vLeft;
		if pos = 1 
		or strpos(replace(sizes, ',', ''), replace(replace(vLeft, ',', ''), ' ', '')) > 0  
		or strpos(replace(subSizes, ',', ''), replace(replace(vLeft, ',', ''), ' ', '')) > 0 then
			remain := format('%1$s - %2$s', replace(replace(replace(vLeft, 'MZ', 'ML'), 'XZ', 'XS'), 'XYZ', 'XXS'), substring(vDetails from pos + length(split_part(sizes,',',i))));
-- 			raise notice '% %', split_part(sizes,',',i), substring(_details from pos + length(split_part(sizes,',',i)));
			exit;
		end if;
	end if;
  end loop;
  return remain;
end
$function$
;
