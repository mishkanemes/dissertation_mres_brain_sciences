## Script to do analysis after exclusion of outlier trials for reaction times (+/- 2*SD)
# Mihaela Nemes, June 2018


## clear environment 
rm(list=ls())


install.packages("lme4");
install.packages("car");
install.packages("gdata");
install.packages("optimx");
install.packages("MASS");
install.packages("mlogit");
install.packages("pbkrtest");
install.packages("dotwhisker");
install.packages("broom");
install.packages("dplyr");
install.packages("arm");
install.packages("Hmisc");
install.packages("ggm");
install.packages("ggplot2");
install.packages("polycor");
install.packages("stringi");
install.packages("reshape");


library(lme4)
library(car)
library(gdata)
library(optimx)
library(MASS)
library(mlogit)
library(pbkrtest)
library(dotwhisker)
library(broom)
library(dplyr)
library(arm)
library(boot);
library(ggm);
library(ggplot2);
library(Hmisc);
library(polycor);
library(reshape)

# ___________________________________________________________________________________________
## run regression by trial

## load regression data from csv file

data_rgrs_exp <- read.csv(file.choose('rgrs_trial_zexp'))
data_rgrs_exp_overconf <- read.csv(file.choose('rgrs_trial_zexp_overconf'))
data_rgrs_exp_underconf <- read.csv(file.choose('rgrs_trial_zexp_underconf'))


data_rgrs_stage1 <- read.csv(file.choose('rgrs_trial_stage1'))
data_rgrs_stage2 <- read.csv(file.choose('rgrs_trial_stage2'))
data_rgrs_stage3 <- read.csv(file.choose('rgrs_trial_stage3'))



## ------------------------------------------------------------------------------


# run most complex

conf_model1s <- lm (conf ~ perf + rt + trial + stage + coherence + trial:stage + perf:rt + rt:trial + rt:stage + perf:stage, data = data_rgrs_exp) 
summary(conf_model1s)

coefplot(conf_model1s, intercept=TRUE, main = "conf_model1s", v.axis=TRUE, h.axis=TRUE, vertical = FALSE,
         cex.var=1, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-0.5, 0.5), col.pts="black", offset = 0, var.las = 1)

# overconf subj
conf_model1_overconf <- lm (conf ~ perf + rt + trial + stage + coherence, data = data_rgrs_exp_overconf) 
summary(conf_model1_overconf)

# underconf subj
conf_model1_underconf <- lm (conf ~ perf + rt + trial + stage + coherence, data = data_rgrs_exp_underconf) 
summary(conf_model1_underconf)


coefplot(conf_model3s, intercept=TRUE, main = "conf_model1s", v.axis=TRUE, h.axis=TRUE, vertical = FALSE,
         cex.var=1, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-0.5, 0.5), col.pts="black", offset = 0, var.las = 1)
coefplot(conf_model1_overconf, intercept=TRUE, add = TRUE, main = "conf_model1_overconf", v.axis=TRUE, h.axis=TRUE, vertical = FALSE,
         cex.var=1, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-0.5, 0.5), col.pts="blue", offset = 0.1, var.las = 1)
coefplot(conf_model1_underconf, intercept=TRUE, add = TRUE, main = "conf_model1_underconf", v.axis=TRUE, h.axis=TRUE, vertical = FALSE,
         cex.var=1, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-0.5, 0.5), col.pts="red", offset = 0.2, var.las = 1)
legend("bottomright", legend=c("All", "Overconfident", "Underconfident"), lty = 1:1)

## ----------

conf_model2s <- lm (conf ~ perf + rt + trial + stage + coherence + perf:rt, data = data_rgrs_exp) 
summary(conf_model2s)

coefplot(conf_model2s, intercept=TRUE, main = "conf_model2s", v.axis=TRUE, h.axis=TRUE, vertical = FALSE,
         cex.var=1, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-0.5, 0.5), col.pts="black", offset = 0, var.las = 1)

## ----------

conf_model3s <- lm (conf ~ perf + rt + trial + stage + coherence, data = data_rgrs_exp) 
summary(conf_model3s)

