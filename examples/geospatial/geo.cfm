<!---run load.cfm to get the data that these will use! --->
<!--- pass forceLoad=true in the URL to force new data --->
<cfinclude template="load.cfm">

<cfinclude template="../initMongo.cfm">

<cfscript>
	collection = "geoexamples";

	try {
		//only need to do this once, but here for illustration
		indexes = mongo.ensureGeoIndex("LOC", collection);
		writeDump(indexes);

		//as of this writing, you can perform geo queries like so:
		nearResult = mongo.query( collection ).add( "LOC", {"$near" = [38,-85]} ).search(limit=10);
		writeDump( var = nearResult.asArray(), label = "$near result" );
	}
		catch(Any e){
		writeDump(e);
	}

	mongo.close();
</cfscript>
