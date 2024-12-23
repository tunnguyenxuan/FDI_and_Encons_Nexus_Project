***STEP 1: PREPARING DATA
**encoding
xtset country_id yr
gen ln_lc_encons = log(lc_encons_gja)
gen ln_nlc_encons = log(nlc_encons_gja)
gen ln_tc_encons = log(tc_encons_gja)
gen ln_cpi = log(cpi)
**Filling missing data
misstable sum
bysort country_id: ipolate ln_lc_encons yr, gen(ln_lc_encons_filled) epolate
replace ln_lc_encons=ln_lc_encons_filled if missing(ln_lc_encons)
drop ln_lc_encons_filled 
//before filling missing data
                                                               Obs<.
                                                +------------------------------
               |                                | Unique
      Variable |     Obs=.     Obs>.     Obs<.  | values        Min         Max
  -------------+--------------------------------+------------------------------
  ln_lc_encons |        56                 875  |   >500   -6.04183    3.480838
  -----------------------------------------------------------------------------
//after filling missing data

                                                               Obs<.
                                                +------------------------------
               |                                | Unique
      Variable |     Obs=.     Obs>.     Obs<.  | values        Min         Max
  -------------+--------------------------------+------------------------------
  ln_lc_encons |        38                 893  |   >500   -6.04183    3.480838
  -----------------------------------------------------------------------------

***STEP 2: GMM to Low-carbon enegy
**2.1. Low-carbon energy with composite institutional quality
*2.1.1. Upper bound vs. Lower bound
*2.1.1.1. upper bound: pooled ols
reg L(0/1).ln_lc_encons fdi composite_iq ln_cpi gdppc_growth c.fdi#c.composite_iq i.yr
est sto lc_comiq_ols
	//result: .9726317 
*2.1.1.2 lower bound: fixed effect
xtreg L(0/1).ln_lc_encons fdi composite_iq ln_cpi gdppc_growth c.fdi#c.composite_iq i.yr, fe robust
est sto lc_comiq_fe
	//result: .8508833 
**2.1.2 Difference GMM vs. System GMM
*2.1.2.1 twostep difference gmm
xtabond2 L(0/1).ln_lc_encons fdi composite_iq ln_cpi gdppc_growth c.fdi#c.composite_iq i.yr, gmm(L4.ln_lc_encons L8.fdi L7.composite_iq L7.ln_cpi L5.gdppc_growth L7.c.fdi#c.composite_iq, lag(8 8)) iv(i.yr)noleveleq nodiffsargan twostep robust orthogonal small
est sto lc_comiq_diffgmm
	//result: .5853741 => system GMM is the way to go
*2.1.2.2. twostep system gmm
xtabond2 L(0/1).ln_lc_encons fdi composite_iq ln_cpi gdppc_growth c.fdi#c.composite_iq i.yr, gmm(L4.ln_lc_encons, lag (4 4)) iv(L.fdi L.composite_iq ln_cpi gdppc_growth L.c.fdi#c.composite_iq i.yr, equation(level)) nodiffsargan twostep robust orthogonal 
est sto lc_comiq_sysgmm

Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       846
Time variable : yr                              Number of groups   =        47
Number of instruments = 45                      Obs per group: min =        18
Wald chi2(23) =   6602.31                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------------
                     |              Corrected
        ln_lc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------------+----------------------------------------------------------------
        ln_lc_encons |
                 L1. |   .8839644   .0345399    25.59   0.000     .8162673    .9516614
                     |
                 fdi |   .0083503    .003092     2.70   0.007     .0022901    .0144105
        composite_iq |   .1476712   .0451234     3.27   0.001     .0592309    .2361115
              ln_cpi |   .1117118   .1051893     1.06   0.288    -.0944555    .3178791
        gdppc_growth |    .006206   .0061705     1.01   0.315    -.0058879       .0183
                     |
c.fdi#c.composite_iq |  -.0077179    .003897    -1.98   0.048    -.0153558     -.00008
                     |
                  yr |
               2005  |   .0902277   .0511079     1.77   0.077     -.009942    .1903974
               2006  |   .0683981   .0487093     1.40   0.160    -.0270703    .1638666
               2007  |    .072442   .0455231     1.59   0.112    -.0167818    .1616657
               2008  |   .0618093   .0450026     1.37   0.170    -.0263942    .1500128
               2009  |   .0542022   .0603548     0.90   0.369    -.0640909    .1724954
               2010  |   .0668144   .0349404     1.91   0.056    -.0016675    .1352963
               2011  |   .0677502   .0352462     1.92   0.055     -.001331    .1368315
               2012  |   .0089888   .0414079     0.22   0.828    -.0721691    .0901467
               2013  |   .1029615   .0410312     2.51   0.012     .0225419    .1833811
               2014  |   .0544556   .0364272     1.49   0.135    -.0169403    .1258516
               2015  |   .0809456   .0366348     2.21   0.027     .0091426    .1527485
               2016  |    .051377   .0422337     1.22   0.224    -.0313996    .1341536
               2017  |   .0704375   .0314977     2.24   0.025     .0087032    .1321719
               2018  |   .0419495    .030485     1.38   0.169       -.0178    .1016989
               2019  |    .086978    .045036     1.93   0.053    -.0012911     .175247
               2020  |    .050254   .0668586     0.75   0.452    -.0807864    .1812944
               2022  |  -.0078779   .0331169    -0.24   0.812    -.0727858    .0570301
                     |
               _cons |  -.6580234   .5214145    -1.26   0.207    -1.679977    .3639301
--------------------------------------------------------------------------------------
Instruments for orthogonal deviations equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L4.L4.ln_lc_encons
Instruments for levels equation
  Standard
    L.fdi L.composite_iq ln_cpi gdppc_growth cL.fdi#c.composite_iq 2004b.yr
    2005.yr 2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr
    2014.yr 2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL3.L4.ln_lc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.09  Pr > z =  0.002
Arellano-Bond test for AR(2) in first differences: z =  -0.31  Pr > z =  0.758
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(21)   =  30.97  Prob > chi2 =  0.074
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(21)   =  13.48  Prob > chi2 =  0.891
  (Robust, but weakened by many instruments.)


**2.2. Low-carbon energy with voi_iq
xtabond2 L(0/1).ln_lc_encons fdi voi_iq ln_cpi gdppc_growth c.fdi#c.voi_iq i.yr, gmm(L4.ln_lc_encons, lag (4 4)) iv(L.fdi L.voi_iq L.ln_cpi gdppc_growth L.c.fdi#c.voi_iq i.yr, equation(level)) nodiffsargan twostep robust 
est sto lc_voiiq_sysgmm

Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       846
Time variable : yr                              Number of groups   =        47
Number of instruments = 45                      Obs per group: min =        18
Wald chi2(23) =   8592.03                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
  ln_lc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
  ln_lc_encons |
           L1. |   .8775979   .0387897    22.62   0.000     .8015715    .9536243
               |
           fdi |   .0074785   .0041572     1.80   0.072    -.0006696    .0156265
        voi_iq |   .1849208   .0638473     2.90   0.004     .0597824    .3100593
        ln_cpi |   .1007137   .1069719     0.94   0.346    -.1089475    .3103748
  gdppc_growth |   .0086988   .0037635     2.31   0.021     .0013224    .0160751
               |
c.fdi#c.voi_iq |  -.0076686   .0036421    -2.11   0.035     -.014807   -.0005302
               |
            yr |
         2005  |   .0061287   .0267209     0.23   0.819    -.0462433    .0585008
         2006  |  -.0038239   .0212732    -0.18   0.857    -.0455187    .0378709
         2008  |   -.004895   .0298984    -0.16   0.870    -.0634948    .0537049
         2009  |    -.01074   .0423239    -0.25   0.800    -.0936934    .0722134
         2010  |  -.0108822   .0363233    -0.30   0.764    -.0820747    .0603102
         2011  |  -.0047674   .0287933    -0.17   0.868    -.0612012    .0516663
         2012  |   -.065878   .0417408    -1.58   0.115    -.1476884    .0159324
         2013  |   .0231024   .0393192     0.59   0.557    -.0539618    .1001667
         2014  |  -.0206446    .041058    -0.50   0.615    -.1011169    .0598277
         2015  |   .0055585   .0370792     0.15   0.881    -.0671155    .0782325
         2016  |  -.0231167   .0493788    -0.47   0.640    -.1198972    .0736639
         2017  |  -.0046393   .0430157    -0.11   0.914    -.0889486    .0796699
         2018  |  -.0356303   .0494389    -0.72   0.471    -.1325289    .0612682
         2019  |   .0147028   .0583604     0.25   0.801    -.0996815    .1290871
         2020  |  -.0002411    .060283    -0.00   0.997    -.1183937    .1179115
         2021  |  -.0786297   .0453343    -1.73   0.083    -.1674833    .0102239
         2022  |  -.0886328   .0526353    -1.68   0.092    -.1917962    .0145305
               |
         _cons |  -.5711879   .5191755    -1.10   0.271    -1.588753    .4463774
--------------------------------------------------------------------------------
Instruments for first differences equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L4.L4.ln_lc_encons
Instruments for levels equation
  Standard
    L.fdi L.voi_iq L.ln_cpi gdppc_growth cL.fdi#c.voi_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL3.L4.ln_lc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.09  Pr > z =  0.002
Arellano-Bond test for AR(2) in first differences: z =  -0.30  Pr > z =  0.768
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(21)   =  40.18  Prob > chi2 =  0.007
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(21)   =  13.84  Prob > chi2 =  0.876
  (Robust, but weakened by many instruments.)

