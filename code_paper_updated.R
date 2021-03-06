---
  title: "analysis_1"
author: "vaishali"
date: "October 31, 2018"
output: word_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Analysis 1

```{r}
library(haven);library(survey);library(tidyverse);library(tableone)
```

Get the dataframes loaded into the document.

```{r get df for each year seperately}
df07 <- read_csv("E:/bita_nis/df/m2007.csv")
df08 <- read_csv("E:/bita_nis/df/m2008.csv")
df09 <- read_csv("E:/bita_nis/df/m2009.csv")
df10 <- read_csv("E:/bita_nis/df/m2010.csv")
df12 <- read_csv("E:/bita_nis/df/m2012.csv")
df11 <- read_csv("E:/bita_nis/df/m2011.csv")
df13 <- read_csv("E:/bita_nis/df/m2013.csv")
df14 <- read_csv("E:/bita_nis/df/m2014.csv")
df15.1 <- read_csv("E:/bita_nis/df/m2015_1.csv")


# keep hosp_locteach as that is a more accurate variable of teaching status. The hosp_teach variable is not included in the df after 2011. hosp_locteach is available from 1998 - 2016; so we should use hosp_locteach



df12$hospid <- df12$hosp_nis
df12$key <- df12$key_nis

df12$trendwt <- df12$discwt.x

df13$hospid <- df13$hosp_nis
df13$key <- df13$key_nis

df13$trendwt <- df13$discwt.x

df14$hospid <- df14$hosp_nis
df14$key <- df14$key_nis

df14$trendwt <- df14$discwt.x

df15.1$hospid <- df15.1$hosp_nis
df15.1$key <- df15.1$key_nis

df15.1$trendwt <- df15.1$discwt.x

# load the 15_4 quarter df here

df15.4 <- read_csv("E:/bita_nis/df/m2015_4.csv")

```

Am going to rbind columns according to need to do the survey analysis. 
Set lonely.psu = certainty to keep 1 PSU units

```{r set lonely psu to average}
options("survey.lonely.psu" = 'average')
```


```{r}
names(df07)
```


```{r}

b07 <- df07 %>% select(age, bita, died, year.x, dispuniform, female, key, los, nis_stratum.x, trendwt, valve, priormi, priorpci, chf,  stemi, hospid, hosp_region, hosp_locteach, hosp_bedsize, race,cm_dm, cm_dmcx, cm_obese, cm_renlfail, pay1,dx1:dx10, pr1:pr10,discwt.x, cm_liver)

b08 <- df08 %>% select(age, bita, died, year.x, dispuniform, female, key, los, nis_stratum.x, trendwt, valve, priormi, priorpci, chf,  stemi, hospid, hosp_region, hosp_locteach, hosp_bedsize, race,cm_dm, cm_dmcx, cm_obese, cm_renlfail, pay1,dx1:dx10, pr1:pr10,discwt.x, cm_liver)

b09 <- df09 %>% select(age, bita, died, year.x, dispuniform, female, key, los, nis_stratum.x, trendwt, valve, priormi, priorpci, chf,  stemi, hospid, hosp_region, hosp_locteach, hosp_bedsize, race,cm_dm, cm_dmcx, cm_obese, cm_renlfail, pay1, dx1:dx10, pr1:pr10,discwt.x, cm_liver)

b10 <- df10 %>% select(age, bita, died, year.x, dispuniform, female, key, los, nis_stratum.x, trendwt, valve, priormi, priorpci, chf,  stemi, hospid, hosp_region, hosp_locteach, hosp_bedsize, race,cm_dm, cm_dmcx, cm_obese, cm_renlfail, pay1, dx1:dx10, pr1:pr10,discwt.x, cm_liver)

b11 <- df11 %>% select(age, bita, died, year.x, dispuniform, female, key, los, nis_stratum.x, trendwt, valve, priormi, priorpci, chf,  stemi, hospid, hosp_region, hosp_locteach, hosp_bedsize, race,cm_dm, cm_dmcx, cm_obese, cm_renlfail, pay1, dx1:dx10, pr1:pr10,discwt.x, cm_liver)

b12 <- df12 %>% select(age, bita, died, year.x, dispuniform, female, key, los, nis_stratum.x, valve, priormi, priorpci, chf,  stemi, hospid, hosp_region, hosp_locteach, hosp_bedsize, race, trendwt,cm_dm, cm_dmcx, cm_obese, cm_renlfail, pay1, dx1:dx10, pr1:pr10,discwt.x, cm_liver)


b13 <- df13 %>% select(age, bita, died, year.x, dispuniform, female, key, los, nis_stratum.x, valve, priormi, priorpci, chf,  stemi, hospid, hosp_region, hosp_locteach, hosp_bedsize, race, trendwt,cm_dm, cm_dmcx, cm_obese, cm_renlfail, pay1,dx1:dx10, pr1:pr10,discwt.x, cm_liver)

b14 <- df14 %>% select(age, bita, died, year.x, dispuniform, female, key, los, nis_stratum.x, valve, priormi, priorpci, chf,  stemi, hospid, hosp_region, hosp_locteach, hosp_bedsize, race, trendwt,cm_dm, cm_dmcx, cm_obese, cm_renlfail, pay1, dx1:dx10, pr1:pr10,discwt.x, cm_liver)

b15.1 <- df15.1 %>% select(age, bita, died, year.x, dispuniform, female, key, los, nis_stratum.x, valve, priormi, priorpci, chf,  stemi, hospid, hosp_region, hosp_locteach, hosp_bedsize, race, trendwt,cm_dm, cm_dmcx, cm_obese, cm_renlfail, pay1, dx1:dx10, pr1:pr10,discwt.x, cm_liver)
```

