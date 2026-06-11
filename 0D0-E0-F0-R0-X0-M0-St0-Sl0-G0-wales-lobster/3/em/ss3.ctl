#C control file for lobster (wales)
#C file created using an r4ss function
#C file write time: 2026-06-11  17:24:28
#
0 # 0 means do not read wtatage.ss; 1 means read and usewtatage.ss and also read and use growth parameters
1 #_N_Growth_Patterns
1 #_N_platoons_Within_GrowthPattern
4 # recr_dist_method for parameters
1 # not yet implemented; Future usage:Spawner-Recruitment; 1=global; 2=by area
1 # number of recruitment settlement assignments 
0 # unused option
# for each settlement assignment:
#_GPattern	month	area	age
1	7.5	1	0	#_recr_dist_pattern1
#
#_Cond 0 # N_movement_definitions goes here if N_areas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
2 #_Nblock_Patterns
1 2 #_blocks_per_pattern
#_begin and end years of blocks
1983 1992
1993 1996 1997 2034
#
# controls for all timevary parameters 
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
#
# AUTOGEN
1 1 1 1 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
#
# setup for M, growth, maturity, fecundity, recruitment distibution, movement
#
0 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate;_5=Maunder_M;_6=Age-range_Lorenzen
#_no additional input for selected M option; read 1P per morph
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K_incr; 4=age_specific_K_decr;5=age_specific_K_each; 6=NA; 7=NA; 8=growth cessation
1 #_Age(post-settlement)_for_L1;linear growth below this
999 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (value should approx initial Z; -999 replicates 3.24; -998 to not allow growth above maxage)
0 #_placeholder for future growth feature
#
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
1 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
3 #_First_Mature_Age
2 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#
#_growth_parms
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env_var&link	dev_link	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
 0.05	     2.4	    0.211	      0.4	 99	0	 -1	0	0	0	0	0	0	0	#_NatM_p_1_Fem_GP_1  
    1	       5	  2.22681	        2	 99	0	 -3	0	0	0	0	0	0	0	#_L_at_Amin_Fem_GP_1 
    5	      70	  21.5073	    21.23	 99	0	 -3	0	0	0	0	0	0	0	#_L_at_Amax_Fem_GP_1 
 0.01	       2	 0.219148	      0.2	 99	0	 -3	0	0	0	0	0	0	0	#_VonBert_K_Fem_GP_1 
 0.01	     0.4	 0.171767	     0.17	 99	0	 -3	0	0	0	0	0	0	0	#_CV_young_Fem_GP_1  
 0.01	     0.9	 0.152284	     0.15	 99	0	 -3	0	0	0	0	0	0	0	#_CV_old_Fem_GP_1    
   -3	       3	0.0005579	0.0005579	 99	0	-99	0	0	0	0	0	0	0	#_Wtlen_1_Fem_GP_1   
   -3	       4	   3.1075	   3.1075	 99	0	-99	0	0	0	0	0	0	0	#_Wtlen_2_Fem_GP_1   
    1	      15	  9.06393	        9	 99	0	-99	0	0	0	0	0	0	0	#_Mat50%_Fem_GP_1    
   -3	       0	 -1.50611	     -1.5	 99	0	-99	0	0	0	0	0	0	0	#_Mat_slope_Fem_GP_1 
   -3	      10	        1	        1	 99	0	-99	0	0	0	0	0	0	0	#_Eggs_alpha_Fem_GP_1
   -3	      10	        0	        0	 99	0	-99	0	0	0	0	0	0	0	#_Eggs_beta_Fem_GP_1 
 0.05	     2.4	    0.211	      0.4	 99	0	 -1	0	0	0	0	0	0	0	#_NatM_p_1_Mal_GP_1  
    1	       5	  2.23191	        2	 99	0	 -3	0	0	0	0	0	0	0	#_L_at_Amin_Mal_GP_1 
    5	      70	    20.63	    20.63	 99	0	 -3	0	0	0	0	0	0	0	#_L_at_Amax_Mal_GP_1 
 0.05	       2	 0.213052	     0.21	 99	0	 -3	0	0	0	0	0	0	0	#_VonBert_K_Mal_GP_1 
 0.01	     0.4	 0.190302	     0.18	 99	0	 -3	0	0	0	0	0	0	0	#_CV_young_Mal_GP_1  
 0.01	     0.9	 0.131648	     0.13	 99	0	 -3	0	0	0	0	0	0	0	#_CV_old_Mal_GP_1    
   -3	       2	0.0005579	0.0005579	 99	0	-99	0	0	0	0	0	0	0	#_Wtlen_1_Mal_GP_1   
   -3	       5	   3.1075	   3.1075	 99	0	-99	0	0	0	0	0	0	0	#_Wtlen_2_Mal_GP_1   
  0.1	      10	        1	        1	  1	0	 -1	0	0	0	0	0	0	0	#_CohortGrowDev      
