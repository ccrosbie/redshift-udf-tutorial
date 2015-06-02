create function f_z_test_by_pval(alpha float, x_bar float, test_val float, sigma float, n float)
--An independent one-sample z-test is used to test whether the average of a sample differ significantly from a population mean. 
--INPUTS:
-- alpha = sigificant level which we will accept or reject at
-- x_bar = sample mean
-- test_val = specified value to be test
-- sigma = population standard deviation
-- n = size of the sample 

 RETURNS varchar
 --OUTPUT: an accept or reject based on the alpha value passed in. 
STABLE 
AS $$

 import scipy.stats as st
 import math as math

 z = (x_bar - test_val) / (sigma / math.sqrt(n)) 
 
 p = st.norm.cdf(z)
 if p <= alpha:
   return 'Accept'
 else:
   return 'Reject'
 
$$LANGUAGE plpythonu;