Now, we need to create var in years 2012 onwards with same names that are present in 2011 so that we can rbind all data together.

```{r cocactenate all df together}


df <- rbind(b07,b08,b09,b10,b12,b11,b13,b14,b15.1)

# remove patients who had possible single vessel CABG

cabg_n <- as.character(c('3610','3612','3613','3614','3615','3617','3619'))

df$cabg_n <- with(df,ifelse((pr1 %in% cabg_n | pr2 %in% cabg_n | pr3 %in% cabg_n |
                               pr4 %in% cabg_n | pr5 %in% cabg_n),"yes","no"))



df %>% count(cabg_n)


df2 <- df %>% filter(cabg_n == "yes")

df <- df2


# Insulin dependent diabetics

iddm <- as.character(c('V5867'))


df$iddm_n <- with(df,ifelse((dx1 %in% iddm | dx2 %in% iddm | dx3 %in% iddm | dx4 %in% iddm | dx5 %in% iddm|
                               dx6 %in% iddm| dx7 %in% iddm| dx8 %in% iddm| dx9 %in% iddm| dx10 %in% iddm),"yes","no"))

df %>% count(iddm_n)


media <- as.character("5192")

df$media <- with(df,ifelse((dx1 %in% media  | dx2 %in% media | dx3 %in% media |
                              dx4 %in% media | dx5 %in% media | dx6 %in% media | dx7 %in% media | dx8 %in% media | dx9 %in% media | dx10 %in% media),"yes","no"))

df %>% count(media)


inf <- as.character("99859")

df$inf <- with(df,ifelse((dx1 %in% inf  | dx2 %in% inf | dx3 %in% inf |
                            dx4 %in% inf | dx5 %in% inf | dx6 %in% inf | dx7 %in% inf | dx8 %in% inf | dx9 %in% inf | dx10 %in% inf),"yes","no"))

df %>% count(inf)



cs <- as.character(c(78551))

df$cs <- with(df,ifelse((dx1 %in% cs  | dx2 %in% cs | dx3 %in% cs |
                           dx4 %in% cs | dx5 %in% cs | dx6 %in% cs | dx7 %in% cs | dx8 %in% cs | dx9 %in% cs | dx10 %in% cs),"yes","no"))


df %>% count(cs)

cpb <- as.character("3961")

df$cpb <- with(df,ifelse((pr1 %in% cpb | pr2 %in% cpb | pr3 %in% cpb |
                            pr4 %in% cpb | pr5 %in% cpb | pr6 %in% cpb | pr7 %in% cpb | pr8 %in% cpb | pr9 %in% cpb | pr10 %in% cpb),"yes","no"))

df %>% count(cpb)


# use of iabp

iabp <- as.character(c(3761))

df$iabp_n <- with(df,ifelse((pr1 %in% iabp | pr2 %in% iabp | pr3 %in% iabp |
                               pr4 %in% iabp | pr5 %in% iabp),"yes","no"))



df %>% count(iabp_n)


# use of pvad

pvad <- as.character(c(3768))

df$pvad_n <- with(df,ifelse((pr1 %in% pvad | pr2 %in% pvad | pr3 %in% pvad |
                               pr4 %in% pvad | pr5 %in% pvad),"yes","no"))



df %>% count(pvad_n)


```

