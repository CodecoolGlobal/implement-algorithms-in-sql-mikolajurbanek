create or replace function get_sound_like(key_word varchar(20))
	 returns varchar(250)[]
   language plpgsql
  as
$$
DECLARE
	arr_words varchar(250)[];
	sound_like_words varchar(250)[];
	i varchar(250);  
	j integer;
	real_word varchar(250);
	encoded_key_word varchar(250);
	encoded_dict_word varchar(20);
	

BEGIN
encoded_key_word := get_encoded_word(key_word);

SELECT array_agg(word) INTO arr_words
      FROM soundex.word;



		  
        FOREACH i IN ARRAY arr_words
    LOOP 
		real_word := i;
		encoded_dict_word := get_encoded_word(i);
		if encoded_dict_word = encoded_key_word then
			sound_like_words := array_append(sound_like_words, real_word);
-- 			raise notice '%', encoded_dict_word;      (uncomment to see how program works)
-- 			raise notice '%', real_word;
			end if;
		
    END LOOP;

return sound_like_words;
end
$$;





-- HELPER FUNCTION BELOW!

create or replace function get_encoded_word(i varchar(20))
	returns varchar(250)
	language plpgsql
  as
$$
declare
j integer;
real_word varchar(250);
real_first_letter varchar(1);
coded_first_letter varchar(1);

BEGIN
			real_word := i;
			real_first_letter := left(i,1);
			coded_first_letter := translate(real_first_letter, 'aeiouyhwbfpvcgjkqsxzdtlmnr', '00000000111122222222334556') ;
			

 		i := translate(i, 'aeiouyhwbfpvcgjkqsxzdtlmnr', '00000000111122222222334556') ;
		
		i = replace(i, '11', '1');
		i = replace(i, '22', '2');
		i = replace(i, '33', '3');
		i = replace(i, '44', '4');
		i = replace(i, '55', '5');
		i = replace(i, '66', '6');
		i = replace(i, '77', '7');
		i = replace(i, '88', '8');
		i = replace(i, '99', '9');
		i = replace(i, '0', '');
		
		
		
		j := char_length(i);
		
		if left(i,1) = coded_first_letter then
			i = real_first_letter || right(i, j-1);
			else
			i = real_first_letterend;
		$$; || i;
			end if;
		
		
		
		

	if char_length(i)<4 then
		i = i || repeat('0', 4-char_length(i));
		else i = left(i, 4);
		end if;
		
		
		return i;
		end;
		$$;

SELECT get_sound_like('robert');


-- IT TAKES AROUND 7-8 SECONDS TO RETRIEVE THIS!