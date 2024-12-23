# FDI_and_Encons_Nexus_Project

## Table of Contents
- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Cleaning/Preparation](#data-cleansingpreparation)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Results/Findings](#resultsfindings)
- [Limitations](#limitations)
- [References](#references)

### Project Overview

Inspecting the influences of FDI inflows on low-carbon, non-low-carbon, and total industrial energy consumption of officially 49 OECD-based countries under the moderating effects of 6 institutional-quality indicators, covering the time series of 19 years (2004 - 2022). 

### Data Sources

- Energy balances data (Raw_world_energy_balances_highlights_2024.xlsx): The dataset is collected from the International Energy Agency (IEA) for the 2024 edition. It contains energy balances in multiple products characterized by different flows of OECD and OECD-associated countries from 1971 - 2023.
- Historical population data (Raw_historical_population.csv): the dataset is collected from World Development Indicators, containing the total population of 266 countries & regions from 2004 - 2023.
- FDI inflow data (Raw_foreign_direct_investment_net_inflows_pcGDP.csv): the dataset source is from World Development Indicators, containing net inflows of FDI(% of GDP) of 266 countries & regions from 1960 - 2023.
- Institutional quality data (Raw_aggregate_governance_indicators.xlsx): the dataset covers 6 indicators of governance, including Voice and Accountability, Political Stability and Absence of Violence/Terrorism, Government Effectiveness, Regulatory Quality, Rule of Law, and Control of Corruption. The Worldwide Governance Indicators construct this dataset with time series from 1996 - 2022
- GDP per capita growth data (Raw_GDP_per_capita.csv): the dataset is garnered by World Development Indicators, demonstrating the GDP per capita growth (% annual) of 266 countries & regions from 1960 - 2023.
- CPI data (Raw_CPI_2010_base_year.csv): The dataset is from World Development Indicators, demonstrating the consumer price index (2010 = 100) of 266 countries & regions from 2004 - 2023.

### Tools

- MS Excel - Data Cleaning [(Download here)](https://www.microsoft.com/en-us/microsoft-365/excel)
- SQL Server - Data Cleaning, Standardizing, and Joining [(Download here)](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
- STATA 17 - Data Analysis [(Download here)](https://download.stata.com/download/)

### Data Cleansing/Preparation

In the initial data preparation phase, we performed the following tasks:
1. Deleted any column irrelevant for data analysis, ensuring lighter data warehousing. (MS Excel)
2. Checked for maximum column character length or correct numerical data types to suit the SQL Server's table creation criteria. Also, replaced NULL values characterized by the ".." sign of the international reporting format to empty to avoid data loading errors. (MS Excel)
3. Created dimensional tables covering exploratory and outcome variables and loaded data into each table. (SQL Server).
4. Standardized each table's data format to reflect the structure of balanced panel data and ensure data normalization between them for joining purposes. For energy balances data, perform division calculation to the population data to extract the energy consumption per capita. (SQL Server)
5. Joined tables together. Identified the time series and number of groups with no NULL values in any cell to avoid reducing sample size in STATA's analysis algorithm. (SQL Server)

### Exploratory Data Analysis

EDA in STATA involved exploring the (1) impact of FDI inflows on different types of energy consumption and (2) the moderation effects of institutional quality on their relationship. We performed the following tasks:
1. Applied the Generalized Method of Moments (GMM) to test the hypotheses because it controls for endogeneity, and becomes robust to heteroscedasticity and serial correlation, leading to less biased testing results when compared to the Fixed Effect Regression.
2. Identified the Upper Bound (Pooled OLS) and Lower Bound (Fixed Effect) to determine whether the dataset better fits the appliance of Difference GMM or System GMM. (In our case, the alpha value of the lagged dependent variable when performed Difference GMM was smaller than the Lower Bound. Therefore, System GMM is the way to go)
3. Implemented a two-step System GMM.
   ```Stata
   xtabond2 L(0/1).ln_lc_encons fdi composite_iq ln_cpi gdppc_growth c.fdi#c.composite_iq i.yr,
   gmm(L4.ln_lc_encons, lag (4 4))
   iv(L.fdi L.composite_iq ln_cpi gdppc_growth L.c.fdi#c.composite_iq i.yr, equation(level))
   nodiffsargan twostep robust orthogonal 
   ```

### Results/Findings

The analysis results are summarized as follows:
1. The FDI inflows exert a positive impact on low-carbon energy consumption. 
2. Composite institutional quality negatively influences the FDI inflows and low-carbon energy consumption nexus.
3. This moderating effect is stronger when focused on governance indicators including Voice and Accountability, Regulatory Quality, Rule of Law, and Control of Corruption. Nevertheless, Political Stability and Absence of Violence/Terrorism, and Government Effectiveness dimensions do not play a role here.
4. There is no relationship between FDI inflows and non-low-carbon or total energy consumption. Institutional quality, as a whole, or constructed as individual governance indicators, does not exert any power on the relations.

### Limitations
1. The GMM test requires the number of instruments to not exceed the number of cross-section data, and it should be far lower than that. Although our tests for low-carbon and total energy consumption still fulfilled the criterion with 45 instruments covering 49 cross-sectional groups, it remained quite a high number of instruments, affecting the accuracy of my conclusions to some extent.
2. The analysis was conducted based off the availability of energy balances data. Therefore, our research is limited to cover the hypotheses for OECD-based sample only. Further research could delve deeply to facilitate comprehensive understanding of FDI inflows and energy nexus on a larger scale.

### References
1. Panel GMM [(Youtube)](https://www.youtube.com/watch?v=Ou4BwR4M6do&list=PL6Y8SvWdPo08BIszhwcL2jydMgBXMCKwb)
2. Hansen or Sargan Test Results [(Statalist Forum)](https://www.statalist.org/forums/forum/general-stata-discussion/general/1432620-xtabond2-system-gmm-robust-estimation-do-i-use-hansen-or-sargan-test-results)
3. Generalized method of moments estimation of linear dynamic panel data models [(Slides)](http://repec.org/usug2019/Kripfganz_uk19.pdf)
4. GMM Estimation in Stata [(Slides)](https://ocw.mit.edu/courses/14-382-econometrics-spring-2017/33c39c3c1de04b9ef16e780dd8b4fa98_MIT14_382S17_GMMslides.pdf)
5. Two-Step System GMM with xtabond2 command [(Statalist Forum)](https://www.statalist.org/forums/forum/general-stata-discussion/general/1681664-two-step-system-gmm-with-xtabond2-command)
6. System GMM - Time dummies [(Statalist Forum)](https://www.statalist.org/forums/forum/general-stata-discussion/general/1357268-system-gmm-time-dummies)