1e-06	0.999999	      0.5	      0.5	0.5	0	-99	0	0	0	0	0	0	0	#_FracFemale_GP_1    
#_no timevary MG parameters
#
#_seasonal_effects_on_biology_parms
0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
3 #_Spawner-Recruitment; 2=Ricker (2 parms); 3=std_B-H(2); 4=SCAA(2);5=Hockey(3); 6=B-H_flattop(2); 7=Survival(3);8=Shepard(3);9=Ricker_Power(3);10=B-H_a,b(4)
0 # 0/1 to use steepness in initial equ recruitment calculation
0 # future feature: 0/1 to make realized sigmaR a function of SR curvature
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn # parm_name
  1	14	 6.82672	  6.9	 5	3	 1	0	0	0	0	0	0	0	#_SR_LN(R0)  
0.2	 1	0.864082	  0.9	 3	1	 5	0	0	0	0	0	0	0	#_SR_BH_steep
  0	 8	0.473583	  0.4	99	0	-2	0	0	0	0	0	0	0	#_SR_sigmaR  
 -5	 5	       0	    0	99	0	-1	0	0	0	0	0	0	0	#_SR_regime  
  0	 1	       0	0.456	99	0	-2	0	0	0	0	0	0	0	#_SR_autocorr
#_no timevary SR parameters
3 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
1983 # first year of main recr_devs; early devs can preceed this era
2074 # last year of main recr_devs; forecast devs start in following year
3 #_recdev phase
1 # (0/1) to read 13 advanced options
1938 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
4 #_recdev_early_phase
-1 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
1 #_lambda for Fcast_recr_like occurring before endyr+1
1980 #_last_yr_nobias_adj_in_MPD; begin of ramp
1981 #_first_yr_fullbias_adj_in_MPD; begin of plateau
2069 #_last_yr_fullbias_adj_in_MPD
2073 #_end_yr_for_ramp_in_MPD (can be in forecast to shape ramp, but SS sets bias_adj to 0.0 for fcast yrs)
0.9 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
0 #_period of cycles in recruitment (N parms read below)
-10 #min rec_dev
10 #max rec_dev
0 #_read_recdevs
#_end of advanced SR options
#
#_placeholder for full parameter lines for recruitment cycles
# read specified recr devs
#_Yr Input_value
#
#Fishing Mortality info
0.4 # F ballpark
-2008 # F ballpark year (neg value to disable)
3 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
9 # max F or harvest rate, depends on F_Method
4 # N iterations for tuning F in hybrid method (recommend 3 to 7)
#
#_initial_F_parms
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE
0	5	0.186353	0.5	1	1	1	#_InitF_seas_1_flt_2Pot_fisheries_historical
#
#_Q_setup for fleets with cpue or survey data
#_fleet	link	link_info	extra_se	biasadj	float  #  fleetname
    1	1	0	1	1	1	#_Observer_inshore_u10   
    3	1	0	1	1	1	#_Pot_fisheries_u10      
    4	1	0	1	1	1	#_Pot_fisheries_10to12   
    5	1	0	1	1	1	#_Pot_fisheries_o12      
    8	1	0	1	1	1	#_Bycatch_fisheries_trawl
    9	1	0	1	1	1	#_Observer_prerecruit_u10