**2.3. Low-carbon energy with pol_iq
xtabond2 L(0/1).ln_lc_encons fdi pol_iq ln_cpi gdppc_growth c.fdi#c.pol_iq i.yr, gmm(L4.ln_lc_encons, lag (4 4)) iv(L.fdi L.pol_iq L.ln_cpi gdppc_growth L.c.fdi#c.pol_iq i.yr, equation(level)) nodiffsargan twostep robust orthogonal 
est sto lc_poliq_sysgmm

Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       846
Time variable : yr                              Number of groups   =        47
Number of instruments = 45                      Obs per group: min =        18
Wald chi2(23) =  29034.48                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
  ln_lc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
  ln_lc_encons |
           L1. |   .9157395    .034559    26.50   0.000      .848005    .9834739
               |
           fdi |   .0087966   .0082992     1.06   0.289    -.0074694    .0250627
        pol_iq |   .1033017   .0329963     3.13   0.002     .0386302    .1679732
        ln_cpi |   .0605353   .0649769     0.93   0.352     -.066817    .1878876
  gdppc_growth |   .0041641   .0046445     0.90   0.370     -.004939    .0132671
               |
c.fdi#c.pol_iq |  -.0109562   .0101201    -1.08   0.279    -.0307913    .0088788
               |
            yr |
         2006  |  -.0290313   .0207009    -1.40   0.161    -.0696044    .0115418
         2007  |  -.0458411   .0294101    -1.56   0.119    -.1034839    .0118017
         2008  |  -.0437945   .0325271    -1.35   0.178    -.1075464    .0199575
         2009  |  -.0438015   .0404971    -1.08   0.279    -.1231743    .0355713
         2010  |  -.0191031   .0287285    -0.66   0.506      -.07541    .0372038
         2011  |  -.0328287   .0257796    -1.27   0.203    -.0833559    .0176984
         2012  |  -.0859521   .0320165    -2.68   0.007    -.1487034   -.0232009
         2013  |   .0015337   .0310316     0.05   0.961    -.0592871    .0623544
         2014  |  -.0405033   .0317945    -1.27   0.203    -.1028193    .0218127
         2015  |  -.0134034   .0365021    -0.37   0.713    -.0849462    .0581394
         2016  |  -.0603861    .047535    -1.27   0.204     -.153553    .0327809
         2017  |  -.0378023   .0377175    -1.00   0.316    -.1117272    .0361225
         2018  |  -.0626945   .0447302    -1.40   0.161    -.1503641     .024975
         2019  |  -.0003617   .0457783    -0.01   0.994    -.0900854     .089362
         2020  |  -.0438782    .047087    -0.93   0.351    -.1361671    .0484107
         2021  |  -.0995016   .0433987    -2.29   0.022    -.1845615   -.0144418
         2022  |  -.0888896   .0451874    -1.97   0.049    -.1774554   -.0003239
               |
         _cons |  -.2453832   .2956716    -0.83   0.407    -.8248889    .3341226
--------------------------------------------------------------------------------
Instruments for orthogonal deviations equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L4.L4.ln_lc_encons
Instruments for levels equation
  Standard
    L.fdi L.pol_iq L.ln_cpi gdppc_growth cL.fdi#c.pol_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL3.L4.ln_lc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -2.89  Pr > z =  0.004
Arellano-Bond test for AR(2) in first differences: z =  -0.23  Pr > z =  0.815
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(21)   =  47.30  Prob > chi2 =  0.001
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(21)   =  15.67  Prob > chi2 =  0.788
  (Robust, but weakened by many instruments.)


**2.4. Low-carbon energy with gov_iq
xtabond2 L(0/1).ln_lc_encons fdi gov_iq ln_cpi gdppc_growth c.fdi#c.gov_iq i.yr, gmm(L4.ln_lc_encons, lag (4 4)) iv(L.fdi gov_iq L.ln_cpi gdppc_growth L.c.fdi#c.gov_iq i.yr, equation(level)) nodiffsargan twostep robust  
est sto lc_goviq_sysgmm

Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       846
Time variable : yr                              Number of groups   =        47
Number of instruments = 45                      Obs per group: min =        18
Wald chi2(23) =   6508.98                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
  ln_lc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
  ln_lc_encons |
           L1. |   .8780153   .0477633    18.38   0.000     .7844009    .9716297
               |
           fdi |   .0072132   .0042003     1.72   0.086    -.0010191    .0154456
        gov_iq |   .1315724   .0612781     2.15   0.032     .0114696    .2516752
        ln_cpi |   .0466793   .0950281     0.49   0.623    -.1395723    .2329309
  gdppc_growth |   .0039967    .007496     0.53   0.594    -.0106952    .0186886
               |
c.fdi#c.gov_iq |  -.0054906   .0041867    -1.31   0.190    -.0136964    .0027152
               |
            yr |
         2005  |   .0234898    .025831     0.91   0.363    -.0271381    .0741177
         2006  |   .0019867   .0207279     0.10   0.924    -.0386391    .0426126
         2008  |  -.0055518   .0344348    -0.16   0.872    -.0730427    .0619392
         2009  |  -.0207464   .0665171    -0.31   0.755    -.1511174    .1096247
         2010  |   .0158834   .0343881     0.46   0.644     -.051516    .0832828
         2011  |   .0102251   .0264069     0.39   0.699    -.0415315    .0619818
         2012  |  -.0458401   .0424798    -1.08   0.281     -.129099    .0374189
         2013  |   .0487118   .0488563     1.00   0.319    -.0470448    .1444685
         2014  |   .0004264    .047573     0.01   0.993     -.092815    .0936678
         2015  |   .0198145   .0413401     0.48   0.632    -.0612106    .1008395
         2016  |  -.0080848   .0470857    -0.17   0.864    -.1003711    .0842015
         2017  |   .0257893   .0416493     0.62   0.536    -.0558418    .1074204
         2018  |   -.001492   .0546822    -0.03   0.978    -.1086673    .1056832
         2019  |   .0351015    .052863     0.66   0.507     -.068508    .1387111
         2020  |  -.0068972   .0839219    -0.08   0.934    -.1713812    .1575867
         2021  |  -.0300846   .0472812    -0.64   0.525    -.1227539    .0625848
         2022  |    -.04433   .0617331    -0.72   0.473    -.1653246    .0766645
               |
         _cons |  -.2938159    .433738    -0.68   0.498    -1.143927     .556295
--------------------------------------------------------------------------------


**2.4. Low-carbon energy with reg_iq
xtabond2 L(0/1).ln_lc_encons fdi reg_iq ln_cpi gdppc_growth c.fdi#c.reg_iq i.yr, gmm(L4.ln_lc_encons, lag (4 4)) iv(L.fdi reg_iq L.ln_cpi gdppc_growth L.c.fdi#c.reg_iq i.yr, equation(level)) nodiffsargan twostep robust orthogonal 
est sto lc_regiq_sysgmm
Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       846
Time variable : yr                              Number of groups   =        47
Number of instruments = 45                      Obs per group: min =        18
Wald chi2(23) =   8932.76                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
  ln_lc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
  ln_lc_encons |
           L1. |   .8909134   .0338982    26.28   0.000     .8244741    .9573528
               |
           fdi |   .0085398   .0030214     2.83   0.005     .0026179    .0144616
        reg_iq |   .1396136   .0434025     3.22   0.001     .0545462     .224681
        ln_cpi |   .0933577   .0845209     1.10   0.269    -.0723002    .2590156
  gdppc_growth |   .0068226   .0067213     1.02   0.310    -.0063508    .0199961
               |
c.fdi#c.reg_iq |  -.0070173   .0034387    -2.04   0.041     -.013757   -.0002776
               |
            yr |
         2005  |   .0898098   .0467975     1.92   0.055    -.0019116    .1815312
         2006  |   .0604511   .0451128     1.34   0.180    -.0279683    .1488705
         2007  |   .0661404   .0422608     1.57   0.118    -.0166892    .1489701
         2008  |   .0578024   .0478841     1.21   0.227    -.0360488    .1516535
         2009  |   .0520609   .0678955     0.77   0.443    -.0810119    .1851338
         2010  |    .068442   .0340267     2.01   0.044     .0017508    .1351332
         2011  |   .0655717   .0379405     1.73   0.084    -.0087903    .1399338
         2012  |   .0116056   .0465649     0.25   0.803    -.0796598     .102871
         2013  |   .1049513   .0468713     2.24   0.025     .0130852    .1968175
         2014  |   .0572529   .0417227     1.37   0.170     -.024522    .1390278
         2015  |    .078884   .0439108     1.80   0.072    -.0071796    .1649477
         2016  |   .0515303   .0519675     0.99   0.321    -.0503242    .1533847
         2017  |   .0681973   .0364049     1.87   0.061     -.003155    .1395496
         2018  |   .0428442   .0283293     1.51   0.130    -.0126803    .0983687
         2019  |   .0771602   .0514764     1.50   0.134    -.0237317    .1780521
         2020  |   .0596581   .0690829     0.86   0.388    -.0757419     .195058
         2022  |  -.0085913   .0341667    -0.25   0.801    -.0755568    .0583742
               |
         _cons |  -.5808998    .416616    -1.39   0.163    -1.397452    .2356525
--------------------------------------------------------------------------------
Instruments for orthogonal deviations equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L4.L4.ln_lc_encons
Instruments for levels equation
  Standard
    L.fdi reg_iq L.ln_cpi gdppc_growth cL.fdi#c.reg_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL3.L4.ln_lc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.08  Pr > z =  0.002
Arellano-Bond test for AR(2) in first differences: z =  -0.36  Pr > z =  0.721
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(21)   =  25.04  Prob > chi2 =  0.245
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(21)   =  13.38  Prob > chi2 =  0.895
  (Robust, but weakened by many instruments.)

