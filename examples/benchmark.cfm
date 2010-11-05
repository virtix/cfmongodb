
<!--- pass 'false' in the URL to use the mongo jars in your cfusion lib directory --->
<cfparam name="url.useJavaLoader" default="true">

<cfscript>

	serverName = server.coldfusion.productname & "_" & server.coldfusion.productversion;

	if( url.useJavaLoader ){
		javaloaderFactory = createObject('component','cfmongodb.core.JavaloaderFactory').init();
		mongoConfig = createObject('component','cfmongodb.core.MongoConfig').init(dbName="cfmongodb_benchmarks", mongoFactory=javaloaderFactory);
	}
	else
	{
		mongoConfig = createObject('component','cfmongodb.core.MongoConfig').init(dbName="cfmongodb_benchmarks");
	}
	mongo = createObject('component','cfmongodb.core.Mongo').init(mongoConfig);
	mongoUtil = mongo.getMongoUtil();

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
