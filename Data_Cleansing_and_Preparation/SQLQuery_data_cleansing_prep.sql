---PART 1: CREATE TABLE IV.FDI---
--1. create FDI table and input raw data from excel file
create table FDI (
	country_name varchar(52) not null, 
	country_code char(3) not null,
	indicator_name varchar(49) not null, 
	indicator_code varchar(20) not null,
	[1960] float null, 
	[1961] float null, 
	[1962] float null, 
	[1963] float null, 
	[1964] float null, 
	[1965] float null, 
	[1966] float null, 
	[1967] float null, 
	[1968] float null, 
	[1969] float null, 
	[1970] float null, 
	[1971] float null, 
	[1972] float null, 
	[1973] float null, 
	[1974] float null, 
	[1975] float null, 
	[1976] float null, 
	[1977] float null, 
	[1978] float null, 
	[1979] float null, 
	[1980] float null, 
	[1981] float null, 
	[1982] float null, 
	[1983] float null, 
	[1984] float null, 
	[1985] float null, 
	[1986] float null, 
	[1987] float null, 
	[1988] float null, 
	[1989] float null, 
	[1990] float null, 
	[1991] float null, 
	[1992] float null, 
	[1993] float null, 
	[1994] float null, 
	[1995] float null, 
	[1996] float null, 
	[1997] float null, 
	[1998] float null, 
	[1999] float null, 
	[2000] float null, 
	[2001] float null, 
	[2002] float null, 
	[2003] float null, 
	[2004] float null, 
	[2005] float null, 
	[2006] float null, 
	[2007] float null, 
	[2008] float null, 
	[2009] float null, 
	[2010] float null, 
	[2011] float null, 
	[2012] float null, 
	[2013] float null, 
	[2014] float null, 
	[2015] float null, 
	[2016] float null, 
	[2017] float null, 
	[2018] float null, 
	[2019] float null, 
	[2020] float null, 
	[2021] float null, 
	[2022] float null, 
	[2023] float null
  )

--2. Unpivot FDI data. Create iv_fdi table
select * into iv_fdi from
  (
  select country_name, country_code, indicator_name, indicator_code, yr, fdi
  from FDI as f
  /*use cross apply instead of unpivot to include null values*/
  cross apply 
  (values
	(f.[1960],'1960'),
	(f.[1961],'1961'),
	(f.[1962],'1962'),
	(f.[1963],'1963'),
	(f.[1964],'1964'),
	(f.[1965],'1965'),
	(f.[1966],'1966'),
	(f.[1967],'1967'),
	(f.[1968],'1968'),
	(f.[1969],'1969'),
	(f.[1970],'1970'),
	(f.[1971],'1971'),
	(f.[1972],'1972'),
	(f.[1973],'1973'),
	(f.[1974],'1974'),
	(f.[1975],'1975'),
	(f.[1976],'1976'),
	(f.[1977],'1977'),
	(f.[1978],'1978'),
	(f.[1979],'1979'),
	(f.[1980],'1980'),
	(f.[1981],'1981'),
	(f.[1982],'1982'),
	(f.[1983],'1983'),
	(f.[1984],'1984'),
	(f.[1985],'1985'),
	(f.[1986],'1986'),
	(f.[1987],'1987'),
	(f.[1988],'1988'),
	(f.[1989],'1989'),
	(f.[1990],'1990'),
	(f.[1991],'1991'),
	(f.[1992],'1992'),
	(f.[1993],'1993'),
	(f.[1994],'1994'),
	(f.[1995],'1995'),
	(f.[1996],'1996'),
	(f.[1997],'1997'),
	(f.[1998],'1998'),
	(f.[1999],'1999'),
	(f.[2000],'2000'),
	(f.[2001],'2001'),
	(f.[2002],'2002'),
	(f.[2003],'2003'),
	(f.[2004],'2004'),
	(f.[2005],'2005'),
	(f.[2006],'2006'),
	(f.[2007],'2007'),
	(f.[2008],'2008'),
	(f.[2009],'2009'),
	(f.[2010],'2010'),
	(f.[2011],'2011'),
	(f.[2012],'2012'),
	(f.[2013],'2013'),
	(f.[2014],'2014'),
	(f.[2015],'2015'),
	(f.[2016],'2016'),
	(f.[2017],'2017'),
	(f.[2018],'2018'),
	(f.[2019],'2019'),
	(f.[2020],'2020'),
	(f.[2021],'2021'),
	(f.[2022],'2022'),
	(f.[2023],'2023')
  ) as g(fdi,yr)
) as iv_fdi
GO

