CREATE FUNCTION f_init_lower_quartile ()
  RETURNS varchar
IMMUTABLE
AS $$
  return ''
$$ LANGUAGE plpythonu;


CREATE FUNCTION f_agg_lower_quartile (state varchar, a float)
  RETURNS varchar
STABLE
AS $$
  if state:
    return state + ', ' + str(a)
  return str(a)
$$ LANGUAGE plpythonu;



CREATE FUNCTION f_fin_lower_quartile (a varchar)
  RETURNS float
STABLE 
AS $$ 
	import numpy as numpy
	if a:
   		arr = numpy.array(a.split(","),numpy.float)  
   		x = numpy.percentile(arr, 25)
	else:
   		x = 0

   	return x
   	
$$ LANGUAGE plpythonu;


CREATE AGGREGATE f_lower_quartile (float) 
(
initfunc = f_init_iqr,
aggfunc = f_agg_iqr,
finalizefunc = f_fin_iqr
);