**2.5. Low-carbon energy with rul_iq
xtabond2 L(0/1).ln_lc_encons fdi rul_iq ln_cpi gdppc_growth c.fdi#c.rul_iq i.yr, gmm(L4.ln_lc_encons, lag (4 4)) iv(L.fdi rul_iq L.ln_cpi gdppc_growth L.c.fdi#c.rul_iq i.yr, equation(level)) nodiffsargan twostep robust orthogonal 
est sto lc_ruliq_sysgmm
Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       846
Time variable : yr                              Number of groups   =        47
Number of instruments = 45                      Obs per group: min =        18
Wald chi2(23) =   4639.88                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
  ln_lc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
  ln_lc_encons |
           L1. |   .8796564   .0378878    23.22   0.000     .8053976    .9539152
               |
           fdi |   .0085351   .0029478     2.90   0.004     .0027575    .0143126
        rul_iq |   .1338393   .0453984     2.95   0.003     .0448602    .2228185
        ln_cpi |      .0784   .0921622     0.85   0.395    -.1022346    .2590346
  gdppc_growth |   .0049506   .0068619     0.72   0.471    -.0084985    .0183997
               |
c.fdi#c.rul_iq |  -.0068723   .0033416    -2.06   0.040    -.0134216   -.0003229
               |
            yr |
         2005  |    .074562   .0488481     1.53   0.127    -.0211785    .1703026
         2006  |   .0535711    .046363     1.16   0.248    -.0372988     .144441
         2007  |    .059932   .0430771     1.39   0.164    -.0244975    .1443616
         2008  |   .0479665    .044425     1.08   0.280    -.0391048    .1350378
         2009  |   .0305536   .0640468     0.48   0.633    -.0949758     .156083
         2010  |   .0557318   .0357465     1.56   0.119      -.01433    .1257935
         2011  |   .0547875   .0351299     1.56   0.119    -.0140658    .1236408
         2012  |  -.0049304   .0421692    -0.12   0.907    -.0875804    .0777196
         2013  |   .0941905   .0429793     2.19   0.028     .0099527    .1784284
         2014  |   .0322429   .0393747     0.82   0.413    -.0449301     .109416
         2015  |    .067857   .0393964     1.72   0.085    -.0093585    .1450724
         2016  |   .0342213    .044312     0.77   0.440    -.0526285    .1210711
         2017  |   .0631707   .0340901     1.85   0.064    -.0036447    .1299861
         2018  |   .0357205   .0333927     1.07   0.285     -.029728     .101169
         2019  |   .0778196   .0493948     1.58   0.115    -.0189925    .1746317
         2020  |   .0348944   .0729723     0.48   0.633    -.1081286    .1779174
         2022  |  -.0133196   .0362898    -0.37   0.714    -.0844463    .0578072
               |
         _cons |  -.4889577   .4553066    -1.07   0.283    -1.381342    .4034268
--------------------------------------------------------------------------------
Instruments for orthogonal deviations equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L4.L4.ln_lc_encons
Instruments for levels equation
  Standard
    L.fdi rul_iq L.ln_cpi gdppc_growth cL.fdi#c.rul_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL3.L4.ln_lc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.10  Pr > z =  0.002
Arellano-Bond test for AR(2) in first differences: z =  -0.41  Pr > z =  0.684
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(21)   =  28.52  Prob > chi2 =  0.126
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(21)   =  14.02  Prob > chi2 =  0.869
  (Robust, but weakened by many instruments.)

**2.6. Low-carbon energy with con_iq
xtabond2 L(0/1).ln_lc_encons fdi con_iq ln_cpi gdppc_growth c.fdi#c.con_iq i.yr, gmm(L4.ln_lc_encons, lag (4 4)) iv(L.fdi L.con_iq L.ln_cpi gdppc_growth L.c.fdi#c.con_iq i.yr, equation(level)) nodiffsargan twostep robust orthogonal
 est sto lc_coniq_sysgmm
Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       846
Time variable : yr                              Number of groups   =        47
Number of instruments = 45                      Obs per group: min =        18
Wald chi2(23) =   7247.65                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
  ln_lc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
  ln_lc_encons |
           L1. |   .8911877   .0380847    23.40   0.000      .816543    .9658323
               |
           fdi |   .0056523   .0019086     2.96   0.003     .0019115    .0093931
        con_iq |   .0907105   .0335179     2.71   0.007     .0250167    .1564044
        ln_cpi |   .0567591   .0838513     0.68   0.498    -.1075865    .2211047
  gdppc_growth |   .0050013   .0061187     0.82   0.414    -.0069912    .0169937
               |
c.fdi#c.con_iq |  -.0048699   .0026752    -1.82   0.069    -.0101132    .0003734
               |
            yr |
         2005  |   .0720614   .0467255     1.54   0.123    -.0195189    .1636417
         2006  |   .0503309   .0449009     1.12   0.262    -.0376733    .1383351
         2007  |   .0558855   .0423099     1.32   0.187    -.0270404    .1388115
         2008  |   .0447122   .0432442     1.03   0.301    -.0400449    .1294693
         2009  |   .0328801   .0614908     0.53   0.593    -.0876398    .1533999
         2010  |   .0598533   .0332546     1.80   0.072    -.0053246    .1250312
         2011  |   .0576695   .0351352     1.64   0.101    -.0111942    .1265332
         2012  |   .0034952   .0424092     0.08   0.934    -.0796254    .0866158
         2013  |   .0969712   .0428455     2.26   0.024     .0129957    .1809468
         2014  |   .0499295   .0395739     1.26   0.207     -.027634    .1274931
         2015  |   .0772438   .0414492     1.86   0.062    -.0039952    .1584828
         2016  |   .0423102   .0483331     0.88   0.381    -.0524209    .1370412
         2017  |   .0639383   .0358021     1.79   0.074    -.0062324    .1341091
         2018  |   .0362125   .0267884     1.35   0.176    -.0162917    .0887167
         2019  |   .0881295   .0474624     1.86   0.063    -.0048951    .1811541
         2020  |   .0384975    .065243     0.59   0.555    -.0893763    .1663714
         2022  |  -.0086725   .0311032    -0.28   0.780    -.0696335    .0522886
               |
         _cons |  -.3466012   .4129425    -0.84   0.401    -1.155954    .4627512
--------------------------------------------------------------------------------
Instruments for orthogonal deviations equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L4.L4.ln_lc_encons
Instruments for levels equation
  Standard
    L.fdi L.con_iq L.ln_cpi gdppc_growth cL.fdi#c.con_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL3.L4.ln_lc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.03  Pr > z =  0.002
Arellano-Bond test for AR(2) in first differences: z =  -0.36  Pr > z =  0.720
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(21)   =  28.95  Prob > chi2 =  0.115
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(21)   =  13.27  Prob > chi2 =  0.899
  (Robust, but weakened by many instruments.)
 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
***STEP 2: GMM to Non-low-carbon enegy
**2.1. Non-low-carbon energy with composite institutional quality
*2.1.1. Upper bound vs. Lower bound
*2.1.1.1. upper bound: pooled ols
reg L(0/1).ln_nlc_encons fdi composite_iq ln_cpi gdppc_growth c.fdi#c.composite_iq i.yr
est sto nlc_comiq_ols
	//result: .9916427  
*2.1.1.2 lower bound: fixed effect
xtreg L(0/1).ln_nlc_encons fdi composite_iq ln_cpi gdppc_growth c.fdi#c.composite_iq i.yr, fe robust
est sto nlc_comiq_fe
	//result: .823528 
**2.1.2 Difference GMM vs. System GMM
*2.1.2.1 twostep difference gmm
xtabond2 L(0/1).ln_nlc_encons fdi composite_iq ln_cpi gdppc_growth c.fdi#c.composite_iq i.yr, gmm(L4.ln_nlc_encons L8.fdi L7.composite_iq L7.ln_cpi L5.gdppc_growth L7.c.fdi#c.composite_iq, lag(8 8)) iv(i.yr)noleveleq nodiffsargan twostep robust orthogonal small
est sto nlc_comiq_diffgmm
	//result: .5803862 => system GMM is the way to go
*2.1.2.2. twostep system gmm
xtabond2 L(0/1).ln_nlc_encons fdi composite_iq ln_cpi gdppc_growth c.fdi#c.composite_iq i.yr, gmm(L4.ln_nlc_encons, lag (4 4)) iv(L.fdi L.composite_iq L.ln_cpi L.gdppc_growth L.c.fdi#c.composite_iq i.yr, equation(level)) nodiffsargan twostep robust 
est sto nlc_comiq_sysgmm

Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       882
Time variable : yr                              Number of groups   =        49
Number of instruments = 33                      Obs per group: min =        18
Wald chi2(23) = 977669.58                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------------
                     |              Corrected
       ln_nlc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------------+----------------------------------------------------------------
       ln_nlc_encons |
                 L1. |   .9237882   .0409062    22.58   0.000     .8436136    1.003963
                     |
                 fdi |    -.00114   .0020415    -0.56   0.577    -.0051413    .0028612
        composite_iq |   .0548047   .0439204     1.25   0.212    -.0312776     .140887
              ln_cpi |   .0098303   .0384855     0.26   0.798    -.0655999    .0852605
        gdppc_growth |   .0045837   .0059457     0.77   0.441    -.0070697    .0162371
                     |