---PART 2: CREATE TABLE CONL_GDPPC_GROWTH---
--1. Create table GDPPC_GROWTH and input raw data from excel file
create table GDPPC_GROWTH (
	country_name varchar(52) not null, 
	country_code char(3) not null,
	indicator_name varchar(32) not null, 
	indicator_code varchar(17) not null,
	[1960] float null, 
	[1961] float null, 
	[1962] float null, 
	[1963] float null, 
	[1964] float null, 
	[1965] float null, 
	[1966] float null, 
	[1967] float null, 
	[1968] float null, 
	[1969] float null, 
	[1970] float null, 
	[1971] float null, 
	[1972] float null, 
	[1973] float null, 
	[1974] float null, 
	[1975] float null, 
	[1976] float null, 
	[1977] float null, 
	[1978] float null, 
	[1979] float null, 
	[1980] float null, 
	[1981] float null, 
	[1982] float null, 
	[1983] float null, 
	[1984] float null, 
	[1985] float null, 
	[1986] float null, 
	[1987] float null, 
	[1988] float null, 
	[1989] float null, 
	[1990] float null, 
	[1991] float null, 
	[1992] float null, 
	[1993] float null, 
	[1994] float null, 
	[1995] float null, 
	[1996] float null, 
	[1997] float null, 
	[1998] float null, 
	[1999] float null, 
	[2000] float null, 
	[2001] float null, 
	[2002] float null, 
	[2003] float null, 
	[2004] float null, 
	[2005] float null, 
	[2006] float null, 
	[2007] float null, 
	[2008] float null, 
	[2009] float null, 
	[2010] float null, 
	[2011] float null, 
	[2012] float null, 
	[2013] float null, 
	[2014] float null, 
	[2015] float null, 
	[2016] float null, 
	[2017] float null, 
	[2018] float null, 
	[2019] float null, 
	[2020] float null, 
	[2021] float null, 
	[2022] float null, 
	[2023] float null
  )
--2. Unpivot GDPPC_GROWTH data. Create conl_gdppc_growth
select * into conl_gdppc_growth from
  (
  select country_name, country_code, indicator_name, indicator_code, yr, gdppc_growth
  from GDPPC_GROWTH as f
  /*use cross apply instead of unpivot to include null values*/
  cross apply 
  (values
		(f.[1960],'1960'),
		(f.[1961],'1961'),
		(f.[1962],'1962'),
		(f.[1963],'1963'),
		(f.[1964],'1964'),
		(f.[1965],'1965'),
		(f.[1966],'1966'),
		(f.[1967],'1967'),
		(f.[1968],'1968'),
		(f.[1969],'1969'),
		(f.[1970],'1970'),
		(f.[1971],'1971'),
		(f.[1972],'1972'),
		(f.[1973],'1973'),
		(f.[1974],'1974'),
		(f.[1975],'1975'),
		(f.[1976],'1976'),
		(f.[1977],'1977'),
		(f.[1978],'1978'),
		(f.[1979],'1979'),
		(f.[1980],'1980'),
		(f.[1981],'1981'),
		(f.[1982],'1982'),
		(f.[1983],'1983'),
		(f.[1984],'1984'),
		(f.[1985],'1985'),
		(f.[1986],'1986'),
		(f.[1987],'1987'),
		(f.[1988],'1988'),
		(f.[1989],'1989'),
		(f.[1990],'1990'),
		(f.[1991],'1991'),
		(f.[1992],'1992'),
		(f.[1993],'1993'),
		(f.[1994],'1994'),
		(f.[1995],'1995'),
		(f.[1996],'1996'),
		(f.[1997],'1997'),
		(f.[1998],'1998'),
		(f.[1999],'1999'),
		(f.[2000],'2000'),
		(f.[2001],'2001'),
		(f.[2002],'2002'),
		(f.[2003],'2003'),
		(f.[2004],'2004'),
		(f.[2005],'2005'),
		(f.[2006],'2006'),
		(f.[2007],'2007'),
		(f.[2008],'2008'),
		(f.[2009],'2009'),
		(f.[2010],'2010'),
		(f.[2011],'2011'),
		(f.[2012],'2012'),
		(f.[2013],'2013'),
		(f.[2014],'2014'),
		(f.[2015],'2015'),
		(f.[2016],'2016'),
		(f.[2017],'2017'),
		(f.[2018],'2018'),
		(f.[2019],'2019'),
		(f.[2020],'2020'),
		(f.[2021],'2021'),
		(f.[2022],'2022'),
		(f.[2023],'2023')
  ) as g(gdppc_growth,yr)
) as conl_gdppc_growth
GO

