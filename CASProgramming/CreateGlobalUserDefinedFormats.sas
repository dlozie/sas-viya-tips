/**
This example creates some example formats in SAS, then loads those formats to a CAS format library
and promotes them for global use.

Once the format is promoted for global use, it can be used in other sessions, including Visual Analytics

**/

cas casauto;
caslib _ALL_ assign;
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

%macro loadfmtCAS(lib, catname);
proc format library=&lib..&catname. cntlout=&lib..&catname.;        /* 3 */
run;

proc print data=&lib..&catname.;                            /* 4 */
   var FMTNAME START END LABEL;
run;

proc format cntlin=&lib..&catname. casfmtlib="&catname."          /* 5 */
    sessref=casauto;  
run;
cas casauto listformat fmtlibname="&catname."     
   members;
cas casauto savefmtlib fmtlibname=&catname.       
   caslib=formats table=&catname. replace promote;
%mend;

%loadfmtCAS(work, genfmts);
%loadfmtCAS(work, mailfmts);
