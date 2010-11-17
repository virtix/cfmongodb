
<!--- create the mongo objects --->
<cfset variables.dbName = "cfmongodb_benchmarks">
<cfinclude template="initMongo.cfm">
<cfset mongoUtil = mongo.getMongoUtil()>
<cfscript>

	serverName = server.coldfusion.productname & "_" & server.coldfusion.productversion;

	//we'll create/use a 'people' collection
	collection = "datadump";
	metricColl = "metrics";

	dataCreateStart = getTickCount();
	coolPeople = [];
	totalDocs = 1000;
	for( i = 1; i LTE totalDocs; i++ ){
		DOC =
		{
			NAME = "Cool Dude #i#",
			WIFE = "Smokin hot wife #i#",
			KIDS = [
					{NAME="kid #i#", age=randRange(1,80), hair="strawberry", description="fun" },
					{NAME="kid #i+1#", age=randRange(1,80), hair="raven", description="joyful" }
			],
			BIKE = "Specialized",
			TS = now(),
			COUNTER = i,
			MONGOROCKS = true,
			PRODUCT = serverName
		};
		arrayAppend( coolPeople, doc );
	}
	dataCreateTotal = getTickCount() - dataCreateStart;

	saveStart = getTickCount();

	mongo.saveAll( coolPeople, collection );

	saveTotal = getTickCount() - saveStart;

	stat = { DATATOTAL=dataCreateTotal, SAVETOTAL=saveTotal, COUNT=totalDocs, SAVETYPE='structs', USEJL=url.useJavaLoader, PRODUCT=serverName };
	mongo.save( stat, metricColl );


	dataCreateStart = getTickCount();
	coolPeople = [];
	for( i = 1; i LTE totalDocs; i++ ){
		DOC =
		{
			NAME = "Cool Dude #i#",
			WIFE = "Smokin hot wife #i#",
			KIDS = [
					{NAME="kid #i#", age=randRange(1,80), hair="strawberry", description="fun" },
					{NAME="kid #i+1#", age=randRange(1,80), hair="raven", description="joyful" }
			],
			BIKE = "Specialized",
			TS = now(),
			COUNTER = i,
			MONGOROCKS = true,
			PRODUCT = serverName
		};
		arrayAppend( coolPeople, mongoUtil.toMongo(doc) );
	}

	dataCreateTotal = getTickCount() - dataCreateStart;

	saveStart = getTickCount();

	mongo.saveAll( coolPeople, collection );

	saveTotal = getTickCount() - saveStart;

	stat = { DATATOTAL=dataCreateTotal, SAVETOTAL=saveTotal, COUNT=totalDocs, SAVETYPE='dbos', USEJL=url.useJavaLoader, PRODUCT=serverName };
	mongo.save( stat, metricColl );










</cfscript>