--PART 3: CREATE TABLE CONL_CPI---
--1. Create table CPI
create table CPI (
	indicator_name varchar(33) not null, 
	indicator_code varchar(11) not null,
	country_name varchar(52) not null, 
	country_code char(3) not null,
	[2004] float null, 
	[2005] float null, 
	[2006] float null, 
	[2007] float null, 
	[2008] float null, 
	[2009] float null, 
	[2010] float null, 
	[2011] float null, 
	[2012] float null, 
	[2013] float null, 
	[2014] float null, 
	[2015] float null, 
	[2016] float null, 
	[2017] float null, 
	[2018] float null, 
	[2019] float null, 
	[2020] float null, 
	[2021] float null, 
	[2022] float null, 
	[2023] float null
)
--2. Unpivot CPI data. Create conl_cpi table
select * into conl_cpi from
(
	select country_name, country_code, indicator_name, indicator_code, yr, cpi
	from CPI as f
	/*use cross apply instead of unpivot to include null values*/
	cross apply 
	(values
		(f.[2004],'2004'),
		(f.[2005],'2005'),
		(f.[2006],'2006'),
		(f.[2007],'2007'),
		(f.[2008],'2008'),
		(f.[2009],'2009'),
		(f.[2010],'2010'),
		(f.[2011],'2011'),
		(f.[2012],'2012'),
		(f.[2013],'2013'),
		(f.[2014],'2014'),
		(f.[2015],'2015'),
		(f.[2016],'2016'),
		(f.[2017],'2017'),
		(f.[2018],'2018'),
		(f.[2019],'2019'),
		(f.[2020],'2020'),
		(f.[2021],'2021'),
		(f.[2022],'2022'),
		(f.[2023],'2023')
	) as g(cpi,yr)
) as conl_cpi
GO

--PART 4: CREATE TABLE MOD_IQ--
--1. Create table INSTITUTIONAL_QUALITY 
create table INSTITUTIONAL_QUALITY  
(
	country_name varchar(52) not null, 
	country_code char(3) not null,
	iq_dimension_name char(31) not null,
	[1996] float null, 
	[1998] float null, 
	[2000] float null, 
	[2002] float null, 
	[2003] float null, 
	[2004] float null, 
	[2005] float null, 
	[2006] float null, 
	[2007] float null, 
	[2008] float null, 
	[2009] float null, 
	[2010] float null, 
	[2011] float null, 
	[2012] float null, 
	[2013] float null, 
	[2014] float null, 
	[2015] float null, 
	[2016] float null, 
	[2017] float null, 
	[2018] float null, 
	[2019] float null, 
	[2020] float null, 
	[2021] float null, 
	[2022] float null, 
  )
--2. Unpivot and pivot INSTITUTIONAL_QUALITY. Create mod_iq
select *, (voi_iq+pol_iq+gov_iq+reg_iq+rul_iq+con_iq)/6 as composite_iq into mod_iq
from
(
	select
		dense_rank() over(order by country_code) as country_id,
		country_name, 
		country_code, 
		yr, 
		[Voice and Accountability] as voi_iq, 
		[Political Stability No Violence] as pol_iq, 
		[Government Effectiveness] as gov_iq, 
		[Regulatory Quality] as reg_iq, 
		[Rule of Law] as rul_iq, 
		[Control of Corruption] as con_iq
	from
	(
		select country_name, country_code, iq_dimension_name, yr, iq
		from INSTITUTIONAL_QUALITY as f
		cross apply
		(values
			(f.[1996],'1996'),
			(f.[1998],'1998'),
			(f.[2000],'2000'),
			(f.[2002],'2002'),
			(f.[2003],'2003'),
			(f.[2004],'2004'),
			(f.[2005],'2005'),
			(f.[2006],'2006'),
			(f.[2007],'2007'),
			(f.[2008],'2008'),
			(f.[2009],'2009'),
			(f.[2010],'2010'),
			(f.[2011],'2011'),
			(f.[2012],'2012'),
			(f.[2013],'2013'),
			(f.[2014],'2014'),
			(f.[2015],'2015'),
			(f.[2016],'2016'),
			(f.[2017],'2017'),
			(f.[2018],'2018'),
			(f.[2019],'2019'),
			(f.[2020],'2020'),
			(f.[2021],'2021'),
			(f.[2022],'2022')
		) as g(iq,yr)
	) as unpivot_institutional_quality
	pivot
	(
	max(iq) for iq_dimension_name in
		(
		[Voice and Accountability], [Political Stability No Violence], [Government Effectiveness], 
		[Regulatory Quality], [Rule of Law], [Control of Corruption]
		)
	) as pivot_institutional_quality
) as mod_iq
GO

