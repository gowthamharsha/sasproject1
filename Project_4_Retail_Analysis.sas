%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/home/gowthamharshabh0/Project 04_Retail Analysis_Dataset.xlsx';

/* The following code imports dataset into SAS*/
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=SASPROJ.Retail_Analysis;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=SASPROJ.Retail_Analysis; RUN;


/* Since it is been observed that the dataset has individual price of product 
   but no record measuring the total sales of each product, a new variable 
   Total_Sales = Sales*Quantity is being created*/
proc sql;
create table SASProj.Retail_Analysis_Modified as
	select *, Sales*Quantity as Total_Sales from Sasproj.retail_analysis;
	quit;
	

/* Following code gets descriptive statics on the modified dataset */
Proc Means data=sasproj.retail_analysis_modified;
run;


/* Checking whether individual variable is significant or linearly related to Total_Sales*/
proc reg data=sasproj.retail_analysis_modified;
	model Total_Sales = Quantity; /*Checking the suitability of variable quatity*/
	var Total_Sales;
	Run;

proc reg data=sasproj.retail_analysis_modified;
	model Total_Sales = Profit; /*Checking the suitability of variable Profit*/
	var Total_Sales;
	Run;
	
/*Checking the suitability of variable Shipping_Cost.
  Marketing cost is assumed as Shipping _Cost*/
proc reg data=sasproj.retail_analysis_modified;
	model Total_Sales = Discount; 
	var Total_Sales;
	Run;

/*Now performing Multivariate Regression Analysis*/
proc reg data=sasproj.retail_analysis_modified;
	model Total_Sales = Quantity Profit Shipping_Cost;
	var Total_Sales;
	Run;


proc reg data=sasproj.retail_analysis_modified;
	model Total_Sales = Quantity Profit Discount;
	var Total_Sales;
	Run;


ODS GRAPHICS ON;
 PROC TRANSREG DATA = sasproj.retail_analysis_modified TEST;
 MODEL BOXCOX(Total_Sales) = IDENTITY(Quantity Profit: );
 RUN;
ODS GRAPHICS OFF;




%web_open_table(WORK.IMPORT);