-9999	0	0	0	0	0	#_terminator             
#_Q_parms(if_any);Qunits_are_ln(q)
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
  -50	 50	  -10.6122	 -1	1	1	-1	0	0	0	0	0	0	0	#_LnQ_base_Observer_inshore_u10(1)    
1e-06	0.2	 0.0337811	0.1	3	3	 3	0	0	0	0	0	0	0	#_Q_extraSD_Observer_inshore_u10(1)   
  -50	 50	  -7.40822	 -5	1	1	-1	0	0	0	0	0	0	0	#_LnQ_base_Pot_fisheries_u10(3)       
1e-06	0.1	0.00490586	0.1	3	3	 3	0	0	0	0	0	0	0	#_Q_extraSD_Pot_fisheries_u10(3)      
  -50	 50	  -8.71474	 -3	1	1	-1	0	0	0	0	0	0	0	#_LnQ_base_Pot_fisheries_10to12(4)    
1e-06	0.4	  0.160899	0.1	3	3	 3	0	0	0	0	0	0	0	#_Q_extraSD_Pot_fisheries_10to12(4)   
  -50	 50	   -8.9283	 -3	1	1	-1	0	0	0	0	0	0	0	#_LnQ_base_Pot_fisheries_o12(5)       
1e-06	0.4	  0.159433	0.1	3	3	 3	0	0	0	0	0	0	0	#_Q_extraSD_Pot_fisheries_o12(5)      
  -50	 99	  -10.8047	  4	1	1	-1	0	0	0	0	0	0	0	#_LnQ_base_Bycatch_fisheries_trawl(8) 
1e-06	0.2	 0.0428628	0.1	3	3	 3	0	0	0	0	0	0	0	#_Q_extraSD_Bycatch_fisheries_trawl(8)
  -50	 99	  -6.35643	 10	1	1	-1	0	0	0	0	0	0	0	#_LnQ_base_Observer_prerecruit_u10(9) 
1e-06	0.5	 0.0535688	0.1	3	3	 3	0	0	0	0	0	0	0	#_Q_extraSD_Observer_prerecruit_u10(9)
#_no timevary Q parameters
#
#_size_selex_patterns
#_Pattern	Discard	Male	Special
24	2	4	0	#_1 Observer_inshore_u10        
24	2	4	0	#_2 Pot_fisheries_historical    
24	2	4	0	#_3 Pot_fisheries_u10           
15	0	0	3	#_4 Pot_fisheries_10to12        
15	0	0	2	#_5 Pot_fisheries_o12           
23	0	0	0	#_6 Bycatch_fisheries_historical
15	0	0	6	#_7 Bycatch_fisheries_gillnet   
15	0	0	6	#_8 Bycatch_fisheries_trawl     
15	0	0	1	#_9 Observer_prerecruit_u10     
#
#_age_selex_patterns
#_Pattern	Discard	Male	Special
0	0	0	0	#_1 Observer_inshore_u10        
0	0	0	1	#_2 Pot_fisheries_historical    
0	0	0	1	#_3 Pot_fisheries_u10           
0	0	0	1	#_4 Pot_fisheries_10to12        
0	0	0	1	#_5 Pot_fisheries_o12           
0	0	0	1	#_6 Bycatch_fisheries_historical
0	0	0	1	#_7 Bycatch_fisheries_gillnet   
0	0	0	1	#_8 Bycatch_fisheries_trawl     
0	0	0	1	#_9 Observer_prerecruit_u10     
#
#_SizeSelex
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
    5	 22	     8.96991	 9.6	 99	6	  1	0	0	0	0	0	0	0	#_SizeSel_P_1_Observer_inshore_u10(1)          
  -50	  9	    -11.8256	  -8	 99	6	  3	0	0	0	0	0	0	0	#_SizeSel_P_2_Observer_inshore_u10(1)          
   -9	  9	     0.81311	 1.2	 99	6	  3	0	0	0	0	0	0	0	#_SizeSel_P_3_Observer_inshore_u10(1)          
   -9	  9	     1.99332	 1.6	 99	6	  3	0	0	0	0	0	0	0	#_SizeSel_P_4_Observer_inshore_u10(1)          
  -35	 50	        -999	 -12	 99	6	-99	0	0	0	0	0	0	0	#_SizeSel_P_5_Observer_inshore_u10(1)          
  -90	 30	    -8.75015	 -13	 99	6	  3	0	0	0	0	0	0	0	#_SizeSel_P_6_Observer_inshore_u10(1)          
    8	  9	         8.5	 8.5	  1	1	  2	0	0	0	0	0	2	2	#_SizeSel_PRet_1_Observer_inshore_u10(1)       