--PART 5: CREATE TABLE POPULATION--
--1. Create table POPULATION
create table POPULATION
(
	indicator_name varchar(17) not null, 
	indicator_code varchar(11) not null,
	country_name varchar(52) not null, 
	country_code char(3) not null,
	[2004] int null, 
	[2005] int null, 
	[2006] int null, 
	[2007] int null, 
	[2008] int null, 
	[2009] int null, 
	[2010] int null, 
	[2011] int null, 
	[2012] int null, 
	[2013] int null, 
	[2014] int null, 
	[2015] int null, 
	[2016] int null, 
	[2017] int null, 
	[2018] int null, 
	[2019] int null, 
	[2020] int null, 
	[2021] int null, 
	[2022] int null, 
	[2023] int null
)
--2. Unpivot CPI data. Create conl_cpi table
select * into capita_population from
(
select country_name, country_code, indicator_name, indicator_code, yr, population
from POPULATION as f
/*use cross apply instead of unpivot to include null values*/
cross apply 
(values
(f.[2004],'2004'),
(f.[2005],'2005'),
(f.[2006],'2006'),
(f.[2007],'2007'),
(f.[2008],'2008'),
(f.[2009],'2009'),
(f.[2010],'2010'),
(f.[2011],'2011'),
(f.[2012],'2012'),
(f.[2013],'2013'),
(f.[2014],'2014'),
(f.[2015],'2015'),
(f.[2016],'2016'),
(f.[2017],'2017'),
(f.[2018],'2018'),
(f.[2019],'2019'),
(f.[2020],'2020'),
(f.[2021],'2021'),
(f.[2022],'2022'),
(f.[2023],'2023')
) as g(population,yr)
) as capita_population
GO

---PART 6: CREATE TABLE DV_ENCONS---
--1. Create table OECD_ENERGY_CONSUMPTION
create table OECD_ENERGY_CONSUMPTION
(
	country_name varchar(39) not null,
	product char(25) not null,
	flow char(37) not null,
	[1971] float null, 
	[1972] float null, 
	[1973] float null, 
	[1974] float null, 
	[1975] float null, 
	[1976] float null, 
	[1977] float null, 
	[1978] float null, 
	[1979] float null, 
	[1980] float null, 
	[1981] float null, 
	[1982] float null, 
	[1983] float null, 
	[1984] float null, 
	[1985] float null, 
	[1986] float null, 
	[1987] float null, 
	[1988] float null, 
	[1989] float null, 
	[1990] float null, 
	[1991] float null, 
	[1992] float null, 
	[1993] float null, 
	[1994] float null, 
	[1995] float null, 
	[1996] float null, 
	[1997] float null, 
	[1998] float null, 
	[1999] float null, 
	[2000] float null, 
	[2001] float null, 
	[2002] float null, 
	[2003] float null, 
	[2004] float null, 
	[2005] float null, 
	[2006] float null, 
	[2007] float null, 
	[2008] float null, 
	[2009] float null, 
	[2010] float null, 
	[2011] float null, 
	[2012] float null, 
	[2013] float null, 
	[2014] float null, 
	[2015] float null, 
	[2016] float null, 
	[2017] float null, 
	[2018] float null, 
	[2019] float null, 
	[2020] float null, 
	[2021] float null, 
	[2022] float null, 
	[2023] float null
)
GO
--2. Unpivot OECD_ENERGY_CONSUMPTION data. 
---Update country_name for data normalization (this dataset lacks the country_code for joining)
Update capita_population
set country_name = replace(country_name,'Egypt, Arab Rep.', 'Egypt')

Update capita_population
set country_name = replace(country_name,'Korea, Rep.', 'Korea')

