--this assumes that f_init_iqr and f_agg_iqr have already been created
--see Create_IQR_Aggregate.sql for these functions. 

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

CREATE FUNCTION f_fin_upper_quartile (a varchar)
  RETURNS float
STABLE 
AS $$ 
	import numpy as numpy
	if a:
   		arr = numpy.array(a.split(","),numpy.float)  
   		x = numpy.percentile(arr, 75)
	else:
   		x = 0

   	return x
   	
$$ LANGUAGE plpythonu;


CREATE AGGREGATE f_lower_quartile (float) 
(
initfunc = f_init_iqr,
aggfunc = f_agg_iqr,
finalizefunc = f_fin_lower_quartile
);

CREATE AGGREGATE f_upper_quartile (float) 
(
initfunc = f_init_iqr,
aggfunc = f_agg_iqr,
finalizefunc = f_fin_upper_quartile
);
