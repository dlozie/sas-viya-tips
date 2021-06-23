
/* Assign a fileref to the folder that we want to read and write from in the file service */
filename code filesrvc folderpath="/Public";

/* create a file in the folder, and write some code to it */
Data _NULL_;
	file code(cars.sas);
	infile datalines4;
	input;
	put _infile_;
datalines4;
proc print data=sashelp.cars;
run;
;;;;

/* read the code from the file and write to the log*/
Data _NULL_;
	infile code(cars.sas);
	input;
	put _infile_;
run;

/* include the code for execution */
%include code(cars.sas);

/* assign a fileref directly to the file, and write the file URI to the log */
filename cars filesrvc folderpath="/Public" filename="cars.sas";
%put &_FILESRVC_cars_URI;