c.fdi#c.composite_iq |   .0014391   .0020152     0.71   0.475    -.0025106    .0053887
                     |
                  yr |
               2005  |  -.0014996   .0226276    -0.07   0.947    -.0458489    .0428496
               2006  |  -.0101228   .0207567    -0.49   0.626    -.0508052    .0305596
               2007  |  -.0055815   .0203005    -0.27   0.783    -.0453699    .0342068
               2008  |  -.0194184   .0342813    -0.57   0.571    -.0866085    .0477717
               2009  |   -.075335   .0630511    -1.19   0.232    -.1989129    .0482428
               2010  |   .0485154   .0250743     1.93   0.053    -.0006294    .0976602
               2011  |  -.0162859   .0240948    -0.68   0.499    -.0635109    .0309392
               2012  |  -.0244877   .0316067    -0.77   0.438    -.0864358    .0374603
               2013  |   .0101137    .034202     0.30   0.767    -.0569209    .0771483
               2014  |  -.0179054   .0257538    -0.70   0.487    -.0683819    .0325711
               2015  |  -.0220392   .0244838    -0.90   0.368    -.0700265    .0259481
               2016  |  -.0197104   .0220764    -0.89   0.372    -.0629792    .0235585
               2017  |  -.0012766   .0208083    -0.06   0.951    -.0420602    .0395069
               2018  |  -.0035091   .0210213    -0.17   0.867      -.04471    .0376918
               2019  |  -.0305335   .0265494    -1.15   0.250    -.0825695    .0215024
               2020  |  -.0173989   .0616055    -0.28   0.778    -.1381436    .1033457
               2022  |  -.0390754    .022055    -1.77   0.076    -.0823025    .0041516
                     |
               _cons |    .181565   .1888478     0.96   0.336    -.1885699    .5516998
--------------------------------------------------------------------------------------
Instruments for first differences equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L7.L7.ln_nlc_encons
Instruments for levels equation
  Standard
    L.fdi L.composite_iq L.ln_cpi L.gdppc_growth cL.fdi#c.composite_iq
    2004b.yr 2005.yr 2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr
    2013.yr 2014.yr 2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr
    2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL6.L7.ln_nlc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.09  Pr > z =  0.002
Arellano-Bond test for AR(2) in first differences: z =  -0.32  Pr > z =  0.746
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(9)    =  21.61  Prob > chi2 =  0.010
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(9)    =  10.19  Prob > chi2 =  0.335
  (Robust, but weakened by many instruments.)

**2.2. Non-low-carbon energy with voi_iq
xtabond2 L(0/1).ln_nlc_encons fdi voi_iq ln_cpi gdppc_growth c.fdi#c.voi_iq i.yr, gmm(L7.ln_nlc_encons, lag (7 7)) iv(L.fdi L.voi_iq L.ln_cpi L.gdppc_growth L.c.fdi#c.voi_iq i.yr, equation(level)) nodiffsargan twostep robust 
est sto nlc_voiiq_sysgmm


Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       882
Time variable : yr                              Number of groups   =        49
Number of instruments = 33                      Obs per group: min =        18
Wald chi2(23) = 843537.70                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
 ln_nlc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
 ln_nlc_encons |
           L1. |   .9206787   .0322157    28.58   0.000     .8575371    .9838203
               |
           fdi |   .0046794   .0026618     1.76   0.079    -.0005375    .0098964
        voi_iq |   .0478488   .0308749     1.55   0.121     -.012665    .1083625
        ln_cpi |  -.0050381   .0365504    -0.14   0.890    -.0766756    .0665993
  gdppc_growth |   .0031476   .0053087     0.59   0.553    -.0072572    .0135524
               |
c.fdi#c.voi_iq |  -.0027691   .0018519    -1.50   0.135    -.0063989    .0008606
               |
            yr |
         2005  |  -.0041592   .0229728    -0.18   0.856     -.049185    .0408667
         2006  |  -.0149147   .0218234    -0.68   0.494    -.0576878    .0278585
         2007  |  -.0102383   .0206892    -0.49   0.621    -.0507883    .0303118
         2008  |  -.0246024   .0327214    -0.75   0.452    -.0887351    .0395303
         2009  |   -.084587   .0560949    -1.51   0.132     -.194531    .0253569
         2010  |   .0473577   .0239615     1.98   0.048     .0003941    .0943214
         2011  |  -.0206482   .0228504    -0.90   0.366    -.0654341    .0241378
         2012  |  -.0270088   .0301675    -0.90   0.371    -.0861361    .0321184
         2013  |   .0089161    .033039     0.27   0.787    -.0558392    .0736713
         2014  |  -.0170097   .0242693    -0.70   0.483    -.0645766    .0305572
         2015  |  -.0255497   .0229601    -1.11   0.266    -.0705508    .0194513
         2016  |  -.0221976   .0218474    -1.02   0.310    -.0650177    .0206226
         2017  |  -.0025267     .01922    -0.13   0.895    -.0401972    .0351438
         2018  |  -.0009284   .0200103    -0.05   0.963    -.0401478     .038291
         2019  |  -.0365222   .0252667    -1.45   0.148    -.0860439    .0129995
         2020  |  -.0345152   .0545556    -0.63   0.527    -.1414421    .0724118
         2022  |  -.0400092   .0202934    -1.97   0.049    -.0797835   -.0002348
               |
         _cons |   .2678679   .1901732     1.41   0.159    -.1048648    .6406006
--------------------------------------------------------------------------------
Instruments for first differences equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L7.L7.ln_nlc_encons
Instruments for levels equation
  Standard
    L.fdi L.voi_iq L.ln_cpi L.gdppc_growth cL.fdi#c.voi_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL6.L7.ln_nlc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.09  Pr > z =  0.002
Arellano-Bond test for AR(2) in first differences: z =  -0.67  Pr > z =  0.505
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(9)    =  19.69  Prob > chi2 =  0.020
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(9)    =   8.09  Prob > chi2 =  0.525
  (Robust, but weakened by many instruments.)


**2.3. Non-low-carbon energy with pol_iq
xtabond2 L(0/1).ln_nlc_encons fdi pol_iq ln_cpi gdppc_growth c.fdi#c.pol_iq i.yr, gmm(L7.ln_nlc_encons, lag (7 7)) iv(L.fdi L.pol_iq L.ln_cpi gdppc_growth L.c.fdi#c.pol_iq i.yr, equation(level)) nodiffsargan twostep robust orthogonal 
est sto nlc_poliq_sysgmm

Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       882
Time variable : yr                              Number of groups   =        49
Number of instruments = 33                      Obs per group: min =        18
Wald chi2(23) = 820826.42                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
 ln_nlc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
 ln_nlc_encons |
           L1. |   .9133011   .0298355    30.61   0.000     .8548246    .9717775
               |
           fdi |  -.0014109   .0029378    -0.48   0.631    -.0071689    .0043471
        pol_iq |   .0503488   .0276445     1.82   0.069    -.0038334     .104531
        ln_cpi |  -.0060025   .0361404    -0.17   0.868    -.0768364    .0648313
  gdppc_growth |   .0035477   .0026721     1.33   0.184    -.0016895    .0087849
               |
c.fdi#c.pol_iq |   .0018935   .0032397     0.58   0.559    -.0044562    .0082432
               |
            yr |
         2005  |   .0360564   .0255359     1.41   0.158    -.0139931    .0861058
         2006  |   .0260333   .0234052     1.11   0.266    -.0198401    .0719066
         2007  |   .0349587    .026818     1.30   0.192    -.0176036     .087521
         2008  |   .0150064   .0289782     0.52   0.605    -.0417899    .0718027
         2009  |  -.0473271   .0328446    -1.44   0.150    -.1117013    .0170472
         2010  |   .0850255   .0231768     3.67   0.000     .0395998    .1304512
         2011  |   .0208106   .0259815     0.80   0.423    -.0301123    .0717335
         2012  |   .0081135   .0252976     0.32   0.748    -.0414689    .0576959
         2013  |   .0439012   .0275145     1.60   0.111    -.0100262    .0978286
         2014  |   .0171319   .0190296     0.90   0.368    -.0201654    .0544293
         2015  |    .014072   .0181882     0.77   0.439    -.0215762    .0497202
         2016  |   .0202763   .0217327     0.93   0.351    -.0223191    .0628717
         2017  |   .0356117   .0180942     1.97   0.049     .0001477    .0710757
         2018  |   .0326969   .0158203     2.07   0.039     .0016896    .0637041
         2019  |   .0030535   .0188772     0.16   0.871    -.0339452    .0400522
         2020  |    .011083   .0292103     0.38   0.704    -.0461683    .0683342
         2021  |   .0396883   .0157056     2.53   0.012     .0089059    .0704707
               |
         _cons |   .2871345   .2099432     1.37   0.171    -.1243465    .6986156
--------------------------------------------------------------------------------
Instruments for orthogonal deviations equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L7.L7.ln_nlc_encons
Instruments for levels equation
  Standard
    L.fdi L.pol_iq L.ln_cpi gdppc_growth cL.fdi#c.pol_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL6.L7.ln_nlc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.14  Pr > z =  0.002
Arellano-Bond test for AR(2) in first differences: z =  -0.37  Pr > z =  0.708
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(9)    =  24.99  Prob > chi2 =  0.003
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(9)    =   8.92  Prob > chi2 =  0.444
  (Robust, but weakened by many instruments.)

**2.4. Non-low-carbon energy with gov_iq
xtabond2 L(0/1).ln_nlc_encons fdi gov_iq ln_cpi gdppc_growth c.fdi#c.gov_iq i.yr, gmm(L7.ln_nlc_encons, lag (7 7)) iv(L.fdi L.gov_iq L.ln_cpi gdppc_growth L.c.fdi#c.gov_iq i.yr, equation(level)) nodiffsargan twostep robust  
est sto nlc_goviq_sysgmm

Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       882
Time variable : yr                              Number of groups   =        49
Number of instruments = 33                      Obs per group: min =        18
Wald chi2(23) = 508513.15                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
 ln_nlc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
 ln_nlc_encons |
           L1. |   .8778754    .076404    11.49   0.000     .7281263    1.027624
               |
           fdi |     .00061   .0038196     0.16   0.873    -.0068762    .0080962
        gov_iq |    .101591   .0776575     1.31   0.191    -.0506148    .2537968
        ln_cpi |   .0134202   .0407381     0.33   0.742    -.0664249    .0932654
  gdppc_growth |   .0055183   .0035095     1.57   0.116    -.0013602    .0123968
               |