coefplot(conf_model3s, intercept=TRUE, main = "conf_model3s", v.axis=TRUE, h.axis=TRUE, vertical = FALSE,
         cex.var=1, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-1, 1), col.pts="black", offset = 0, var.las = 1)


## ------------------------------------------------------------------------------
# run model - STAGES

conf_model3s_s1 <- lm (conf ~ perf + rt + trial + stage + coherence, data = data_rgrs_stage1) 
summary(conf_model3s_s1)

conf_model3s_s2 <- lm (conf ~ perf + rt + trial + stage + coherence, data = data_rgrs_stage2) 
summary(conf_model3s_s2)

conf_model3s_s3 <- lm (conf ~ perf + rt + trial + stage + coherence, data = data_rgrs_stage3) 
summary(conf_model3s_s3)

coefplot(conf_model3s, intercept=TRUE, main = "Predicting confidence", v.axis=TRUE, h.axis=TRUE, vertical = FALSE,
         cex.var=1.2, cex.pts=2, mar=c(2,7,7,2), ylim=c(-0.5, 0.5), col.pts="black", offset = 0, var.las = 1)
coefplot(conf_model3s_s1, intercept=TRUE, v.axis=TRUE, h.axis=TRUE, vertical = FALSE, add = TRUE,
         cex.var=1.7, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-0.5, 0.5), col.pts="black", offset = 0.1, var.las = 1, 
         pch.pts = 2)
coefplot(conf_model3s_s2, intercept=TRUE, v.axis=TRUE, h.axis=TRUE, vertical = FALSE, add = TRUE,
         cex.var=1.7, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-0.5, 0.5), col.pts="black", offset = 0.2, var.las = 1,
         pch.pts = 6)
coefplot(conf_model3s_s3, intercept=TRUE, v.axis=TRUE, h.axis=TRUE, vertical = FALSE, add = TRUE,
         cex.var=1.7, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-0.5, 0.5), col.pts="black", offset = 0.3, var.las = 1,
         pch.pts = 17)
legend("topright", legend=c("All stages", "Stage 1", "Stage 2", "Stage 3"), lty = 1:1, cex = 1, pch =c(16, 2, 6, 17))
labs (y = "Beta coefficients", x = "Predictors")


## ----------

conf_model4s <- lm (conf ~ perf + rt + trial + stage, data = data_rgrs_exp) 
summary(conf_model4s)

coefplot(conf_model4s, intercept=TRUE, main = "conf_model4s", v.axis=TRUE, h.axis=TRUE, vertical = FALSE,
         cex.var=1, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-1, 1), col.pts="black", offset = 0, var.las = 1)

## ----------

conf_model5s <- lm (conf ~ perf + rt + stage, data = data_rgrs_exp) 
summary(conf_model5s)

coefplot(conf_model5s, intercept=TRUE, main = "conf_model5s", v.axis=TRUE, h.axis=TRUE, vertical = FALSE,
         cex.var=1, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-0.5, 0.5), col.pts="black", offset = 0, var.las = 1)

## ----------

conf_model6s <- lm (conf ~ perf + rt + trial, data = data_rgrs_exp) 
summary(conf_model6s)

coefplot(conf_model6s, intercept=TRUE, main = "conf_model6s", v.axis=TRUE, h.axis=TRUE, vertical = FALSE,
         cex.var=1, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-1, 1), col.pts="black", offset = 0, var.las = 1)

## ----------

conf_model7s <- lm (conf ~ rt + stage, data = data_rgrs_exp) 
summary(conf_model7s)

coefplot(conf_model7s, intercept=TRUE, main = "conf_model7s", v.axis=TRUE, h.axis=TRUE, vertical = FALSE,
         cex.var=1, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-1, 1), col.pts="black", offset = 0, var.las = 1)

## ----------

conf_model8s <- lm (conf ~ rt + stage + trial, data = data_rgrs_exp) 
summary(conf_model8s)

coefplot(conf_model8s, intercept=TRUE, main = "conf_model8s", v.axis=TRUE, h.axis=TRUE, vertical = FALSE,
         cex.var=1, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-1, 1), col.pts="black", offset = 0, var.las = 1)

