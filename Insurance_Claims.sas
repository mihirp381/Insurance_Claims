/* Read car insurance data file */
DATA a1;
INFILE "H:\car_insurance_19.csv" FIRSTOBS = 2 DLM = "," ;
INPUT Customer $ State $ CustomerLifetimeValue Response $ Coverage $ Education $ EffectiveToDate $ EmploymentStatus $ Gender $ Income LocationCode $ MaritalStatus $ MonthlyPremiumAuto MonthsSinceLastClaim MonthsSincePolicyInception NumberOfOpenComplaints NumberOfPolicies PolicyType $ Policy $ RenewOfferType $ SalesChannel $ TotalClaimAmount VehicleClass $ VehicleSize $;
RUN;

/* View dataset */
FOOTNOTE 'For BUAN-6337.03 Predictive Analytics for Data Science S23';
PROC PRINT DATA = a1 (OBS=10);
RUN;

/* Question 1*/
/* Frequency Distribution of Gender */
TITLE 'Frequency Distribution of Gender';
PROC FREQ DATA = a1;
TABLE Gender;
RUN;
/* Visualization */
TITLE 'Gender Barplot';
PROC GCHART DATA=a1;
HBAR Gender;
RUN;

/* Frequency Distribution of Vehicle Class */
TITLE 'Frequency Distribution of Vehicle Class';
PROC FREQ DATA = a1;
TABLE VehicleClass;
RUN;
/* Visualization */
TITLE 'Vehicle Class Barplot';
PROC GCHART DATA=a1;
HBAR VehicleClass;
RUN;

/* Frequency Distribution of Vehicle Size */
TITLE 'Frequency Distribution of Vehicle Size';
PROC FREQ DATA = a1;
TABLE VehicleSize;
RUN;
/* Visualization */
TITLE 'Vehicle Size Barplot';
PROC GCHART DATA=a1;
HBAR VehicleSize;
RUN;

/* Frequency Distribution of Gender, Vehicle Class, Vehicle Size */
TITLE 'Nested Frequency Distribution of Gender, Vehicle Class, and Vehicle Size';
PROC FREQ DATA = a1;
TABLE Gender*VehicleClass*VehicleSize;
RUN;

/* Question 2 */
/* Avg Customer Lifetime Value by Gender */
TITLE 'Average Customer Lifetime Value for Gender';
PROC MEANS DATA = a1;
VAR CustomerLifetimeValue;
CLASS Gender;
RUN;

/* Avg Customer Lifetime Value by Vehicle Size*/
TITLE 'Average Customer Lifetime Value for Vehicle Size';
PROC MEANS DATA = a1;
VAR CustomerLifetimeValue;
CLASS VehicleSize;
RUN;

/* Avg Customer Lifetime Value by Vehicle Class */
TITLE 'Average Customer Lifetime Value for Vehicle Class';
PROC MEANS DATA = a1;
VAR CustomerLifetimeValue;
CLASS VehicleClass;
RUN;

/* Avg Customer Lifetime Value by Gender, Vehicle Size, Vehicle Class */
TITLE 'Average Customer Lifetime Value for Gender, Vehicle Size, and Vehicle Class (combined)';
PROC MEANS DATA = a1;
VAR CustomerLifetimeValue;
CLASS Gender VehicleSize VehicleClass;
RUN;

/* Question 3 */
/* t-test: lifetime value of medium sized vs large sized cars */
TITLE 'Customer Lifetime Value for Large Cars vs Medium Sized Cars';
/* create a sub-set */
DATA a2;
SET a1;
IF VehicleSize = "Large" OR VehicleSize = "Medsize";
PROC ttest;
VAR CustomerLifetimeValue;
CLASS Vehiclesize;
RUN;

/* Question 4 */
/* t-test: customer lifetime value of male vs female */
TITLE 'Customer Lifetime Value for Male vs Female';
PROC ttest DATA = a1;
VAR CustomerLifetimeValue;
CLASS Gender;
RUN;

