CREATE FUNCTION f_init_list_agg ()
  RETURNS varchar
IMMUTABLE
AS $$
  return ''
$$ LANGUAGE plpythonu;

CREATE FUNCTION f_agg_list_agg (state varchar, a varchar)
  RETURNS varchar
STABLE
AS $$
  if state:
    return state + ', ' + a
  return a
$$ LANGUAGE plpythonu;


CREATE FUNCTION f_fin_list_agg (a varchar)
  RETURNS varchar
STABLE 
AS $$
  if a:
    return a
  return ''
$$ LANGUAGE plpythonu;


CREATE AGGREGATE f_list_agg (varchar) 
(
initfunc = f_init_list_agg,
aggfunc = f_agg_list_agg,
finalizefunc = f_fin_list_agg
);