1e-06	500	         250	   5	  1	1	  2	0	0	0	0	0	2	2	#_SizeSel_PRet_2_Observer_inshore_u10(1)       
  -50	500	     5.15788	   5	 99	6	  3	0	0	0	0	0	2	2	#_SizeSel_PRet_3_Observer_inshore_u10(1)       
  -50	500	    0.275333	 0.1	 99	6	  3	0	0	0	0	0	2	2	#_SizeSel_PRet_4_Observer_inshore_u10(1)       
    0	 15	    0.620556	 0.5	 99	0	 -4	0	0	0	0	0	0	0	#_SizeSel_PDis_1_Observer_inshore_u10(1)       
    0	 10	   0.0827097	   5	 99	0	 -4	0	0	0	0	0	0	0	#_SizeSel_PDis_2_Observer_inshore_u10(1)       
    0	  1	  0.00050554	 0.1	 99	0	 -5	0	0	0	0	0	0	0	#_SizeSel_PDis_3_Observer_inshore_u10(1)       
  -50	 50	     1.00916	   1	 99	0	 -5	0	0	0	0	0	0	0	#_SizeSel_PDis_4_Observer_inshore_u10(1)       
  -20	 20	   0.0072385	  -2	0.1	1	  4	0	0	0	0	0	0	0	#_SizeSel_PFemOff_1_Observer_inshore_u10(1)    
  -20	 20	   -0.105646	  -1	0.1	1	  4	0	0	0	0	0	0	0	#_SizeSel_PFemOff_2_Observer_inshore_u10(1)    
  -20	 20	   -0.655818	   0	0.1	1	  4	0	0	0	0	0	0	0	#_SizeSel_PFemOff_3_Observer_inshore_u10(1)    
  -20	 20	     2.18501	   0	0.1	1	  4	0	0	0	0	0	0	0	#_SizeSel_PFemOff_4_Observer_inshore_u10(1)    
    0	  1	    0.965153	 0.5	0.1	1	  4	0	0	0	0	0	0	0	#_SizeSel_PFemOff_5_Observer_inshore_u10(1)    
    2	 22	     6.28556	 7.5	  1	1	  1	0	0	0	0	0	0	0	#_SizeSel_P_1_Pot_fisheries_historical(2)      
  -60	 10	         -25	 -25	  1	1	  3	0	0	0	0	0	0	0	#_SizeSel_P_2_Pot_fisheries_historical(2)      
  -30	  9	     1.92377	 2.5	  1	1	  3	0	0	0	0	0	0	0	#_SizeSel_P_3_Pot_fisheries_historical(2)      
   -1	  9	     2.91152	   2	 99	6	  3	0	0	0	0	0	0	0	#_SizeSel_P_4_Pot_fisheries_historical(2)      
  -35	 50	        -999	  -5	 99	6	-99	0	0	0	0	0	0	0	#_SizeSel_P_5_Pot_fisheries_historical(2)      
  -90	 50	     -20.007	 -13	  1	1	  3	0	0	0	0	0	0	0	#_SizeSel_P_6_Pot_fisheries_historical(2)      
  8.2	  9	     8.31479	 8.5	  1	1	  2	0	0	0	0	0	2	2	#_SizeSel_PRet_1_Pot_fisheries_historical(2)   
    0	  1	    0.109177	 0.5	  1	1	  2	0	0	0	0	0	2	2	#_SizeSel_PRet_2_Pot_fisheries_historical(2)   
  -10	 10	     1.76562	   1	  1	1	  3	0	0	0	0	0	2	2	#_SizeSel_PRet_3_Pot_fisheries_historical(2)   
  -10	 10	   0.0467574	   1	 99	6	  3	0	0	0	0	0	2	2	#_SizeSel_PRet_4_Pot_fisheries_historical(2)   
    0	 15	    0.620556	   3	 99	0	 -4	0	0	0	0	0	0	0	#_SizeSel_PDis_1_Pot_fisheries_historical(2)   
    0	 10	   0.0827097	   5	 99	0	 -4	0	0	0	0	0	0	0	#_SizeSel_PDis_2_Pot_fisheries_historical(2)   
    0	  1	  0.00050554	0.01	 99	0	 -5	0	0	0	0	0	0	0	#_SizeSel_PDis_3_Pot_fisheries_historical(2)   
  -10	 10	     1.00916	   1	 99	0	 -5	0	0	0	0	0	0	0	#_SizeSel_PDis_4_Pot_fisheries_historical(2)   
  -20	 20	     1.34912	  -2	0.1	1	  4	0	0	0	0	0	0	0	#_SizeSel_PFemOff_1_Pot_fisheries_historical(2)
  -20	 20	     1.12483	  -1	0.1	1	  4	0	0	0	0	0	0	0	#_SizeSel_PFemOff_2_Pot_fisheries_historical(2)
  -20	 20	   -0.218847	   0	0.1	1	  4	0	0	0	0	0	0	0	#_SizeSel_PFemOff_3_Pot_fisheries_historical(2)
  -20	 20	 -0.00217568	   0	0.1	1	  4	0	0	0	0	0	0	0	#_SizeSel_PFemOff_4_Pot_fisheries_historical(2)
    0	  1	    0.990013	 0.5	0.1	1	  4	0	0	0	0	0	0	0	#_SizeSel_PFemOff_5_Pot_fisheries_historical(2)
    3	 22	     6.46157	 7.5	  1	3	  1	0	0	0	0	0	0	0	#_SizeSel_P_1_Pot_fisheries_u10(3)             
  -20	 10	    -1.63616	-1.3	  1	1	  3	0	0	0	0	0	0	0	#_SizeSel_P_2_Pot_fisheries_u10(3)             
  -90	 10	         -40	  -5	  1	1	  3	0	0	0	0	0	0	0	#_SizeSel_P_3_Pot_fisheries_u10(3)             
   -5	  9	     1.81019	   2	 99	6	  3	0	0	0	0	0	0	0	#_SizeSel_P_4_Pot_fisheries_u10(3)             
  -35	  9	        -999	 -11	 99	6	-99	0	0	0	0	0	0	0	#_SizeSel_P_5_Pot_fisheries_u10(3)             
  -30	  9	     -11.439	 -13	  1	1	  3	0	0	0	0	0	0	0	#_SizeSel_P_6_Pot_fisheries_u10(3)             
  8.2	  9	         8.6	 8.5	  1	1	  2	0	0	0	0	0	2	2	#_SizeSel_PRet_1_Pot_fisheries_u10(3)          
    0	900	         450	   5	  1	1	  2	0	0	0	0	0	2	2	#_SizeSel_PRet_2_Pot_fisheries_u10(3)          
  -90	900	     5.09212	   5	 99	6	  3	0	0	0	0	0	2	2	#_SizeSel_PRet_3_Pot_fisheries_u10(3)          
  -90	500	    0.189062	 0.1	 99	6	  3	0	0	0	0	0	2	2	#_SizeSel_PRet_4_Pot_fisheries_u10(3)          
    0	 15	    0.620556	   3	 99	0	 -4	0	0	0	0	0	0	0	#_SizeSel_PDis_1_Pot_fisheries_u10(3)          
    0	 10	   0.0827097	   0	 99	0	 -4	0	0	0	0	0	0	0	#_SizeSel_PDis_2_Pot_fisheries_u10(3)          
    0	  1	  0.00050554	0.01	 99	0	 -5	0	0	0	0	0	0	0	#_SizeSel_PDis_3_Pot_fisheries_u10(3)          
  -50	 50	     1.00916	   1	 99	0	 -5	0	0	0	0	0	0	0	#_SizeSel_PDis_4_Pot_fisheries_u10(3)          
  -20	 20	      -0.224	  -2	0.1	1	  4	0	0	0	0	0	0	0	#_SizeSel_PFemOff_1_Pot_fisheries_u10(3)       
  -20	 20	-3.53764e-08	  -1	0.1	1	  4	0	0	0	0	0	0	0	#_SizeSel_PFemOff_2_Pot_fisheries_u10(3)       
  -20	 20	    0.212946	   0	0.1	1	  4	0	0	0	0	0	0	0	#_SizeSel_PFemOff_3_Pot_fisheries_u10(3)       
  -20	 20	    -1.56453	   0	0.1	1	  4	0	0	0	0	0	0	0	#_SizeSel_PFemOff_4_Pot_fisheries_u10(3)       
    0	  1	    0.977796	 0.5	0.1	1	  4	0	0	0	0	0	0	0	#_SizeSel_PFemOff_5_Pot_fisheries_u10(3)       
    2	 22	           8	   8	 99	0	-99	0	0	0	0	0	0	0	#_SizeSel_P_1_Bycatch_fisheries_historical(6)  
  -10	 10	           1	   0	 99	0	-99	0	0	0	0	0	0	0	#_SizeSel_P_2_Bycatch_fisheries_historical(6)  
  -10	 10	           0	   0	 99	0	-99	0	0	0	0	0	0	0	#_SizeSel_P_3_Bycatch_fisheries_historical(6)  
  -10	 10	           0	   0	 99	0	-99	0	0	0	0	0	0	0	#_SizeSel_P_4_Bycatch_fisheries_historical(6)  
  -10	 10	        -999	   0	 99	0	-99	0	0	0	0	0	0	0	#_SizeSel_P_5_Bycatch_fisheries_historical(6)  
  -10	 10	           1	   0	 99	0	-99	0	0	0	0	0	0	0	#_SizeSel_P_6_Bycatch_fisheries_historical(6)  