c.fdi#c.gov_iq |   .0002141   .0023591     0.09   0.928    -.0044097    .0048379
               |
            yr |
         2005  |   .0030128   .0198336     0.15   0.879    -.0358603     .041886
         2006  |  -.0085115   .0206828    -0.41   0.681     -.049049     .032026
         2007  |   -.005025   .0181742    -0.28   0.782    -.0406458    .0305958
         2008  |  -.0152725   .0230792    -0.66   0.508    -.0605069     .029962
         2009  |  -.0715407   .0388663    -1.84   0.066    -.1477173     .004636
         2010  |   .0452786   .0189781     2.39   0.017     .0080822    .0824749
         2011  |  -.0135589    .018089    -0.75   0.454    -.0490127    .0218948
         2012  |  -.0223135   .0216754    -1.03   0.303    -.0647964    .0201694
         2013  |    .010373    .025608     0.41   0.685    -.0398177    .0605637
         2014  |  -.0150071   .0159294    -0.94   0.346    -.0462282    .0162141
         2015  |  -.0212326   .0166108    -1.28   0.201    -.0537892    .0113239
         2016  |  -.0180256   .0131357    -1.37   0.170    -.0437711      .00772
         2017  |  -.0017639   .0132799    -0.13   0.894    -.0277921    .0242642
         2018  |   .0026421    .013917     0.19   0.849    -.0246347    .0299189
         2019  |  -.0305573   .0163248    -1.87   0.061    -.0625533    .0014387
         2020  |  -.0106338   .0351957    -0.30   0.763    -.0796161    .0583484
         2022  |  -.0342772    .015819    -2.17   0.030    -.0652818   -.0032725
               |
         _cons |   .2692769   .2692056     1.00   0.317    -.2583565    .7969102
--------------------------------------------------------------------------------
Instruments for first differences equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L7.L7.ln_nlc_encons
Instruments for levels equation
  Standard
    L.fdi L.gov_iq L.ln_cpi gdppc_growth cL.fdi#c.gov_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL6.L7.ln_nlc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -2.84  Pr > z =  0.004
Arellano-Bond test for AR(2) in first differences: z =  -0.44  Pr > z =  0.656
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(9)    =  20.32  Prob > chi2 =  0.016
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(9)    =  10.07  Prob > chi2 =  0.345
  (Robust, but weakened by many instruments.)


**2.4. Low-carbon energy with reg_iq
xtabond2 L(0/1).ln_nlc_encons fdi reg_iq ln_cpi gdppc_growth c.fdi#c.reg_iq i.yr, gmm(L7.ln_nlc_encons, lag (7 7)) iv(L.fdi reg_iq L.ln_cpi gdppc_growth L.c.fdi#c.reg_iq i.yr, equation(level)) nodiffsargan twostep robust  
est sto nlc_regiq_sysgmm

Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       882
Time variable : yr                              Number of groups   =        49
Number of instruments = 33                      Obs per group: min =        18
Wald chi2(23) =  2.15e+06                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
 ln_nlc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
 ln_nlc_encons |
           L1. |   .9400643   .0401009    23.44   0.000     .8614679    1.018661
               |
           fdi |   .0011752   .0016706     0.70   0.482    -.0020991    .0044494
        reg_iq |   .0416778   .0444056     0.94   0.348    -.0453555    .1287111
        ln_cpi |   .0051212   .0432837     0.12   0.906    -.0797134    .0899558
  gdppc_growth |   .0048228    .003006     1.60   0.109    -.0010689    .0107144
               |
c.fdi#c.reg_iq |  -.0002315   .0013847    -0.17   0.867    -.0029455    .0024825
               |
            yr |
         2005  |   .0061964   .0113059     0.55   0.584    -.0159627    .0283555
         2006  |  -.0025826   .0120525    -0.21   0.830    -.0262051    .0210399
         2008  |  -.0144309   .0159564    -0.90   0.366    -.0457048     .016843
         2009  |  -.0657016   .0314886    -2.09   0.037    -.1274182    -.003985
         2010  |   .0580807   .0138395     4.20   0.000     .0309557    .0852056
         2011  |  -.0087755   .0186202    -0.47   0.637    -.0452703    .0277194
         2012  |  -.0147289   .0173198    -0.85   0.395    -.0486751    .0192173
         2013  |   .0168244   .0228528     0.74   0.462    -.0279663    .0616151
         2014  |  -.0089508   .0165781    -0.54   0.589    -.0414433    .0235417
         2015  |  -.0128308   .0178741    -0.72   0.473    -.0478633    .0222017
         2016  |  -.0132609   .0149743    -0.89   0.376    -.0426099    .0160882
         2017  |   .0057896   .0185882     0.31   0.755    -.0306426    .0422217
         2018  |   .0041956   .0215129     0.20   0.845     -.037969    .0463602
         2019  |  -.0264567   .0201807    -1.31   0.190    -.0660102    .0130968
         2020  |  -.0121703   .0343145    -0.35   0.723    -.0794255    .0550849
         2021  |   .0056941    .018051     0.32   0.752    -.0296852    .0410735
         2022  |  -.0303694   .0260581    -1.17   0.244    -.0814424    .0207036
               |
         _cons |   .1412073   .1373307     1.03   0.304    -.1279559    .4103704
--------------------------------------------------------------------------------
Instruments for first differences equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L7.L7.ln_nlc_encons
Instruments for levels equation
  Standard
    L.fdi reg_iq L.ln_cpi gdppc_growth cL.fdi#c.reg_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL6.L7.ln_nlc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.06  Pr > z =  0.002
Arellano-Bond test for AR(2) in first differences: z =  -0.44  Pr > z =  0.661
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(9)    =  21.44  Prob > chi2 =  0.011
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(9)    =  10.02  Prob > chi2 =  0.349
  (Robust, but weakened by many instruments.)


**2.5. Non-low-carbon energy with rul_iq
xtabond2 L(0/1).ln_nlc_encons fdi rul_iq ln_cpi gdppc_growth c.fdi#c.rul_iq i.yr, gmm(L7.ln_nlc_encons, lag (7 7)) iv(L.fdi rul_iq L.ln_cpi gdppc_growth L.c.fdi#c.rul_iq i.yr, equation(level)) nodiffsargan twostep robust orthogonal 
est sto nlc_ruliq_sysgmm

Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       882
Time variable : yr                              Number of groups   =        49
Number of instruments = 33                      Obs per group: min =        18
Wald chi2(23) = 804534.60                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
 ln_nlc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
 ln_nlc_encons |
           L1. |   .9156474    .049178    18.62   0.000     .8192604    1.012034
               |
           fdi |  -.0008071    .001963    -0.41   0.681    -.0046545    .0030403
        rul_iq |   .0565984    .046699     1.21   0.226      -.03493    .1481267
        ln_cpi |   .0057029   .0390271     0.15   0.884    -.0707889    .0821946
  gdppc_growth |   .0056597   .0034723     1.63   0.103    -.0011459    .0124653
               |
c.fdi#c.rul_iq |   .0010268   .0016198     0.63   0.526    -.0021479    .0042014
               |
            yr |
         2005  |   .0413019    .027345     1.51   0.131    -.0122933    .0948972
         2006  |   .0290608   .0267847     1.08   0.278    -.0234363    .0815579
         2007  |   .0343876    .028252     1.22   0.224    -.0209854    .0897605
         2008  |   .0262386   .0307674     0.85   0.394    -.0340645    .0865417
         2009  |   -.026979   .0384773    -0.70   0.483    -.1023931     .048435
         2010  |   .0890378   .0241363     3.69   0.000     .0417316     .136344
         2011  |     .02511   .0241066     1.04   0.298    -.0221381    .0723582
         2012  |   .0200096    .027411     0.73   0.465    -.0337149    .0737341
         2013  |   .0561241   .0307415     1.83   0.068    -.0041282    .1163764
         2014  |   .0206903    .019352     1.07   0.285    -.0172389    .0586195
         2015  |   .0174176   .0188077     0.93   0.354     -.019445    .0542801
         2016  |   .0229348   .0217824     1.05   0.292     -.019758    .0656275
         2017  |   .0399091   .0194965     2.05   0.041     .0016967    .0781215
         2018  |   .0384984   .0176402     2.18   0.029     .0039242    .0730725
         2019  |   .0138617   .0201314     0.69   0.491    -.0255951    .0533185
         2020  |   .0313699   .0362349     0.87   0.387    -.0396492    .1023889
         2021  |   .0376674   .0176909     2.13   0.033     .0029939    .0723408
               |
         _cons |   .1791803   .2171638     0.83   0.409    -.2464528    .6048135
--------------------------------------------------------------------------------
Instruments for orthogonal deviations equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L7.L7.ln_nlc_encons
Instruments for levels equation
  Standard
    L.fdi rul_iq L.ln_cpi gdppc_growth cL.fdi#c.rul_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL6.L7.ln_nlc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.09  Pr > z =  0.002
Arellano-Bond test for AR(2) in first differences: z =  -0.42  Pr > z =  0.672
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(9)    =  21.19  Prob > chi2 =  0.012
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(9)    =  10.95  Prob > chi2 =  0.279
  (Robust, but weakened by many instruments.)


**2.6. Non-low-carbon energy with con_iq
xtabond2 L(0/1).ln_nlc_encons fdi con_iq ln_cpi gdppc_growth c.fdi#c.con_iq i.yr, gmm(L7.ln_nlc_encons, lag (7 7)) iv(L.fdi L.con_iq L.ln_cpi gdppc_growth L.c.fdi#c.con_iq i.yr, equation(level)) nodiffsargan twostep robust orthogonal
 est sto nlc_coniq_sysgmm

 
Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       882
Time variable : yr                              Number of groups   =        49
Number of instruments = 33                      Obs per group: min =        18
Wald chi2(23) = 839781.85                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
 ln_nlc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
 ln_nlc_encons |
           L1. |   .9222666   .0425909    21.65   0.000       .83879    1.005743
               |
           fdi |  -.0002142   .0015656    -0.14   0.891    -.0032828    .0028544
        con_iq |   .0421401   .0330861     1.27   0.203    -.0227074    .1069876
        ln_cpi |  -.0035363   .0362091    -0.10   0.922    -.0745047    .0674322
  gdppc_growth |   .0051477   .0033233     1.55   0.121    -.0013658    .0116612
               |
