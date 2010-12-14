<cfparam name="forceLoad" default="false">
<cfinclude template="../initMongo.cfm">

<cfscript>
	collection = "geoexamples";
	total = mongo.query( collection ).count();

	if( total eq 0 OR forceLoad ){
		mongo.remove( {}, collection );
		rows = deserializeJson( fileRead(expandPath('geo.json')) );
		mongo.saveAll( rows, collection );
	}

	mongo.close();
</cfscript>