## ----------

conf_model9s <- lm (conf ~ stage + trial, data = data_rgrs_exp) 
summary(conf_model9s)

coefplot(conf_model9s, intercept=TRUE, main = "conf_model9s", v.axis=TRUE, h.axis=TRUE, vertical = FALSE,
         cex.var=1, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-1, 1), col.pts="black", offset = 0, var.las = 1)

## ----------

conf_model10s <- lm (conf ~ stage + rt + stage:rt, data = data_rgrs_exp) 
summary(conf_model10s)

coefplot(conf_model10s, intercept=TRUE, main = "conf_model10s", v.axis=TRUE, h.axis=TRUE, vertical = FALSE,
         cex.var=1, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-0.5, 0.5), col.pts="black", offset = 0, var.las = 1)

## ----------

BIC_conf <- BIC(conf_model1s, conf_model2s, conf_model3s, conf_model4s, conf_model5s, conf_model6s, conf_model7s, conf_model8s, conf_model9s, conf_model10s) 
BIC(conf_model3s_s1, conf_model3s_s2, conf_model3s_s3)  
barplot(BIC_conf$BIC, beside = TRUE, ylim = c(17500,18500))

table <- anova(conf_model1s, conf_model2s, conf_model3s, conf_model4s, conf_model5s, conf_model6s, conf_model7s, conf_model8s, conf_model9s, conf_model10s)

## ------------------------------------------------------------------------------
# run model for each subject 


data_rgrs_subj  <- data_rgrs_exp[ which(data_rgrs_exp$subject=="1"), ]

model_conf3s_subj <- lm(conf ~ perf + rt + trial + stage + coherence, data = data_rgrs_subj) 
summary(model_conf6s_subj)

coefplot(model_conf3s_subj, intercept=TRUE, v.axis=TRUE, h.axis=TRUE, vertical = FALSE, add = FALSE,
         cex.var=1, cex.pts=1, mar=c(2,7,7,2), ylim=c(-3, 3), col.pts="black", offset = 0.3, var.las = 1,
         pch.pts = 1)


for (i in 2:31){
  data_rgrs_subj  <- data_rgrs_exp[ which(data_rgrs_exp$subject==i), ]
  
  model_conf3s_subj <- lm(conf ~ perf + rt + trial + stage + coherence, data = data_rgrs_subj) 
  summary(model_conf3s_subj)
  
  coefplot(model_conf3s_subj, intercept=TRUE, v.axis=TRUE, h.axis=TRUE, vertical = FALSE, add = TRUE,
           cex.var=1, cex.pts=1, ylim=c(-3, 3), col.pts="black", offset = i*0.01, var.las = 1,
           pch.pts = 1)
}


subj_coeff <- matrix(nrow = 0, ncol = 6)

for (i in unique(data_rgrs_exp[,"subject"])){
  data_rgrs_subj  <- data_rgrs_exp[ which(data_rgrs_exp$subject==i), ]
  
  rgrs_subj_model3subj <- lm(conf ~ perf + rt + trial + stage + coherence, data = data_rgrs_subj)
  
  subj_coeff <- rbind(subj_coeff,summary(rgrs_subj_model3subj)$coefficients[2:6])    
  
  
  coefplot(rgrs_subj_model3subj, intercept=TRUE, v.axis=TRUE, h.axis=TRUE, vertical = FALSE, add = TRUE,
           cex.var=1.7, cex.pts=1.7, mar=c(2,7,7,2), ylim=c(-0.5, 0.5), col.pts="black", offset = 0.1, var.las = 1,
           pch.pts = 17)
  
}


#transform coefficiencts by participant vector to dataframe
CoefsDataFrameLike <- data.frame(subj_coeff)
#extract the name of the coefficients
a <- names (rgrs_subj_model6s$coefficients)
#replace names for coefficients in dataframe
for (j in 2: length(a)){
  colnames(CoefsDataFrameLike)[j-1] <- a[j]
}
CoefsDataFrameLike