c.fdi#c.con_iq |   .0006817   .0011245     0.61   0.544    -.0015222    .0028857
               |
            yr |
         2005  |   .0065589   .0329483     0.20   0.842    -.0580186    .0711365
         2006  |  -.0039365   .0386173    -0.10   0.919     -.079625     .071752
         2007  |   .0023959   .0354442     0.07   0.946    -.0670734    .0718653
         2008  |  -.0068482   .0273297    -0.25   0.802    -.0604133     .046717
         2009  |  -.0613258   .0182361    -3.36   0.001    -.0970678   -.0255838
         2010  |   .0600294   .0283841     2.11   0.034     .0043975    .1156612
         2011  |  -.0037073   .0274439    -0.14   0.893    -.0574963    .0500817
         2012  |  -.0091726   .0247541    -0.37   0.711    -.0576897    .0393445
         2013  |   .0262487   .0298288     0.88   0.379    -.0322146     .084712
         2014  |  -.0018288    .026714    -0.07   0.945    -.0541873    .0505297
         2015  |  -.0070741   .0236276    -0.30   0.765    -.0533832    .0392351
         2016  |  -.0045186   .0273358    -0.17   0.869    -.0580957    .0490584
         2017  |   .0152008   .0266045     0.57   0.568     -.036943    .0673446
         2018  |   .0114307   .0255408     0.45   0.654    -.0386283    .0614897
         2019  |  -.0142299   .0248412    -0.57   0.567    -.0629177     .034458
         2021  |   .0125503   .0346411     0.36   0.717     -.055345    .0804456
         2022  |  -.0261296   .0335852    -0.78   0.437    -.0919555    .0396962
               |
         _cons |   .2431334   .2002593     1.21   0.225    -.1493676    .6356345
--------------------------------------------------------------------------------
Instruments for orthogonal deviations equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L7.L7.ln_nlc_encons
Instruments for levels equation
  Standard
    L.fdi L.con_iq L.ln_cpi gdppc_growth cL.fdi#c.con_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL6.L7.ln_nlc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.10  Pr > z =  0.002
Arellano-Bond test for AR(2) in first differences: z =  -0.36  Pr > z =  0.722
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(9)    =  20.62  Prob > chi2 =  0.014
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(9)    =  10.29  Prob > chi2 =  0.328
  (Robust, but weakened by many instruments.)
  
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
***STEP 3: GMM to Total energy
**2.1. Total energy with composite institutional quality
*2.1.1. Upper bound vs. Lower bound
*2.1.1.1. upper bound: pooled ols
reg L(0/1).ln_tc_encons fdi composite_iq ln_cpi gdppc_growth c.fdi#c.composite_iq i.yr
est sto tc_comiq_ols
	//result: .9915247  
*2.1.1.2 lower bound: fixed effect
xtreg L(0/1).ln_tc_encons fdi composite_iq ln_cpi gdppc_growth c.fdi#c.composite_iq i.yr, fe robust
est sto tc_comiq_fe
	//result: .8308939 
**2.1.2 Difference GMM vs. System GMM
*2.1.2.1 twostep difference gmm
xtabond2 L(0/1).ln_tc_encons fdi composite_iq ln_cpi gdppc_growth c.fdi#c.composite_iq i.yr, gmm(L4.ln_tc_encons L8.fdi L7.composite_iq L7.ln_cpi L5.gdppc_growth L7.c.fdi#c.composite_iq, lag(8 8)) iv(i.yr)noleveleq nodiffsargan twostep robust orthogonal small
est sto nlc_comiq_diffgmm
	//result: .5348232 => system GMM is the way to go
*2.1.2.2. twostep system gmm
xtabond2 L(0/1).ln_tc_encons fdi composite_iq ln_cpi gdppc_growth c.fdi#c.composite_iq i.yr, gmm(L4.ln_tc_encons, lag (4 4)) iv(L.fdi L.composite_iq L.ln_cpi L.gdppc_growth L.c.fdi#c.composite_iq i.yr, equation(level)) nodiffsargan twostep robust 
est sto tc_comiq_sysgmm

Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       882
Time variable : yr                              Number of groups   =        49
Number of instruments = 45                      Obs per group: min =        18
Wald chi2(23) = 979013.80                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------------
                     |              Corrected
        ln_tc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------------+----------------------------------------------------------------
        ln_tc_encons |
                 L1. |   .9840498    .042402    23.21   0.000     .9009434    1.067156
                     |
                 fdi |  -.0005315   .0017735    -0.30   0.764    -.0040075    .0029445
        composite_iq |   .0005846   .0369091     0.02   0.987     -.071756    .0729252
              ln_cpi |  -.0254898   .0344424    -0.74   0.459    -.0929957    .0420161
        gdppc_growth |   .0080365   .0036383     2.21   0.027     .0009055    .0151675
                     |
c.fdi#c.composite_iq |   .0005754    .001543     0.37   0.709    -.0024488    .0035996
                     |
                  yr |
               2005  |   .0005112   .0210298     0.02   0.981    -.0407064    .0417288
               2006  |  -.0194034   .0208761    -0.93   0.353    -.0603197     .021513
               2007  |  -.0118492   .0207748    -0.57   0.568    -.0525671    .0288687
               2008  |  -.0129808   .0240387    -0.54   0.589    -.0600958    .0341343
               2009  |  -.0457786   .0419129    -1.09   0.275    -.1279265    .0363693
               2010  |    .048043   .0165436     2.90   0.004      .015618    .0804679
               2011  |  -.0010018   .0195281    -0.05   0.959    -.0392763    .0372727
               2012  |  -.0129744   .0223935    -0.58   0.562    -.0568648    .0309159
               2013  |     .01952   .0251066     0.78   0.437     -.029688    .0687281
               2014  |  -.0044969   .0184301    -0.24   0.807    -.0406192    .0316254
               2015  |   -.015879   .0177072    -0.90   0.370    -.0505845    .0188265
               2016  |  -.0089854   .0174683    -0.51   0.607    -.0432225    .0252518
               2017  |    .002552   .0181576     0.14   0.888    -.0330363    .0381402
               2018  |   .0099174   .0170966     0.58   0.562    -.0235914    .0434262
               2019  |  -.0132748    .020319    -0.65   0.514    -.0530994    .0265497
               2020  |   .0207655   .0415528     0.50   0.617    -.0606765    .1022075
               2022  |  -.0343715   .0191702    -1.79   0.073    -.0719444    .0032015
                     |
               _cons |    .164415   .1283751     1.28   0.200    -.0871956    .4160256
--------------------------------------------------------------------------------------
Instruments for first differences equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L4.L4.ln_tc_encons
Instruments for levels equation
  Standard
    L.fdi L.composite_iq L.ln_cpi L.gdppc_growth cL.fdi#c.composite_iq
    2004b.yr 2005.yr 2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr
    2013.yr 2014.yr 2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr
    2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL3.L4.ln_tc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.27  Pr > z =  0.001
Arellano-Bond test for AR(2) in first differences: z =  -0.54  Pr > z =  0.589
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(21)   =  84.03  Prob > chi2 =  0.000
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(21)   =  24.86  Prob > chi2 =  0.253
  (Robust, but weakened by many instruments.)


**2.2. total energy with voi_iq
xtabond2 L(0/1).ln_tc_encons fdi voi_iq ln_cpi gdppc_growth c.fdi#c.voi_iq i.yr, gmm(L4.ln_tc_encons, lag (4 4)) iv(L.fdi L.voi_iq L.ln_cpi L.gdppc_growth L.c.fdi#c.voi_iq i.yr, equation(level)) nodiffsargan twostep robust 
est sto tc_voiiq_sysgmm

Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       882
Time variable : yr                              Number of groups   =        49
Number of instruments = 45                      Obs per group: min =        18
Wald chi2(23) =  9.69e+06                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
  ln_tc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
  ln_tc_encons |
           L1. |   .9991437   .0191748    52.11   0.000     .9615618    1.036726
               |
           fdi |   .0003904   .0010303     0.38   0.705    -.0016289    .0024098
        voi_iq |  -.0138426   .0130955    -1.06   0.290    -.0395093    .0118241
        ln_cpi |  -.0490747   .0191261    -2.57   0.010    -.0865611   -.0115883
  gdppc_growth |   .0051267   .0034303     1.49   0.135    -.0015966    .0118499
               |
c.fdi#c.voi_iq |     .00035   .0012857     0.27   0.785    -.0021699    .0028699
               |
            yr |
         2005  |  -.0139831    .018148    -0.77   0.441    -.0495525    .0215864
         2006  |  -.0325641   .0178228    -1.83   0.068    -.0674961     .002368
         2007  |  -.0205339   .0185742    -1.11   0.269    -.0569388    .0158709
         2008  |  -.0289914   .0221908    -1.31   0.191    -.0724846    .0145017
         2009  |  -.0780169   .0377166    -2.07   0.039      -.15194   -.0040938
         2010  |   .0332875   .0160827     2.07   0.038      .001766    .0648091
         2011  |  -.0146059   .0190976    -0.76   0.444    -.0520365    .0228248
         2012  |  -.0285606   .0163854    -1.74   0.081    -.0606755    .0035542
         2013  |   .0040181   .0224705     0.18   0.858    -.0400233    .0480594
         2014  |  -.0183516   .0175449    -1.05   0.296    -.0527389    .0160357
         2015  |  -.0256947   .0169771    -1.51   0.130    -.0589692    .0075797
         2016  |   -.023685    .017378    -1.36   0.173    -.0577452    .0103752
         2017  |  -.0070537   .0147514    -0.48   0.633    -.0359659    .0218585
         2018  |   .0004331   .0167748     0.03   0.979     -.032445    .0333112
         2019  |  -.0231903   .0181516    -1.28   0.201    -.0587668    .0123862
         2020  |  -.0060299   .0375754    -0.16   0.873    -.0796764    .0676165
         2022  |  -.0316224   .0170509    -1.85   0.064    -.0650416    .0017968
               |
         _cons |   .2444194   .1025254     2.38   0.017     .0434734    .4453654
