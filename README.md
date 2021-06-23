# sas-viya-tips
My code snippets and examples for SAS Viya - targeted at SAS 9 programmers


Some general helpful suggestions:
1.  When working in CAS, write all of your tables to casuser, unless you are explicitly saving/promoting them to a permanent library.  This prevents confusion between whether a table is global or session scope.  All casuser tables will be session scope, and all others will be global.
2.  Avoid using any filesystem paths for storing code files, etc.  Instead, use the Files Service as this is agnostic across environments, architectures, etc.
3.  Avoid moving large datasets between CAS and your SAS libraries.  Doing so is slow and becomes a performance bottleneck.  Instead, if the data is in CAS, keep it there and process in place.  This may mean code changes, but it's generally worth it.
