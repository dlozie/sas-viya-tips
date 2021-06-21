# sas-viya-tips
My code snippets and examples for SAS Viya


Some general helpful suggestions:
1.  Write all of your tables to casuser, unless you are explicitly saving/promoting them to a permanent library.  This prevents confusion between whether a table is global or session scope.  All casuser tables will be session scope, and all others will be global.
