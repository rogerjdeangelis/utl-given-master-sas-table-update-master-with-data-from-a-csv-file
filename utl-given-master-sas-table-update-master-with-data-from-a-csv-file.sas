Giiven master sas table update it with data from a csv file                                                                
                                                                                                                           
github                                                                                                                     
https://tinyurl.com/y4melofy                                                                                               
https://github.com/rogerjdeangelis/utl-given-master-sas-table-update-master-with-data-from-a-csv-file                      
                                                                                                                           
SAS-L                                                                                                                      
https://listserv.uga.edu/cgi-bin/wa?A2=SAS-L;2bb6b75e.1909b                                                                
                                                                                                                           
You need a template for the csv files (COBOL copy book or record layout.                                                   
                                                                                                                           
This is not as simple as you might think.                                                                                  
                                                                                                                           
   1. I assume the master is a SAS table                                                                                   
   2. What do you do with transaction non-matches                                                                          
      (I do not add transaction records not in master)                                                                     
   3. I replace the entire observation on a match                                                                          
   4. I assume master is indexed on key.                                                                                   
   5. Transaction is unique on key.                                                                                        
   6. Variables on transaction are same name, lenght and type as master 
   Recent comments                                                                               
       
Recent Comments       
       
I also don't think it possible with update, looping through the master dups is probelmsome.   
                                                                                              
I just found this.                                                                            
                                                                                              
http://support.sas.com/kb/24/786.html                                                         
                                                                                              
I don't think you need an index on the transaction, but I would index and sort the master.    
                                                                                              
My 'set point' seems to overwrite all the variables in the master. Whereas the SAS            
solution seems to require a rename and manual coding for each variable.                       
                                                                                              
Updating and modifying in place can be very tricky.                                           
                                                                                              
                                                                                              

*_                   _                                                                                                     
(_)_ __  _ __  _   _| |_                                                                                                   
| | '_ \| '_ \| | | | __|                                                                                                  
| | | | | |_) | |_| | |_                                                                                                   
|_|_| |_| .__/ \__,_|\__|                                                                                                  
        |_|                                                                                                                
;                                                                                                                          
                                                                                                                           
data master;                                                                                                               
  set sashelp.class(obs=5 keep=name sex age);                                                                              
  output;                                                                                                                  
  if _n_=3 then do; sex='X'; output; end;                                                                                  
  if _n_=2 then do;age=.;    output; end;                                                                                  
run;quit;                                                                                                                  
                                                                                                                           
                                                                                                                           
 WORK.MASTER total obs=7                                                                                                   
                                                                                                                           
   NAME      SEX    AGE                                                                                                    
                                                                                                                           
  Alfred      M      14                                                                                                    
  Alice       F      13                                                                                                    
  Alice       F       .   ** update age                                                                                    
  Barbara     F      13                                                                                                    
  Barbara     X      13   ** update sex                                                                                    
  Carol       F      14                                                                                                    
  Henry       M      14                                                                                                    
                                                                                                                           
*                 _                       _       _                                                                        
  ___ _____   __ | |_ ___ _ __ ___  _ __ | | __ _| |_ ___                                                                  
 / __/ __\ \ / / | __/ _ \ '_ ` _ \| '_ \| |/ _` | __/ _ \                                                                 
| (__\__ \\ V /  | ||  __/ | | | | | |_) | | (_| | ||  __/                                                                 
 \___|___/ \_/    \__\___|_| |_| |_| .__/|_|\__,_|\__\___|                                                                 
                                   |_|                                                                                     
;                                                                                                                          
                                                                                                                           
Template (you need this to hanle length and type issues)                                                                   
                                                                                                                           
  infile "c:/csv/transaction.csv" delimiter=",";                                                                           
  input name $7. sex $1. age 3.;                                                                                           
                                                                                                                           
*                 _                                                                                                        
  ___ _____   __ | |_ _ __ __ _ _ __  ___                                                                                  
 / __/ __\ \ / / | __| '__/ _` | '_ \/ __|                                                                                 
