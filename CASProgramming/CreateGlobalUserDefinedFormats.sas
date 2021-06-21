/**
This example creates some example formats in SAS, then loads those formats to a CAS format library
and promotes them for global use.

Once the format is promoted for global use, it can be used in other sessions, including Visual Analytics

**/

/* First we set up our CAS connection */
cas casauto;
caslib _ALL_ assign;

/* These proc format steps create the SAS format catalogs that we will then push to CAS */
proc format library=work.genfmts;
   value $codes
      "A" = "Alpha"
      "B" = "Beta"
      "C" = "Charlie"
      "D" = "Delta";
   value response
      1 = "Yes"
      2 = "No"
      3 = "Undecided"
      4 = "No response";
   value MPGrating
      34  - HIGH = "Excellent"
      24  -< 34  = "Good"
      19  -< 24  = "Fair"
      LOW -< 19  = "Poor";
run;

proc format library=work.mailfmts;
   value $officeCodes
      "CHI" = "Chicago"
      "NYC" = "New York"
      "ATL" = "Atlanta"
      "CUP" = "Cupertino";
   value $regionCodes
      "E" = "East"
      "W" = "West"
      "N" = "North"
      "S" = "South";
run;

/* put our loading process into a macro for re-usability */
%macro loadfmtCAS(lib, catname);

   /* First, we convert the format catalog into a SAS table */
   proc format library=&lib..&catname. cntlout=&lib..&catname.;
   run;
   
   /* optional - check the contents of the table */
   proc print data=&lib..&catname.;
      var FMTNAME START END LABEL;
   run;
   
   /* this writes the sas format table to a cas format library for the session */
   proc format cntlin=&lib..&catname. casfmtlib="&catname." 
       sessref=casauto;  
   run;
   
   /* optional - check the contents of the cas format library */
   cas casauto listformat fmtlibname="&catname."     
      members;

   /* Save and promote the format library so it can be used globally by all CAS sessions */
   cas casauto savefmtlib fmtlibname=&catname.       
      caslib=formats table=&catname. replace promote;
   
%mend;

/* run the macro for each format catalog we want to load */
%loadfmtCAS(work, genfmts);
%loadfmtCAS(work, mailfmts);
