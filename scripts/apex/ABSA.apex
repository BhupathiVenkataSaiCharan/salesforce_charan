
// solved by me 
//Defect 1 (Conversions Tab) (20th June 2024) (Test Document name : Conversion tab test)

//Problem ::: conversion tab fields not visible and net margin doesn't take decimal values

Object Name ( Application_Product_CPF__c )

Object fields level access (not given to user profile)

Conversion_options__c (given by me)
Total_facility_limit_on_amendment_date__c (given by me)
Final_repayment_date_after_conversion__c (given by me)
Number_of_periods__c (given by me)
Interest_payment_day__c (given by me)
Flexi_fee__c (given by me)
Gap_insurance__c (given by me)

Net_margin__c (given by me)
All_in_risk_margin__c (given by me)

Interest_rate_basis__c (has access previously)
Prime_rate_margin__c (has access previously)
Margin__c (has access previously)
Term__c (has access previously)


Fields modified in Object (Application_Product_CPF__c)

Net_margin__c (changed by me from decimal (18,0)=>(16,2))
All_in_risk_margin__c (changed by me from decimal (18,0)=>(16,2))


//Problem ::: conversion tab fields not visible and net margin doesn't take decimal values



//----------------------------------------------------------------------------------------------------------------------

//solved by me 

//Defect 2 (covenants tab) (21-06-2024) (Test Document name : Covenants tab test)

//Problem ::: covenants tab delete using index deletes other section rows

Main component : CPFCovenants
Problem component / child component with remove button : CPFDebitservice


Changes made 

1. In CPFCovenants.cmp 
    -->changed the unlimrowindex attribute from type string to integer and added default = "0"
    -->for <c:CPFDebitservice /> changed rowindex to unlimrowindex = {!index}

2. In CPFCovenantscontroller.js
    -->made changes in handledebitevent method & handleinterestevent method

3. In CPFDebitservice.cmp 
    -->changed the onclick event name for debt service cover ratio to "removeDebtAccount"
    -->added the onclick event "removeIntAccount" for interest service cover ratio
    -->changed the ui output text value from rowindex to unlimrowindex

4. In CPFDebitservicecontroller.js  
    --> changed the removeAccount to removeDebtAccount
    --> added the removeIntAccount click event

5. In CPFDebitservicehelper.js
    --> changed the removeAccount to removeDebtAccount
    -->added the removeIntAccount helper method

6. No changes made in CPFdebitevent.evt



//Problem ::: covenants tab delete using index deletes other section rows







//----------------------------------------------------------------------------------------------------------------------



//Defect 3 (21-06-2024) (conditions tab) (Test document : )

//problem ::: conditions tab

Main component : CPFPreSales.cmp
problem component / child component : CPFPresalechildcmp.cmp



Changes made

1. Created a new Application Event :     
    --> with a new attribute UnlimitedRowIndex

2. In Child component cmp file: CPFPresalechildcmp.cmp
    --> registered the created event in child 
    --> added new attribute unlimrowindex
    --> changed the rowindex to unlimrowindex for uioutput text for pre disbursement section
    
3. In Child component helper file : CPFPresalechildcmphelper.js
    -->in method removepredisbursement called the new event and set the parameters

4. In parent component : CPFPreSales.cmp
    --> added new attributes rowindex and unlimrowindex with type integer
    --> handle the new event with the registered name
    --> change the parameter name from rowindex to unlimrowindex in predisbursment section <C:CPFPresalechildcmp/>

5. In parent component Controller : CPFPreSalesController.js
    -->get the parameters for rowindex and unlimrowindex in respective methods.



/*  This defect was similar to the covenants defect above, 
    but when making the changes similar to the the covenants, the second section button doesn't work to remove condition
    it is because we are setting parameters to the application event 
    and getting individual paramter in individual handlemethods so it is breaked unexpectedly
    so for unlimrowindex attribute we created new application

*/

//problem ::: conditions tab



//problem ::: conditions tab


1. In child component cmp : CPFConditionPrecedentAddLease.cmp
    --> declared unlimrowindex attribute    
    --> changed the ui output text in special conditions section
    --> registered the new event CPFUnlimitedGaurantees.evt

2. In child component helper :
    --> changed the setParams to UnlimitedRowIndex in removeSpecialCond method

3. In Main component cmp : CPFConditionsPrecendentNotariallyTiedOrConsolidation.cmp
    --> changed the rowindex to unlimrowindex in <C:CPFConditionPrecedentAddLease /> in special conditions section
    --> changed the handler name to new event

4. In Main component controller : 
    --> passed the new attribute unlimrowindex for special conditions handle method handleSpecialApplicationEvent


//problem ::: conditions tab
