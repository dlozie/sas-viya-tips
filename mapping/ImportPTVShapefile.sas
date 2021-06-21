/**
This example imports an ESRI shapefile that I downloaded from 
https://discover.data.vic.gov.au/dataset/ptv-metro-train-stations

It then creates a bunch of random location records in Melbourne, 
calculates the distance to the nearest train station, and only keeps records
that are within 500m of a train station

The imported shapefile can be used as a custom polygon provider for geo maps in VA,
and the location records overlayed.

Note - you need to upload the .shp, .shx, and .dbf files together in the same folder on the server
filesystem before running this

**/

cas;
caslib _all_ assign;

%shpimprt(
	shapefilepath=~/ptv_metro_train_station.shp,
	id=stop_id, 
	outtable=ptv_train_shp,
	caslib='Public',
	cashost = localhost,
	casport=5570);

proc fcmp outlib=work.funcs.geo;
	subroutine getStation(lat, long, stop_id $, distance);
		outargs stop_id, distance;
		declare hash h (dataset:"public.ptv_train_shp");
		declare hiter iter('h');
		rc = h.definekey('stop_id');
		rc = h.definedata('stop_id', 'latitude', 'longitude');
		rc = h.definedone();

		rc = iter.first();
		do while (rc = 0);
		   distance = geodist(lat, long, latitude, longitude);
		   if distance < 0.5 then
		      return;
		   rc = iter.next();
		end;
		stop_id=0;
		return;
	endsub;
run;
quit;

options cmplib=work.funcs;
Data public.stationIncident (promote=yes);
	length stop_id $6;
	Do id = 1 to 10000;
		lat = rand('UNIFORM', -38.1,-37.6);
		long = rand('UNIFORM', 144.8, 145.2);
		call getStation(lat, long, stop_id, distance);
		if stop_id ^=0 then output;
	end;
run;
