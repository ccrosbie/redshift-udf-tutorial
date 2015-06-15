CREATE FUNCTION f_init_iqr ()
  RETURNS varchar
IMMUTABLE
AS $$
  return ''
$$ LANGUAGE plpythonu;


CREATE FUNCTION f_agg_iqr (state varchar, a float)
  RETURNS varchar
STABLE
AS $$
  if state:
    return state + ', ' + str(a)
  return str(a)
$$ LANGUAGE plpythonu;


CREATE FUNCTION f_fin_iqr (a varchar)
  RETURNS float
STABLE 
AS $$ 
	import numpy as numpy
	if a:
   		arr = numpy.array(a.split(","),numpy.float)  
   		x = numpy.percentile(arr, 75) - numpy.percentile(arr, 25)
	else:
   		x = 0
$$ LANGUAGE plpythonu;


CREATE AGGREGATE f_iqr (float) 
(
initfunc = f_init_iqr,
aggfunc = f_agg_iqr,
finalizefunc = f_fin_iqr
);