--------------------------------------------------------------------------------
Instruments for first differences equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L4.L4.ln_tc_encons
Instruments for levels equation
  Standard
    L.fdi L.voi_iq L.ln_cpi L.gdppc_growth cL.fdi#c.voi_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL3.L4.ln_tc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.23  Pr > z =  0.001
Arellano-Bond test for AR(2) in first differences: z =  -0.36  Pr > z =  0.719
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(21)   =  82.24  Prob > chi2 =  0.000
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(21)   =  24.53  Prob > chi2 =  0.268
  (Robust, but weakened by many instruments.)


**2.3. Total energy with pol_iq
xtabond2 L(0/1).ln_tc_encons fdi pol_iq ln_cpi gdppc_growth c.fdi#c.pol_iq i.yr, gmm(L4.ln_tc_encons, lag (4 4)) iv(L.fdi L.pol_iq L.ln_cpi gdppc_growth L.c.fdi#c.pol_iq i.yr, equation(level)) nodiffsargan twostep robust orthogonal 
est sto tc_poliq_sysgmm

Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       882
Time variable : yr                              Number of groups   =        49
Number of instruments = 45                      Obs per group: min =        18
Wald chi2(23) =  1.84e+06                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
  ln_tc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
  ln_tc_encons |
           L1. |   .9763125   .0316236    30.87   0.000     .9143313    1.038294
               |
           fdi |  -.0010282    .001716    -0.60   0.549    -.0043915    .0023351
        pol_iq |   .0108923   .0237647     0.46   0.647    -.0356856    .0574703
        ln_cpi |  -.0120714   .0236115    -0.51   0.609    -.0583491    .0342063
  gdppc_growth |   .0072937   .0020578     3.54   0.000     .0032605    .0113269
               |
c.fdi#c.pol_iq |    .000787   .0015102     0.52   0.602    -.0021729     .003747
               |
            yr |
         2005  |  -.0112812   .0223825    -0.50   0.614    -.0551501    .0325877
         2006  |   -.029225   .0246786    -1.18   0.236    -.0775941    .0191441
         2007  |  -.0209696   .0218994    -0.96   0.338    -.0638916    .0219524
         2008  |  -.0263762    .018797    -1.40   0.161    -.0632177    .0104653
         2009  |  -.0665744   .0167925    -3.96   0.000    -.0994872   -.0336617
         2010  |    .038468    .023701     1.62   0.105    -.0079852    .0849211
         2011  |  -.0126618   .0180858    -0.70   0.484    -.0481093    .0227858
         2012  |  -.0259278   .0193846    -1.34   0.181    -.0639209    .0120653
         2013  |   .0045527   .0188005     0.24   0.809    -.0322955     .041401
         2014  |  -.0207529   .0204142    -1.02   0.309    -.0607639    .0192581
         2015  |  -.0288593   .0163557    -1.76   0.078    -.0609159    .0031973
         2016  |  -.0206864   .0213303    -0.97   0.332     -.062493    .0211202
         2017  |  -.0103655   .0246225    -0.42   0.674    -.0586246    .0378936
         2018  |  -.0050423   .0192262    -0.26   0.793     -.042725    .0326405
         2019  |   -.027854   .0184738    -1.51   0.132     -.064062    .0083539
         2021  |  -.0098048   .0253348    -0.39   0.699      -.05946    .0398505
         2022  |  -.0580367    .020611    -2.82   0.005    -.0984335   -.0176398
               |
         _cons |   .1424607   .0906135     1.57   0.116    -.0351385      .32006
--------------------------------------------------------------------------------
Instruments for orthogonal deviations equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L4.L4.ln_tc_encons
Instruments for levels equation
  Standard
    L.fdi L.pol_iq L.ln_cpi gdppc_growth cL.fdi#c.pol_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL3.L4.ln_tc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.21  Pr > z =  0.001
Arellano-Bond test for AR(2) in first differences: z =  -0.51  Pr > z =  0.609
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(21)   =  83.73  Prob > chi2 =  0.000
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(21)   =  24.46  Prob > chi2 =  0.271
  (Robust, but weakened by many instruments.)


**2.4. Total energy with gov_iq
xtabond2 L(0/1).ln_tc_encons fdi gov_iq ln_cpi gdppc_growth c.fdi#c.gov_iq i.yr, gmm(L4.ln_tc_encons, lag (4 4)) iv(L.fdi gov_iq L.ln_cpi gdppc_growth L.c.fdi#c.gov_iq i.yr, equation(level)) nodiffsargan twostep robust orthogonal small
est sto tc_goviq_sysgmm

Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       882
Time variable : yr                              Number of groups   =        49
Number of instruments = 45                      Obs per group: min =        18
F(23, 48)     =  33231.50                                      avg =     18.00
Prob > F      =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
  ln_tc_encons | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
---------------+----------------------------------------------------------------
  ln_tc_encons |
           L1. |   .9674315   .0479299    20.18   0.000      .871062    1.063801
               |
           fdi |  -.0005712   .0009724    -0.59   0.560    -.0025263     .001384
        gov_iq |   .0178997   .0416702     0.43   0.669    -.0658838    .1016833
        ln_cpi |  -.0180839   .0385827    -0.47   0.641    -.0956596    .0594919
  gdppc_growth |   .0074134    .001939     3.82   0.000     .0035149     .011312
               |
c.fdi#c.gov_iq |   .0005031   .0009562     0.53   0.601    -.0014194    .0024256
               |
            yr |
         2005  |   -.014575   .0222357    -0.66   0.515    -.0592829    .0301328
         2006  |  -.0316722    .026987    -1.17   0.246    -.0859332    .0225888
         2007  |  -.0217956   .0248421    -0.88   0.385    -.0717439    .0281527
         2008  |   -.027101   .0209201    -1.30   0.201    -.0691638    .0149617
         2009  |  -.0694117   .0205335    -3.38   0.001    -.1106972   -.0281262
         2010  |   .0335415   .0217062     1.55   0.129    -.0101016    .0771847
         2011  |  -.0161194   .0195405    -0.82   0.413    -.0554082    .0231693
         2012  |  -.0288858   .0174691    -1.65   0.105    -.0640098    .0062382
         2013  |   .0056611   .0196784     0.29   0.775    -.0339048    .0452271
         2014  |  -.0213175   .0193275    -1.10   0.276    -.0601781     .017543
         2015  |  -.0325159   .0175439    -1.85   0.070    -.0677903    .0027585
         2016  |  -.0269192   .0182681    -1.47   0.147    -.0636498    .0098113
         2017  |  -.0160116   .0206263    -0.78   0.441    -.0574836    .0254603
         2018  |  -.0062107   .0173639    -0.36   0.722     -.041123    .0287017
         2019  |   -.029306   .0185349    -1.58   0.120    -.0665729    .0079608
         2021  |  -.0145746   .0228606    -0.64   0.527     -.060539    .0313899
         2022  |  -.0530429   .0237468    -2.23   0.030     -.100789   -.0052968
               |
         _cons |   .1911962   .1598168     1.20   0.237    -.1301371    .5125295
--------------------------------------------------------------------------------
Instruments for orthogonal deviations equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L4.L4.ln_tc_encons
Instruments for levels equation
  Standard
    L.fdi gov_iq L.ln_cpi gdppc_growth cL.fdi#c.gov_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL3.L4.ln_tc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.15  Pr > z =  0.002
Arellano-Bond test for AR(2) in first differences: z =  -0.53  Pr > z =  0.595
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(21)   =  84.29  Prob > chi2 =  0.000
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(21)   =  24.84  Prob > chi2 =  0.254
  (Robust, but weakened by many instruments.)

**2.4. Total energy with reg_iq
xtabond2 L(0/1).ln_tc_encons fdi reg_iq ln_cpi gdppc_growth c.fdi#c.reg_iq i.yr, gmm(L4.ln_tc_encons, lag (4 4)) iv(L.fdi reg_iq L.ln_cpi gdppc_growth L.c.fdi#c.reg_iq i.yr, equation(level)) nodiffsargan twostep robust 
est sto tc_regiq_sysgmm

Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       882
Time variable : yr                              Number of groups   =        49
Number of instruments = 45                      Obs per group: min =        18
Wald chi2(23) =  3.96e+06                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
  ln_tc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
  ln_tc_encons |
           L1. |   .9954492    .036047    27.62   0.000     .9247983      1.0661
               |
           fdi |  -.0000228    .002224    -0.01   0.992    -.0043817    .0043362
        reg_iq |  -.0080837   .0385806    -0.21   0.834    -.0837003    .0675328
        ln_cpi |  -.0342501   .0418279    -0.82   0.413    -.1162313     .047731
  gdppc_growth |   .0076762   .0018653     4.12   0.000     .0040201    .0113322
               |