#_AgeSelex
#_No age_selex_parm
# timevary selex parameters 
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE
  8.5	  9	      8.75	 8.7	1	1	2	#_SizeSel_PRet_1_Observer_inshore_u10(1)_BLK2repl_1993    
  8.7	9.2	   8.84659	   9	1	1	2	#_SizeSel_PRet_1_Observer_inshore_u10(1)_BLK2repl_1997    
1e-06	900	       450	  10	1	1	2	#_SizeSel_PRet_2_Observer_inshore_u10(1)_BLK2repl_1993    
    0	  2	  0.113857	 0.1	1	1	2	#_SizeSel_PRet_2_Observer_inshore_u10(1)_BLK2repl_1997    
  -10	900	       445	  10	1	1	3	#_SizeSel_PRet_3_Observer_inshore_u10(1)_BLK2repl_1993    
  -10	 10	   1.21478	   1	1	1	3	#_SizeSel_PRet_3_Observer_inshore_u10(1)_BLK2repl_1997    
  -10	900	       445	  10	1	1	3	#_SizeSel_PRet_4_Observer_inshore_u10(1)_BLK2repl_1993    
  -10	 10	  0.031412	0.05	1	1	3	#_SizeSel_PRet_4_Observer_inshore_u10(1)_BLK2repl_1997    
  8.5	  9	   8.59601	 8.7	1	1	2	#_SizeSel_PRet_1_Pot_fisheries_historical(2)_BLK2repl_1993
  8.7	9.3	   8.76866	   9	1	1	2	#_SizeSel_PRet_1_Pot_fisheries_historical(2)_BLK2repl_1997
    0	  2	  0.100062	   1	1	1	2	#_SizeSel_PRet_2_Pot_fisheries_historical(2)_BLK2repl_1993
    0	  1	  0.138904	   1	1	1	2	#_SizeSel_PRet_2_Pot_fisheries_historical(2)_BLK2repl_1997
  -10	 10	   2.09235	   1	1	1	3	#_SizeSel_PRet_3_Pot_fisheries_historical(2)_BLK2repl_1993
  -10	 10	   2.71124	   1	1	1	3	#_SizeSel_PRet_3_Pot_fisheries_historical(2)_BLK2repl_1997
  -10	 10	 0.0155982	   0	1	1	3	#_SizeSel_PRet_4_Pot_fisheries_historical(2)_BLK2repl_1993
  -10	 10	 0.0232465	   0	1	1	3	#_SizeSel_PRet_4_Pot_fisheries_historical(2)_BLK2repl_1997
  8.5	  9	      8.75	 8.7	1	1	2	#_SizeSel_PRet_1_Pot_fisheries_u10(3)_BLK2repl_1993       
  8.7	9.3	   8.79854	   9	1	1	2	#_SizeSel_PRet_1_Pot_fisheries_u10(3)_BLK2repl_1997       