Update OECD_ENERGY_CONSUMPTION
set country_name = replace(country_name,'People''s Republic of China', 'China')

Update capita_population
set country_name = replace(country_name,'Turkiye', 'Republic of Turkiye')

--Form CTEs and join different types of energy in one table
With unpivot_encons as
(
	select 
		country_name, 
		product, 
		flow, 
		yr, 
		encons_gja
	from OECD_ENERGY_CONSUMPTION as f
	cross apply 
	(values
	(f.[1971],'1971'),
	(f.[1972],'1972'),
	(f.[1973],'1973'),
	(f.[1974],'1974'),
	(f.[1975],'1975'),
	(f.[1976],'1976'),
	(f.[1977],'1977'),
	(f.[1978],'1978'),
	(f.[1979],'1979'),
	(f.[1980],'1980'),
	(f.[1981],'1981'),
	(f.[1982],'1982'),
	(f.[1983],'1983'),
	(f.[1984],'1984'),
	(f.[1985],'1985'),
	(f.[1986],'1986'),
	(f.[1987],'1987'),
	(f.[1988],'1988'),
	(f.[1989],'1989'),
	(f.[1990],'1990'),
	(f.[1991],'1991'),
	(f.[1992],'1992'),
	(f.[1993],'1993'),
	(f.[1994],'1994'),
	(f.[1995],'1995'),
	(f.[1996],'1996'),
	(f.[1997],'1997'),
	(f.[1998],'1998'),
	(f.[1999],'1999'),
	(f.[2000],'2000'),
	(f.[2001],'2001'),
	(f.[2002],'2002'),
	(f.[2003],'2003'),
	(f.[2004],'2004'),
	(f.[2005],'2005'),
	(f.[2006],'2006'),
	(f.[2007],'2007'),
	(f.[2008],'2008'),
	(f.[2009],'2009'),
	(f.[2010],'2010'),
	(f.[2011],'2011'),
	(f.[2012],'2012'),
	(f.[2013],'2013'),
	(f.[2014],'2014'),
	(f.[2015],'2015'),
	(f.[2016],'2016'),
	(f.[2017],'2017'),
	(f.[2018],'2018'),
	(f.[2019],'2019'),
	(f.[2020],'2020'),
	(f.[2021],'2021'),
	(f.[2022],'2022'),
	(f.[2023],'2023')
	) as g(encons_gja, yr)
),
--low-carbon energy consumption per capita (gJ/a)
low_carbon_encons as
(
 select 
	country_name, 
	country_code, 
	flow, 
	yr, 
	lc_encons_gj/population as "lc_encons_gja"
  from
  (
	  select n.country_name, p.country_code, n.flow, n.yr, convert(decimal(13,2),sum(n.encons_gja))*1000000 as lc_encons_gj, p.population
	  from 
	  (
		  select * 
		  from unpivot_encons
		  where product = 'Renewables and waste'and flow = 'Industry (PJ)'
		  union all
		  select *
		  from unpivot_encons
		  where product = 'Nuclear'and flow = 'Industry (PJ)'
	  ) as n
	  left join capita_population as p
	  on n.country_name = p.country_name and n.yr = p.yr
	  where n.yr between 2004 and 2023
	  group by n.country_name, flow, n.yr, p.population, p.country_code
  ) as m
),
--non-low-carbon energy consumption per capita (gJ/a)
non_low_carbon_encons as
(
 select 
	country_name, 
	country_code, 
	flow, 
	yr, 
	nlc_encons_gj/population as "nlc_encons_gja"
  from
  (
	  select n.country_name, p.country_code, n.flow, n.yr, convert(decimal(13,2),sum(n.encons_gja))*1000000 as nlc_encons_gj, p.population
	  from 
	  (
		  select * 
		  from unpivot_encons
		  where flow = 'Industry (PJ)' and product != 'Renewables and waste'and product != 'Nuclear'
	  ) as n
	  left join capita_population as p
	  on n.country_name = p.country_name and n.yr = p.yr
	  where n.yr between 2004 and 2023
	  group by n.country_name, flow, n.yr, p.population, p.country_code
  ) as m
),
--total energy consumption per capita (gJ/a)
total_encons as
(
 select 
	country_name, 
	country_code, 
	flow, 
	yr, 
	tc_encons_gj/population as "tc_encons_gja"
  from
  (
	  select n.country_name, p.country_code, n.flow, n.yr, convert(decimal(13,2),sum(n.encons_gja))*1000000 as tc_encons_gj, p.population
	  from 
	  (
		  select * 
		  from unpivot_encons
		  where flow = 'Industry (PJ)'
	  ) as n
	  left join capita_population as p
	  on n.country_name = p.country_name and n.yr = p.yr
	  where n.yr between 2004 and 2023
	  group by n.country_name, flow, n.yr, p.population, p.country_code
  ) as m
)
select * into dv_encons_oecd
from
(
	select 
		lc.country_name,
		lc.country_code,
		lc.flow,
		lc.yr,
		lc.lc_encons_gja,
		nlc.nlc_encons_gja,
		tc.tc_encons_gja
	from low_carbon_encons as lc
	join non_low_carbon_encons as nlc
	on lc.country_code = nlc.country_code and lc.yr = nlc.yr
	join total_encons as tc
	on lc.country_code = tc.country_code and lc.yr = tc.yr
) as dv_encons_oecd

