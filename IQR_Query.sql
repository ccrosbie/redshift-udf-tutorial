select   
f_return_general_specialty(physician_specialty), f_return_focused_specialty(physician_specialty),
min(total_amount_of_payment_usdollars),
--MEDIAN(total_amount_of_payment_usdollars) OVER(partition by physician_specialty) as median_by_specialty, 
f_lower_quartile(total_amount_of_payment_usdollars), 
f_iqr(total_amount_of_payment_usdollars), 
f_upper_quartile(total_amount_of_payment_usdollars),
max(total_amount_of_payment_usdollars)
from cms.oppr_all_dtl_gnrl_12192014  
--where  f_return_focused_specialty(physician_specialty) = 'Orthopaedic Surgery'
group by f_return_general_specialty(physician_specialty), f_return_focused_specialty(physician_specialty)