c.fdi#c.reg_iq |   .0003875   .0023215     0.17   0.867    -.0041625    .0049375
               |
            yr |
         2005  |   .0065996    .014034     0.47   0.638    -.0209065    .0341056
         2006  |  -.0062301   .0148042    -0.42   0.674    -.0352458    .0227856
         2008  |  -.0003184   .0148303    -0.02   0.983    -.0293852    .0287484
         2009  |  -.0347749   .0302211    -1.15   0.250    -.0940073    .0244574
         2010  |    .061639   .0168711     3.65   0.000     .0285722    .0947058
         2011  |   .0098736   .0133841     0.74   0.461    -.0163588    .0361059
         2012  |  -.0011022   .0270952    -0.04   0.968    -.0542078    .0520033
         2013  |   .0306153    .020587     1.49   0.137    -.0097344     .070965
         2014  |   .0082584    .021364     0.39   0.699    -.0336143    .0501311
         2015  |  -.0020302   .0192292    -0.11   0.916    -.0397188    .0356584
         2016  |  -.0000818   .0191385    -0.00   0.997    -.0375925     .037429
         2017  |   .0157047   .0295617     0.53   0.595    -.0422352    .0736447
         2018  |   .0241173   .0252832     0.95   0.340    -.0254367    .0736714
         2019  |  -.0003447   .0308415    -0.01   0.991    -.0607929    .0601036
         2020  |    .030327   .0315995     0.96   0.337    -.0316069     .092261
         2021  |    .014979   .0265384     0.56   0.572    -.0370352    .0669933
         2022  |  -.0170308    .034754    -0.49   0.624    -.0851475    .0510858
               |
         _cons |    .156779   .1293255     1.21   0.225    -.0966943    .4102523
--------------------------------------------------------------------------------
Instruments for first differences equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L4.L4.ln_tc_encons
Instruments for levels equation
  Standard
    L.fdi reg_iq L.ln_cpi gdppc_growth cL.fdi#c.reg_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL3.L4.ln_tc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.14  Pr > z =  0.002
Arellano-Bond test for AR(2) in first differences: z =  -0.47  Pr > z =  0.638
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(21)   =  81.12  Prob > chi2 =  0.000
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(21)   =  24.70  Prob > chi2 =  0.260
  (Robust, but weakened by many instruments.)

**2.5. Total energy with rul_iq
xtabond2 L(0/1).ln_tc_encons fdi rul_iq ln_cpi gdppc_growth c.fdi#c.rul_iq i.yr, gmm(L4.ln_tc_encons, lag (4 4)) iv(L.fdi rul_iq L.ln_cpi gdppc_growth L.c.fdi#c.rul_iq i.yr, equation(level)) nodiffsargan twostep robust orthogonal 
est sto tc_ruliq_sysgmm

Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       882
Time variable : yr                              Number of groups   =        49
Number of instruments = 45                      Obs per group: min =        18
Wald chi2(23) =  1.45e+06                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
  ln_tc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
  ln_tc_encons |
           L1. |   .9899324   .0468492    21.13   0.000     .8981097    1.081755
               |
           fdi |  -.0006404   .0010459    -0.61   0.540    -.0026904    .0014095
        rul_iq |  -.0041761   .0350414    -0.12   0.905    -.0728561    .0645038
        ln_cpi |  -.0279182   .0326375    -0.86   0.392    -.0918865    .0360501
  gdppc_growth |    .007443   .0020114     3.70   0.000     .0035008    .0113852
               |
c.fdi#c.rul_iq |   .0006336   .0009351     0.68   0.498    -.0011991    .0024663
               |
            yr |
         2005  |  -.0164976   .0216873    -0.76   0.447    -.0590039    .0260087
         2006  |  -.0336767   .0258022    -1.31   0.192    -.0842481    .0168947
         2007  |  -.0279832   .0230007    -1.22   0.224    -.0730637    .0170973
         2008  |  -.0292628   .0198763    -1.47   0.141    -.0682197     .009694
         2009  |   -.066917   .0172543    -3.88   0.000    -.1007349   -.0330992
         2010  |   .0344229   .0228272     1.51   0.132    -.0103176    .0791634
         2011  |  -.0193951   .0189071    -1.03   0.305    -.0564524    .0176622
         2012  |  -.0263148   .0172963    -1.52   0.128    -.0602148    .0075853
         2013  |   .0039254   .0189706     0.21   0.836    -.0332564    .0411071
         2014  |  -.0206775   .0195381    -1.06   0.290    -.0589714    .0176165
         2015  |  -.0320989   .0180732    -1.78   0.076    -.0675217     .003324
         2016  |  -.0241737   .0187208    -1.29   0.197    -.0608658    .0125184
         2017  |  -.0121515   .0213531    -0.57   0.569    -.0540028    .0296998
         2018  |  -.0049437   .0179303    -0.28   0.783    -.0400863     .030199
         2019  |  -.0284248   .0176119    -1.61   0.107    -.0629435    .0060938
         2021  |  -.0132198   .0240369    -0.55   0.582    -.0603312    .0338917
         2022  |  -.0487722   .0244361    -2.00   0.046    -.0966661   -.0008783
               |
         _cons |    .176012   .1368778     1.29   0.198    -.0922635    .4442876
--------------------------------------------------------------------------------
Instruments for orthogonal deviations equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L4.L4.ln_tc_encons
Instruments for levels equation
  Standard
    L.fdi rul_iq L.ln_cpi gdppc_growth cL.fdi#c.rul_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL3.L4.ln_tc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.30  Pr > z =  0.001
Arellano-Bond test for AR(2) in first differences: z =  -0.52  Pr > z =  0.604
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(21)   =  84.69  Prob > chi2 =  0.000
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(21)   =  21.77  Prob > chi2 =  0.413
  (Robust, but weakened by many instruments.)


**2.6. Total energy with con_iq
xtabond2 L(0/1).ln_tc_encons fdi con_iq ln_cpi gdppc_growth c.fdi#c.con_iq i.yr, gmm(L4.ln_tc_encons, lag (4 4)) iv(L.fdi con_iq ln_cpi L.gdppc_growth L.c.fdi#c.con_iq i.yr, equation(level)) nodiffsargan twostep robust
 est sto tc_coniq_sysgmm

Dynamic panel-data estimation, two-step system GMM
------------------------------------------------------------------------------
Group variable: country_id                      Number of obs      =       882
Time variable : yr                              Number of groups   =        49
Number of instruments = 45                      Obs per group: min =        18
Wald chi2(23) =  2.52e+06                                      avg =     18.00
Prob > chi2   =     0.000                                      max =        18
--------------------------------------------------------------------------------
               |              Corrected
  ln_tc_encons | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
---------------+----------------------------------------------------------------
  ln_tc_encons |
           L1. |   .9978171   .0322212    30.97   0.000     .9346647     1.06097
               |
           fdi |  -.0008305   .0011443    -0.73   0.468    -.0030733    .0014123
        con_iq |  -.0097208   .0228544    -0.43   0.671    -.0545146    .0350731
        ln_cpi |   -.039033   .0359941    -1.08   0.278    -.1095803    .0315142
  gdppc_growth |   .0068942   .0030505     2.26   0.024     .0009153     .012873
               |
c.fdi#c.con_iq |   .0007768   .0011226     0.69   0.489    -.0014235     .002977
               |
            yr |
         2005  |   .0119207   .0140952     0.85   0.398    -.0157055    .0395468
         2006  |  -.0088086   .0138123    -0.64   0.524    -.0358802    .0182629
         2008  |  -.0022143    .013196    -0.17   0.867    -.0280781    .0236495
         2009  |  -.0441262   .0238735    -1.85   0.065    -.0909173     .002665
         2010  |    .058911    .014241     4.14   0.000     .0309992    .0868228
         2011  |   .0085561   .0125729     0.68   0.496    -.0160862    .0331985
         2012  |  -.0029226   .0182627    -0.16   0.873    -.0387169    .0328717
         2013  |    .030956   .0162875     1.90   0.057    -.0009669    .0628789
         2014  |   .0057196   .0154589     0.37   0.711    -.0245794    .0360185
         2015  |  -.0048161    .015629    -0.31   0.758    -.0354485    .0258162
         2016  |   .0010945   .0156152     0.07   0.944    -.0295108    .0316997
         2017  |   .0150663   .0245762     0.61   0.540    -.0331021    .0632348
         2018  |   .0212016   .0226212     0.94   0.349    -.0231351    .0655383
         2019  |  -.0002436   .0191249    -0.01   0.990    -.0377277    .0372405
         2020  |   .0272037   .0213481     1.27   0.203    -.0146378    .0690453
         2021  |    .016396    .030515     0.54   0.591    -.0434123    .0762042
         2022  |  -.0173243   .0276693    -0.63   0.531    -.0715551    .0369065
               |
         _cons |   .1750629   .1412394     1.24   0.215    -.1017612    .4518869
--------------------------------------------------------------------------------
Instruments for first differences equation
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    L4.L4.ln_tc_encons
Instruments for levels equation
  Standard
    L.fdi con_iq ln_cpi L.gdppc_growth cL.fdi#c.con_iq 2004b.yr 2005.yr
    2006.yr 2007.yr 2008.yr 2009.yr 2010.yr 2011.yr 2012.yr 2013.yr 2014.yr
    2015.yr 2016.yr 2017.yr 2018.yr 2019.yr 2020.yr 2021.yr 2022.yr
    _cons
  GMM-type (missing=0, separate instruments for each period unless collapsed)
    DL3.L4.ln_tc_encons
------------------------------------------------------------------------------
Arellano-Bond test for AR(1) in first differences: z =  -3.25  Pr > z =  0.001
Arellano-Bond test for AR(2) in first differences: z =  -0.50  Pr > z =  0.615
------------------------------------------------------------------------------
Sargan test of overid. restrictions: chi2(21)   =  83.70  Prob > chi2 =  0.000
  (Not robust, but not weakened by many instruments.)
Hansen test of overid. restrictions: chi2(21)   =  23.10  Prob > chi2 =  0.339
  (Robust, but weakened by many instruments.)
