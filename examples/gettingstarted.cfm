<style>
*{
	font-family: sans-serif;
}
h2{
	color: navy;
}
</style>

<!--- pass 'false' in the URL to use the mongo jars in your cfusion lib directory --->
<cfparam name="url.useJavaLoader" default="true">

<cfscript>

	if( url.useJavaLoader ){
		//the fastest way to try out cfmongodb is using Mark Mandel's javaloader, which we ship with cfmongodb. Thanks Mark!
		//http://javaloader.riaforge.org

		//use the cfmongodb javaloader factory
		javaloaderFactory = createObject('component','cfmongodb.core.JavaloaderFactory').init();

		//create a default MongoConfig instance; in your real apps, you'll create an object that extends MongoConfig and put your environment specific config in there
		//here we initialize it with a db named 'mongorocks'
		mongoConfig = createObject('component','cfmongodb.core.MongoConfig').init(dbName="mongorocks", mongoFactory=javaloaderFactory);
	}
	else
	{
		mongoConfig = createObject('component','cfmongodb.core.MongoConfig').init(dbName="mongorocks");
	}

	//initialize the core cfmongodb Mongo object
	mongo = createObject('component','cfmongodb.core.Mongo').init(mongoConfig);

	//we'll create/use a 'people' collection
	collection = "people";

	//clear out the collection so we always start fresh, for demo purposes
	mongo.remove({},collection);


	//here's how to insert one document
	doc =
		{
			NAME = "Marc",
			WIFE = "Heather",
			KIDS = [
				{NAME="Alexis", AGE=7, HAIR="blonde", DESCRIPTION="crazy" },
				{NAME="Sidney", AGE=2, HAIR="dirty blonde", DESCRIPTION="ornery" }
			],
			BIKE = "Felt",
			LOVESSQL = true,
			LOVESMONGO=true,
			TS = now(),
			COUNTER = 1
		};

	mongo.save( doc, collection );
	writeDump( var=doc, label="Saved document", expand="false" );

	/*
	* VERY IMPORTANT: ColdFusion will automatically uppercase struct keys if you do not quote them. Consequently, the document will be stored
	* in MongoDB with upper case keys. Below, where we search, we MUST use uppercase keys.
	*
	* at the shell, mongo.find({name:'Marc'}) != mongo.find({NAME: 'Marc'})
	*/



	//here's how to insert multiple documents
	coolPeople = [];
	for( i = 1; i LTE 5; i++ ){
		DOC =
		{
			NAME = "Cool Dude #i#",
			WIFE = "Smokin hot wife #i#",
			KIDS = [
					{NAME="kid #i#", age=randRange(1,80), HAIR="strawberry", DESCRIPTION="fun" },
					{NAME="kid #i+1#", age=randRange(1,80), HAIR="raven", DESCRIPTION="joyful" }
			],
			BIKE = "Specialized",
			TS = now(),
			COUNTER = i
		};
		arrayAppend( coolPeople, doc );
	}

	mongo.saveAll( coolPeople, collection );

	//find Marc
	marc = mongo.query( collection ).$eq("NAME", "Marc").search();
	showResult( marc, "Marcs" );


	//find riders of Specialized bikes
	specialized = mongo.query( collection ).$eq("BIKE", "Specialized").search();
	showResult( specialized, "Specialized riders" );

	//find the 2nd and 3rd Specialized bike riders, sorted by "ts" descending
	specialized = mongo.query( collection ).$eq("BIKE", "Specialized").search( skip=2, limit=2, sort="TS=-1" );
	showResult( specialized, "Specialized riders, skipping to 2, limiting to 2, sorting by ts desc (skip is 0-based!)" );

	//find riders with counter between 1 and 3, sorted by "ts" descending
	specialized = mongo.query( collection ).between("COUNTER", 1, 3).search( sort="TS=-1" );
	showResult( specialized, "Specialized riders, COUNTER between 1 and 3" );

	//find riders with counter between 1 and 3 Exclusive, sorted by "ts" descending
	specialized = mongo.query( collection ).betweenExclusive("COUNTER", 1, 3).search( sort="TS=-1" );
	showResult( specialized, "Specialized riders, COUNTER between 1 and 3 Exclusive" );

	//find people with kids aged between 2 and 30
	kidSearch = mongo.query( collection ).between("KIDS.AGE", 2, 30).search(keys="NAME,COUNTER,KIDS", sort="COUNTER=-1");
	showResult( kidSearch, "People with kids aged between 2 and 30" );

	//show how you get timestamp creation on all documents, for free, when using the default ObjectID
	mongoUtil = mongo.getMongoUtil();
	all = mongo.query( collection ).search().asArray();
	first = all[1];
	last = all[ arrayLen(all) ];
	writeOutput("Timestamp on first doc: #first['_id'].getTime()# = #mongoUtil.getDateFromDoc(first)#   <br>");
	writeOutput("Timestamp on first doc: #last['_id'].getTime()# = #mongoUtil.getDateFromDoc(last)#   <br>");
writeoutput(first["_id"].toString());
	//close the Mongo instance. Very important!
	mongo.close();


	function showResult( searchResult, label ){
		writeOutput("<h2>#label#</h2>");
		writeDump( var=searchResult.asArray(), label=label, expand="false" );
		writeOutput( "<br>Total #label# in this result, accounting for skip and limit: " & searchResult.size() );
		writeOutput( "<br>Total #label#, ignoring skip and limit: " & searchResult.totalCount() );
		writeOutput( "<br>Query: " & searchResult.getQuery().toString() );
		writeOutput( "<br>Sort: " & searchResult.getSort().toString() & "<br>");
	}

</cfscript>