Make some changes and add the variables needed to the ICD 10 containing df:
  
  
  ```{r}

cpb <- as.character(c("5A1221Z"))

a <- cpb

df15.4$cpb <- with(df15.4, ifelse((i10_pr1 %in% a | i10_pr2 %in% a | i10_pr3 %in% a | i10_pr4 %in% a  | i10_pr5 %in% a | i10_pr6 %in% a | i10_pr7 %in% a | i10_pr8 %in% a |i10_pr9 %in% a| i10_pr10 %in% a | i10_pr11 %in% a | i10_pr12 %in% a | i10_pr13 %in% a | i10_pr14 %in% a | i10_pr15 %in% a ), "yes","no"))

df15.4 %>% count(cpb)



b15.4 <- df15.4 %>% dplyr::select(drg,hosp_nis.x,i10_dx1,i10_dx2,i10_dx3,i10_dx4,i10_dx5,i10_dx6         ,i10_dx7,i10_dx8 ,i10_dx9,i10_dx10,i10_dx11,i10_dx12,i10_dx13,i10_dx14,i10_dx15,i10_dx16,i10_dx17        ,i10_dx18 ,i10_dx19, i10_dx20,i10_dx21,i10_dx22,i10_dx23,i10_dx24,i10_dx25,i10_dx26,i10_dx27        ,i10_dx28,i10_dx29,i10_dx30,i10_pr1,i10_pr2,i10_pr3,i10_pr4,i10_pr5,i10_pr6,i10_pr7,i10_pr8,i10_pr9, i10_pr10, i10_pr11, i10_pr12,i10_pr13,i10_pr14,i10_pr15,key_nis,discwt.x,hosp_bedsize, hosp_division.x, hosp_locteach, hosp_region,nis_stratum.x ,age,died,discwt.y,dispuniform,elective,female         ,hosp_division.y,los,pay1,race,totchg,lita,rita,bita,cm_chf,cm_aids,cm_anemdef,priormi,priorpci,stemi,
                                  carotid,icd,cpb, year.x)

# b15.4 contains the data for the last quarter of 2015. We will include this into the other 3 quarters of 2015 and present data for 2015 as the mean of both.

# need to do the same as below for the `var` of interest in this df

b15.4 <- b15.4 %>% 
  mutate(race_n = fct_recode(factor(race),
                             "white" = "1",
                             "black" = "2",
                             "hispanic" = "3",
                             "others" = "4",
                             "others" = "5",
                             NULL = "6" ))


b15.4 <- b15.4 %>% 
  mutate(pay_n = fct_recode(factor(pay1),
                            "medicare" = "1",
                            "medicaid" = "2",
                            "private_insurance" = "3",
                            "self_pay" = "4",
                            "other" = "5",
                            "other" = "6"))



b15.4 %>% count(race_n)

b15.4 %>% count(pay_n)

b15.4bita <- b15.4 %>% filter(bita == "yes")

# need to create surveydesign object for this df

s15.4 <- survey::svydesign(data = b15.4, weights = ~discwt.y, strata = ~nis_stratum.x, id = ~hosp_nis.x, nest = TRUE)



summary(s15.4)

s15.4bita <- survey::svydesign(data = b15.4bita, weights = ~discwt.y, strata = ~nis_stratum.x, id = ~hosp_nis.x, nest = TRUE)

summary(s15.4bita)

```




```{r some more data munging...}
# convert some variables to better form for analysis

# race 
df <- df %>% 
  mutate(race_n = fct_recode(factor(race),
                             "white" = "1",
                             "black" = "2",
                             "hispanic" = "3",
                             "others" = "4",
                             "others" = "5",
                             NULL = "6" ))


# primary payer

df <- df %>% 
  mutate(pay_n = fct_recode(factor(pay1),
                            "medicare" = "1",
                            "medicaid" = "2",
                            "private_insurance" = "3",
                            "self_pay" = "4",
                            "other" = "5",
                            "other" = "6"))

dfbita <- df %>% filter(bita == "yes")


# disposition after dismissal

df <- df %>% 
  mutate(disp_n = fct_recode(factor(dispuniform),
                             "home" = "1",
                             "short term hospital" = "2",
                             "SNF" = "5",
                             "home health care" = "6",
                             "AMA" = "7",
                             "died" = "20"))

df$disp_n[df$disp_n == "21"]<- NA
df$disp_n[df$disp_n == "99"]<- NA

df %>% count(disp_n)







df$bita_i[df$bita == "yes"] <- 1
df$bita_i[df$bita == "no"]<- 0

svydf <- survey::svydesign(data = df, weights = ~discwt.x, strata = ~nis_stratum.x, id = ~hospid, nest = T)



summary(svydf)

svydfbita <- survey::svydesign(data = dfbita, weights = ~discwt.x, strata = ~nis_stratum.x, id = ~hospid, nes = T)

summary(svydfbita)

```