1e-06	900	       450	  10	1	1	2	#_SizeSel_PRet_2_Pot_fisheries_u10(3)_BLK2repl_1993       
    0	  1	 0.0946603	 0.3	1	1	2	#_SizeSel_PRet_2_Pot_fisheries_u10(3)_BLK2repl_1997       
  -10	900	       445	   5	1	1	3	#_SizeSel_PRet_3_Pot_fisheries_u10(3)_BLK2repl_1993       
  -10	 10	   3.10588	   2	1	1	3	#_SizeSel_PRet_3_Pot_fisheries_u10(3)_BLK2repl_1997       
  -10	900	       445	  10	1	1	3	#_SizeSel_PRet_4_Pot_fisheries_u10(3)_BLK2repl_1993       
  -10	 10	-0.0384866	   0	1	1	3	#_SizeSel_PRet_4_Pot_fisheries_u10(3)_BLK2repl_1997       
# info on dev vectors created for selex parms are reported with other devs after tag parameter section
#
0 #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
# Tag loss and Tag reporting parameters go next
0 # TG_custom:  0=no read; 1=read if tags exist
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
# Input variance adjustments factors: 
#_factor	fleet	value
    1	1	0	#_Variance_adjustment_list1 
    4	1	1	#_Variance_adjustment_list2 
    1	2	0	#_Variance_adjustment_list3 
    4	2	1	#_Variance_adjustment_list4 
    1	3	0	#_Variance_adjustment_list5 
    4	3	1	#_Variance_adjustment_list6 
    1	4	0	#_Variance_adjustment_list7 
    1	5	0	#_Variance_adjustment_list8 
    1	7	0	#_Variance_adjustment_list9 
    1	8	0	#_Variance_adjustment_list10
-9999	0	0	#_terminator                
#
4 #_maxlambdaphase
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 7 changes to default Lambdas (default value is 1.0)
#_like_comp	fleet	phase	value	sizefreq_method
    1	1	2	1	1	#_Surv_Observer_inshore_u10_Phz2                        
    1	4	2	1	1	#_Surv_Pot_fisheries_10to12_Phz2                        
    4	1	2	1	1	#_length_Observer_inshore_u10_sizefreq_method_1_Phz2    
    8	2	2	1	1	#_catch_Pot_fisheries_historical_Phz2                   
    4	2	2	1	1	#_length_Pot_fisheries_historical_sizefreq_method_1_Phz2
    8	3	2	1	1	#_catch_Pot_fisheries_u10_Phz2                          
    4	3	2	1	1	#_length_Pot_fisheries_u10_sizefreq_method_1_Phz2       
-9999	0	0	0	0	#_terminator                                            
#
0 # 0/1 read specs for more stddev reporting
#
999
