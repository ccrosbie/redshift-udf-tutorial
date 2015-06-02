
CREATE OR REPLACE CMS.STAT_RELEVANT_PHYSICIAN_SPECIALTY AS 
WITH POPULATION AS 
(
	 select avg(total_amount_of_payment_usdollars) AS comparison_mean,  
	 STDDEV_POP(total_amount_of_payment_usdollars) as stddevpop, 
	 count(*) as countpop 
	 from CMS.oppr_all_dtl_gnrl_12192014
),
SAMPLE AS 
(
	select f_return_general_specialty(physician_specialty) as general_speciality, 
	f_return_focused_speciality(physician_specialty) as focused_specialty, 
	avg(total_amount_of_payment_usdollars) as  sample_general_payments, 
	count(*) as sample_number_of_payments
	from cms.oppr_all_dtl_gnrl_12192014 gnrl 
	WHERE physician_specialty <> ''
	group by  f_return_general_specialty(physician_specialty), f_return_focused_speciality(physician_specialty)
),
TEST AS 
(
	--setting the p-value at .1 -- normally would want .05 but wanted a few more for demo purposes. 
	select  general_speciality, focused_specialty, sample_general_payments as avg_payments, 
	f_z_test_by_pval(.1, sample_general_payments, comparison_mean, stddevpop, sample_number_of_payments) as is_valid
	FROM POPULATION,SAMPLE 
	WHERE 1 = 1
)
select * from TEST
WHERE is_valid = 'Accept' 