After the data is obtained and cleaned, here are the trends that we want to see:
  
  Use months to seperate survey results rather than year --- that way we do not have to add the Q4 icd10 results to the remaining results for 2015 and much easier to present overall data. Also much easier to do C-A test to look for trends rather than combining data and averaging it.

We want to divide this paper into 2 parts:
  
  1. Trends overall as a country
2. Differences between regions and trends between regions.

1. Trends overall as a country ---- 
  
  a. % done in large hospitals vs rural hospitals == any change ?
  b. % done in teaching vs non-teaching hospitals == any change ?
  c. BITA use/ year == any change ?
  d. OPCABG/ year == any change ?
  e. mortality == any change ?
  f. LOS == any change ?
  g. disposition == any change ?
  
  
  If we want to focus on only BITA use ?
  
  a. Use of BITA/ year in whole US
b. Use of BITA according to hospital type 
c. Use of BITA according to teaching status 
d. Use of BITA according to CABG volume from 2007 - 2011. But even after, we can see total volume reported and % of BITA used according to that. So, we may be able to determine if there is a relationship between hospital volume and BITA use according. 



Prepare table 1:
  
  ```{r}
# table 1 with data from 2007 - 2015 3 quarters:

tdf <- df %>% 
  select(age, bita, died, year.x, dispuniform, female, key, 
         los, nis_stratum.x, trendwt, priormi, priorpci, 
         chf, stemi, hospid, hosp_region, hosp_locteach, hosp_bedsize, 
         race, cm_dm, cm_dmcx, cm_obese, cm_renlfail,discwt.x, cabg_n, media, inf, cpb, race_n, pay_n, bita_i,discwt.x, iddm_n, disp_n, iddm_n, iabp_n, pvad_n, cm_liver, cs)

myvars <- c('age', 'bita', 'died', 'year.x', 'dispuniform', 'female',
            'los',  'priormi', 'priorpci', 
            'chf', 'stemi', 'hosp_region', 'hosp_locteach', 'hosp_bedsize',  'cm_dm', 'cm_dmcx', 'cm_obese', 'cm_renlfail', 'media', 'inf', 'cpb', 'race_n', 'pay_n', 'bita_i', 'disp_n', "iddm_n", "iabp_n", "pvad_n", "cm_liver", "cs")



## Vector of categorical variables that need transformation

catVars <- c( 'bita', 'died', 'year.x', 'dispuniform', 'female',
              'priormi', 'priorpci', 'chf', 'stemi', 'hosp_region', 'hosp_locteach', 'hosp_bedsize',  'cm_dm', 'cm_dmcx', 'cm_obese', 'cm_renlfail', 'media', 'inf', 'cpb', 'race_n', 'pay_n', 'bita_i', "disp_n", "iddm_n", "iabp_n", "pvad_n", "cm_liver", "cs")

t1d <- svydesign(data = tdf, strata = ~nis_stratum.x, id = ~hospid, weights = ~discwt.x, nest = TRUE)

tab1 <- svyCreateTableOne(vars = myvars , data = t1d, factorVars = catVars, includeNA = TRUE, smd = TRUE)


table1 <- print(tab1)





```








Doing some initial survey analysis to get basic #:

```{r some survey analysis}

# 1. type of admission: --- we need to work on the 2012 - 2015 to include type of admission

# type of admission NA 2012 onwards. Need to do seperate analysis for atype



```


