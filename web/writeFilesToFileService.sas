/**
This example shows how we can make use of the sas viya file service
for serving web content to support web pages (Job Execution Forms, etc.)

**/

/* This first section before the macro is just an example of downloading a file
Alternatively, You can just upload the file through SAS Studio */

/* create a fileref pointing to a public CDN for jquery */
filename jq url 'https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js' lrecl=1000000;

/* create a local fileref for copying in the  file */
filename out '~/jquery.min.js' lrecl=1000000;

/* Copy the js file to the local filesystem on the server. */
Data _null_;
	rc = fcopy('jq','out');
	msg=sysmsg();
	put rc=;
	put msg=;
run;

/* 

This macro uploads the file from the server filesystem to the SAS Viya file service,
and applies a specified MIME type so that it can be referenced from within a web page.
In distributed or containerised environments, this is required as the filesystem is not
re-used between SAS sessions
*/

%macro webin(filename, mimetype, lrecl=1000000);
filename in clear;
filename in "~/&filename." lrecl=&lrecl;
filename out clear;
filename out filesrvc folderpath="/Public/web" filename="&filename" contenttype="&mimetype" lrecl=&lrecl;

Data _null_;
	rc = fcopy('in' , 'out'); 
	msg=sysmsg();
	put rc=;
	put msg=;
run;
%mend;

%webin(jquery.min.js, application/javascript);