/* Question 5 */
/* ANOVA: difference in lifetime value across different sales channel */
TITLE 'Customer Lifetime Value Across Different Sales Channels';
PROC ANOVA DATA = a1;
CLASS SalesChannel;
MODEL CustomerLifetimeValue = SalesChannel;
MEANS SalesChannel/tukey;
RUN;

/* Question 6 */
/* Effect of Education on Customer Lifetime Value  using ANOVA*/
TITLE 'Effect of Education on Customer Lifetime Value';
PROC ANOVA DATA = a1;
CLASS Education;
MODEL CustomerLifetimeValue = Education;
RUN;

/* Effect of Income on Customer Lifetime Value  using Correlation*/
TITLE 'Effect of Income on Customer Lifetime Value';
PROC CORR DATA = a1;
VAR CustomerLifetimeValue Income;
RUN;

/* Effect of Marital Status on Customer Lifetime Value  using ANOVA*/
TITLE 'Effect of Marital Status on Customer Lifetime Value';
PROC ANOVA DATA = a1;
CLASS MaritalStatus;
MODEL CustomerLifetimeValue = MaritalStatus;
RUN;

/* Effect of Demographic Factors - Education, Income, Marital Status on Customer Lifetime Value using Regression Anlaysis */
/* creating a subset */
/* Education Levels - High School or Below < College < Bachelor < Master < Doctor */
/* Marital Status Levels - Single Married Divorced */
TITLE 'Effect of Education, Income, and Marital Status on Customer Lifetime Value';
DATA a3;
SET a1;
IF Education = "College" THEN dE1 = 1; ELSE dE1 = 0;
IF Education = "Bachelor" THEN dE2 = 1; ELSE dE2 = 0;
IF Education = "Master" THEN dE3 = 1; ELSE dE3 = 0;
IF Education = "Doctor" THEN dE4 = 1; ELSE dE4 = 0;
IF MaritalStatus = "Married" THEN dM1 = 1; ELSE dM1 = 0;
IF MaritalStatus = "Divorced" THEN dM2 = 1; ELSE dM2 = 0;
RUN;
PROC REG;
MODEL CustomerLifetimeValue = dE1 dE2 dE3 dE4 Income dM1 dM2;
RUN;

/* Question 7 */
/* Relationship between renew offer type and response */
TITLE 'Relationship between Renew Offer Type and Response';
PROC FREQ DATA = a1;
TABLE Response*RenewOfferType / chisq;
RUN;

/* Question 8 */
/* ANOVA: difference in customer lifetime value across different renew offer types */
TITLE 'Customer Lifetime Value Across Different Renew Offer Types';
PROC ANOVA DATA = a1;
CLASS RenewOfferType;
MODEL CustomerLifetimeValue = RenewOfferType;
MEANS RenewOfferType/tukey;
RUN;

/* Question 9 */
/* ANOVA: difference in customer lifetime value across different renew offer types and states */
TITLE 'Customer Lifetime Value Across Different Renew Offer Types and States';
PROC ANOVA DATA = a1;
CLASS RenewOfferType State;
MODEL CustomerLifetimeValue = RenewOfferType*State;
MEANS RenewOfferType*State/tukey;
RUN;

/* Question 10*/
/* 1. ANOVA: total claim amount across vehicle class */
TITLE 'Total Claim Amount Across Different Vehicle Classes';
PROC ANOVA DATA = a1;
CLASS VehicleClass;
MODEL TotalClaimAmount = VehicleClass;
MEANS VehicleClass/tukey;
RUN;

TITLE 'Total Claim Amount Across Different Vehicle Sizes';
PROC ANOVA DATA = a1;
CLASS VehicleSize;
MODEL TotalClaimAmount = VehicleSize;
MEANS VehicleSize/tukey;
RUN;

/* 2. ANOVA: income across coverage */
TITLE 'Income Across Different Coverage Types';
PROC ANOVA DATA = a1;
CLASS Coverage;
MODEL Income = Coverage;
MEANS Coverage/tukey;
RUN ;

/* 3. Chi Square: relationship between coverage and employment status */
TITLE 'Relationship between Coverage and Employement Status';
PROC FREQ DATA = a1;
TABLE Coverage*EmploymentStatus / chisq;
RUN;