Survey analysis by year to determine trends per year:
  
  ```{r}

# mean age per year for all CABG patients

svyby(~age, by = ~year.x, FUN = svymean, design = svydf)

# mean age for last Q

age <- svyby(~age, by = ~year.x, FUN = svymean, design = s15.4)

#################################################################

# gender per year

f <- svytable(~year.x + female, svydf)

f1 <- as.data.frame(f)

tbl_df(f1)

f3 <- f1 %>% spread(key = female, value = Freq)

write_csv(f3, "H:/bita_nis/st/female_prop.csv")

# analysis for Q4

f_l <- svytable(~year.x + female, s15.4)

f_l

######################################################################
# BITA procedures per year of study

b <- svytable(~year.x + bita, svydf)

b1 <- as.data.frame(b)

tbl_df(b1)

b3 <- b1 %>% spread(key = bita, value = Freq)

b4 <- mutate(b3, total = no + yes)

b5 <- b4 %>% mutate(perc = ((yes/total)*100))

write_csv(b5, "H:/bita_nis/st/bita_prop.csv")

## Analysis for the last Q of 2015

b_l <- svytable(~year.x + bita, s15.4)

b_l

###################################################################


# prior mi per year

pmi <- svytable(~year.x + priormi, svydf)

as.data.frame(pmi)

pm1 <- pmi %>% tbl_df

pm2 <- pm1 %>% spread(key = priormi, value = n)

pm2

pm3 <- pm2 %>% mutate(total = yes + no)

pm4 <- pm3 %>% mutate(perc = ((yes/total)*100))

pm4


###########################################################################

# cardiogenic shock at presentation 

cy <- svytable(~year.x + cs, svydf)

as.data.frame(cy)

cy1 <- cy %>% tbl_df

cy2 <- cy1 %>% spread(key = cs, value = n)

cy2

cy3 <- cy2 %>% mutate(total = yes + no)

cy4 <- cy3 %>% mutate(perc = ((yes/total)*100))

cy4

# cardiogenic shock for Q4



###########################################################

# important to determine use of IABP or PVAD prior to surgery; so see if PVAD/IABP occurred same day or prior day.

# iabp

ia <- svytable(~year.x + iabp_n, svydf)

as.data.frame(ia)

ia1 <- ia %>% tbl_df

ia2 <- ia1 %>% spread(key = iabp_n, value = n)

ia2

ia3 <- ia2 %>% mutate(total = yes + no)

ia4 <- ia3 %>% mutate(perc = ((yes/total)*100))

ia4

############################################################
# pvad use during the study period

pv <-  svytable(~year.x + pvad_n, svydf)

as.data.frame(pv)

pv1 <- pv %>% tbl_df

pv2 <- pv1 %>% spread(key = pvad_n, value = n)

pv2

pv3 <- pv2 %>% mutate(total = yes + no)

pv4 <- pv3 %>% mutate(perc = ((yes/total)*100))

pv4

##############################################################

# dm and associated dm conditions per year change

dm <-  svytable(~year.x + cm_dm, svydf)

as.data.frame(dm)

dm1 <- dm %>% tbl_df

dm2 <- dm1 %>% spread(key = cm_dm, value = n)

dm2

dm3 <- dm2 %>% mutate(total = yes + no)

dm4 <- dm3 %>% mutate(perc = ((yes/total)*100))

dm4

##########################################################



```




```{r doing some survey analysis}



# cabg done by region

svytable(~cabg_n + hosp_region, design = svydf)

svytable(~year.x + hosp_region, design = s15.4)

# gender distribution by region

loc_cabg <- svytable(~cabg_n + hosp_locteach, design = svydf)

loc_cabg


svytable(~year.x + hosp_locteach, design = s15.4)



# mean age per year for only patients undergoing BITA use

age_l <- svyby(~age, by = ~year.x, FUN = svymean, design = subset(svydf, bita == "yes"))

age
age_l

# gender per year for only patients with BITA used

fb <- svytable(~year.x + female, design = subset(svydf, bita == "yes"))

fb1 <- as.data.frame(fb)

write_csv(fb1, "H:/bita_nis/st/bita_female.csv")

fb_l <- svytable(~year.x + female, design = subset(s15.4, bita == "yes"))

fb_l


# hospital region

df %>% count(hosp_region)

region <- svytable(~hosp_region + bita, svydf)


r1 <- as.data.frame(region)

r3 <- r1 %>% spread(key = bita, value = Freq)

r3 %>% tbl_df

r4 <- mutate(r3, total = yes + no)

r5 <- mutate(r4, perc = ((yes/total)*100))

r5

write_csv(r5, "H:/bita_nis/st/region_bita.csv")


# teaching nature of hospital for BITA use 

df %>% count(hosp_locteach)


teach <- svytable(~hosp_locteach + bita, svydf)

t1 <- as.data.frame(teach)

t1 

t3 <- t1 %>% spread(key= bita, value = Freq)

as_tibble(t3)

t4 <- t3 %>% mutate(total = yes + no)

t5 <- t4 %>% mutate(perc = ((yes/total)*100))

t5

write_csv(t5, "H:/bita_nis/st/teach_bita.csv")
```