---FINAL PANEL DATA TABLE
With panel_data as
(
	select 
		iv.country_name, 
		iv.country_code,  
		iv.yr, 
		iv.fdi, 
		dv.lc_encons_gja, 
		dv.nlc_encons_gja,
		dv.tc_encons_gja,
		mvi.voi_iq,
		mvi.pol_iq,
		mvi.gov_iq,
		mvi.reg_iq,
		mvi.rul_iq,
		mvi.con_iq,
		mvi.composite_iq,
		cvg.gdppc_growth,
		cvc.cpi
	from dv_encons_oecd as dv
	join iv_fdi as iv
	on dv.country_code = iv.country_code and dv.yr = iv.yr
	join conl_gdppc_growth as cvg
	on dv.country_code = cvg.country_code and dv.yr = cvg.yr
	join conl_population_growth as cvp
	on dv.country_code = cvp.country_code and dv.yr = cvp.yr
	join conl_cpi as cvc
	on dv.country_code = cvc.country_code and dv.yr = cvc.yr
	join mod_trade_openess as mvt
	on dv.country_code = mvt.country_code and dv.yr = mvt.yr
	join mod_iq as mvi
	on dv.country_code = mvi.country_code and dv.yr = mvi.yr
	where 
		iv.fdi is not null and 
		cvg.gdppc_growth is not null and 
		cvp.population_growth is not null and
		cvc.cpi is not null and 
		mvt.trade_openess is not null and
		(iv.yr between 2004 and 2022)
),
year_count as
(
 select country_code, count(yr) as yr_count
 from panel_data
 group by country_code
)

select
	dense_rank() over(order by p.country_code) as country_id, 
	p.country_name, 
	p.country_code, 
	y.yr_count,
	p.yr, 
	p.fdi, 
	p.lc_encons_gja, 
	p.nlc_encons_gja,
	p.tc_encons_gja,
	p.voi_iq,
	p.pol_iq,
	p.gov_iq,
	p.reg_iq,
	p.rul_iq,
	p.con_iq,
	round(p.composite_iq,2) as com_iq
	p.gdppc_growth,
	p.cpi,
	case when yr = '2004' then 1 else 0 end as yr_1,
	case when yr = '2005' then 1 else 0 end as yr_2,
	case when yr = '2006' then 1 else 0 end as yr_3,
	case when yr = '2007' then 1 else 0 end as yr_4,
	case when yr = '2008' then 1 else 0 end as yr_5,
	case when yr = '2009' then 1 else 0 end as yr_6,
	case when yr = '2010' then 1 else 0 end as yr_7,
	case when yr = '2011' then 1 else 0 end as yr_8,
	case when yr = '2012' then 1 else 0 end as yr_9,
	case when yr = '2013' then 1 else 0 end as yr_10,
	case when yr = '2014' then 1 else 0 end as yr_11,
	case when yr = '2015' then 1 else 0 end as yr_12,
	case when yr = '2016' then 1 else 0 end as yr_13,
	case when yr = '2017' then 1 else 0 end as yr_14,
	case when yr = '2018' then 1 else 0 end as yr_15,
	case when yr = '2019' then 1 else 0 end as yr_16,
	case when yr = '2020' then 1 else 0 end as yr_17,
	case when yr = '2021' then 1 else 0 end as yr_18,
	case when yr = '2022' then 1 else 0 end as yr_19
from panel_data as p
join year_count as y
on p.country_code = y.country_code
where y.yr_count = 19