| (__\__ \\ V /  | |_| | | (_| | | | \__ \                                                                                 
 \___|___/ \_/    \__|_|  \__,_|_| |_|___/                                                                                 
                                                                                                                           
;                                                                                                                          
                                                                                                                           
data _null_;                                                                                                               
                                                                                                                           
  set sashelp.class(obs=4 keep=name sex age);                                                                              
                                                                                                                           
  file "d:/csv/transaction.csv";                                                                                           
  if name in ( 'Alice', 'Barbara', 'Alfred') then put (_all_) ($ +(-1)  ',' );                                             
  else do; name='Suki'; put (_all_) ($ +(-1)  ',' ); end;                                                                  
                                                                                                                           
run;quit;                                                                                                                  
                                                                                                                           
c:/csv/transaction.csv                                                                                                     
                                                                                                                           
Alfred,M,14,69,112.5                                                                                                       
Alice,F,13,56.5,84                                                                                                         
Barbara,F,13,65.3,98                                                                                                       
Suki,F,14,62.8,102.5                                                                                                       
                                                                                                                           
*            _               _                                                                                             
  ___  _   _| |_ _ __  _   _| |_                                                                                           
 / _ \| | | | __| '_ \| | | | __|                                                                                          
| (_) | |_| | |_| |_) | |_| | |_                                                                                           
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                          
                |_|                                                                                                        
;                                                                                                                          
                                                                                                                           
Up to 40 obs from MASTER total obs=7                                                                                       
                                                                                                                           
Obs     NAME      SEX    AGE                                                                                               
                                                                                                                           
 1     Alfred      M      14                                                                                               
 2     Alice       F      13                                                                                               
 3     Alice       F      13                                                                                               
 4     Barbara     F      13                                                                                               
 5     Barbara     F      13                                                                                               
 6     Carol       F      14                                                                                               
 7     Henry       M      14                                                                                               
                                                                                                                           
*                                                                                                                          
 _ __  _ __ ___   ___ ___  ___ ___ ___                                                                                     
| '_ \| '__/ _ \ / __/ _ \/ __/ __/ __|                                                                                    
| |_) | | | (_) | (_|  __/\__ \__ \__ \                                                                                    
| .__/|_|  \___/ \___\___||___/___/___/                                                                                    
|_|                                                                                                                        
;                                                                                                                          
                                                                                                                           
* CREATE TRANSACTION CSV;                                                                                                  
                                                                                                                           
data _null_;                                                                                                               
                                                                                                                           
  set sashelp.class(obs=4 keep=name sex age);                                                                              
                                                                                                                           
  file "d:/csv/transaction.csv";                                                                                           
  if name in ( 'Alice', 'Barbara', 'Alfred') then put (_all_) ($ +(-1)  ',' );                                             
  else do; name='Suki'; put (_all_) ($ +(-1)  ',' ); end;                                                                  
                                                                                                                           
run;quit;                                                                                                                  
                                                                                                                           
* CREATE MASTER TABLE;                                                                                                     
                                                                                                                           
data master(index=(name));                                                                                                 
  set sashelp.class(obs=5 keep=name sex age);                                                                              
  output;                                                                                                                  
  if _n_=3 then do; sex='X'; output; end;                                                                                  
  if _n_=2 then do;age=.;    output; end;                                                                                  
run;quit;                                                                                                                  
                                                                                                                           
* SOLUTION ;                                                                                                               
                                                                                                                           
data master                                                                                                                
;                                                                                                                          
   * convert transaction csv to sas table;                                                                                 
   if _n_=0 then do; %let rc=%sysfunc(dosubl('                                                                             
                                                                                                                           
      data transaction(index=(name/unique));                                                                               
         infile "d:/csv/transaction.csv" delimiter=",";                                                                    
         informat name $8. sex $1. age 3.;                                                                                 
         input name sex age ;                                                                                              
      run;quit;                                                                                                            
                                                                                                                           
      '));                                                                                                                 
   end;                                                                                                                    
                                                                                                                           
   set transaction;                                                                                                        
   pt=_n_;                                                                                                                 
                                                                                                                           
   do until (_iorc_=%sysrc(_dsenom));                                                                                      
                                                                                                                           
        modify master key=name;                                                                                            
                                                                                                                           
        select (_iorc_);                                                                                                   
           when (%sysrc(_sok)) do;                                                                                         
              set transaction point=pt;                                                                                    
              replace master;                                                                                              
           end;                                                                                                            
           when (%sysrc(_dsenom)) do;                                                                                      
             _error_=0;                                                                                                    
             putlog "Nomatch";                                                                                             
           end;                                                                                                            
           otherwise;                                                                                                      
        end;                                                                                                               
                                                                                                                           
   end;                                                                                                                    
run;quit;                                                                                                                  
                                                                                                                           
                                                                                                                           