```{r}

# BITA use according to race

df %>% count(race_n)


r <- svytable(~race_n + bita, design = svydf)

r3 <- as.data.frame(r)

r4 <- r3 %>% spread(key = bita, value = Freq)

r5 <- r4 %>% mutate(total = yes + no)

r5 <- r5 %>% mutate(perc = ((yes/total)*100))

r5
```



```{r payment type and BITA use}

p <- svytable(~pay_n + bita, design = svydf)

svychisq(~pay_n + bita, design = svydf)

p3 <- as.data.frame(p)

p4 <- p3 %>% spread(key = bita, value = Freq)

p5 <- p4 %>% mutate(total = yes + no)

p5 <- p5 %>% mutate(perc = ((yes/total)*100))
p5


po <- svytable(~pay_n + bita, design = subset(svydf, age > 64))

svychisq(~pay_n + bita, design = subset(svydf, age > 64))

po3 <- as.data.frame(po)

po4 <- po3 %>% spread(key = bita, value = Freq)

po5 <- po4 %>% mutate(total = yes + no)

po5 <- po5 %>% mutate(perc = ((yes/total)*100))
po5

```



```{r}

dm <- svytable(~cm_dm + bita, design = svydf)

dmonly <- svytable(~year.x + bita, design = subset(svydf, cm_dm == 1))

dm2 <- as.data.frame(dmonly) 

dmon <- dm2 %>% spread(key = bita, value = Freq)

dmo1 <- dmon %>% mutate(total = yes + no)

dmon2 <- dmo1 %>% mutate(perc = ((yes/total)*100))

dmon2


# nondiabetic patients 

nodm <- svytable(~year.x + bita, design = subset(svydf, cm_dm == 0  & cm_dmcx == 0))

nodm2 <- as.data.frame(nodm) 

nodm3 <- nodm2 %>% spread(key = bita, value = Freq)

nodm4 <- nodm3 %>% mutate(total = yes + no)

nodm5 <- nodm4 %>% mutate(perc = ((yes/total)*100))

nodm5
```




```{r for NE region}

b_ne <- svytable(~year.x + bita, design = subset(svydf, hosp_region == 1))

b_ne1 <- as.data.frame(b_ne)

tbl_df(b_ne1)

b_ne3 <- b_ne1 %>% spread(key = bita, value = Freq)

b_ne4 <- mutate(b_ne3, total = no + yes)

b_ne5 <- b_ne4 %>% mutate(perc = ((yes/total)*100))
```



```{r for young adults}

b_y <- svytable(~year.x + bita, design = subset(svydf, age < 51))

b_y1 <- as.data.frame(b_y)

tbl_df(b_y1)

b_y3 <- b_y1 %>% spread(key = bita, value = Freq)

b_y4 <- mutate(b_y3, total = no + yes)

b_y5 <- b_y4 %>% mutate(perc = ((yes/total)*100))

b_y5

b_yno <- svytable(~year.x + bita, design = subset(svydf, age < 51 & cm_dm == 0))



b_yno1 <- as.data.frame(b_yno)

tbl_df(b_yno1)

b_yno3 <- b_yno1 %>% spread(key = bita, value = Freq)

b_yno4 <- mutate(b_yno3, total = no + yes)

b_yno5 <- b_yno4 %>% mutate(perc = ((yes/total)*100))

b_yno5

```


Use of CPB during surgery:
  
  ```{r}
cpb_n <- svytable(~year.x + cpb, design = svydf)

cpb_n1 <- as.data.frame(cpb_n)

tbl_df(cpb_n1)

cpb_n3 <- cpb_n1 %>% spread(key = cpb, value = Freq)

cpb_n4 <- cpb_n3 %>% mutate(total = yes + no)

cpb_n5 <- cpb_n4 %>% mutate(perc = ((no/total)*100))

cpb_n5



reg_c <- svytable(~hosp_region + cpb, design = svydf)

as.data.frame(reg_c) 

reg_c1 <- reg_c %>% tbl_df

reg_c2 <- reg_c1 %>% spread(key = cpb, value = n)

reg_c2
```









