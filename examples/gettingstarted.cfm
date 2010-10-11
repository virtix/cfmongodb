<style>
*{
	font-family: sans-serif;
}
h2{
	color: navy;
}
</style>

<cfscript>

	//the fastest way to try out cfmongodb is using Mark Mandel's javaloader, which we ship with cfmongodb. Thanks Mark!
	//http://javaloader.riaforge.org

	//get the MongoDB Java Driver jar, and the CFMongoDB helper jar; cfmongodb ships with both
	jarPaths = directoryList( expandPath("/cfmongodb/lib"), false, "path", "*.jar" );

	//create an instance of javaloader and init it
	javaloader = createObject('component','cfmongodb.lib.javaloader.javaloader').init(jarPaths);

	//use the cfmongodb javaloader factory
	javaloaderFactory = createObject('component','cfmongodb.core.JavaloaderFactory').init(javaloader);

	//create a default MongoConfig instance; in your real apps, you'll create an object that extends MongoConfig and put your environment specific config in there
	//here we initialize it with a db named 'mongorocks'
	mongoConfig = createObject('component','cfmongodb.core.MongoConfig').init(db_name="mongorocks");

	//initialize the core cfmongodb Mongo object
	mongo = createObject('component','cfmongodb.core.Mongo').init(mongoConfig, javaloaderFactory);

	//insert some documents into the 'people' collection
	collection = "people";

	//clear out the collection so we always start fresh, for demo purposes
	mongo.remove({},collection);


	//here's how to insert one object
	doc =
		{
			name = "Marc",
			wife = "Heather",
			kids = [
				{name="Alexis", age=7, hair="blonde", description="crazy" },
				{name="Sidney", age=2, hair="dirty blonde", description="ornery" }
			],
			bike = "Felt",
			lovessql = true,
			lovesmongo=true,
			ts = now(),
			counter = 1
		};

	mongo.save( doc, collection );
	writeDump( var=doc, label="Saved document", expand="false" );
	//here's how to insert multiple
	coolPeople = [];
	for( i = 1; i LTE 5; i++ ){
		doc =
		{
			name = "Cool Dude #i#",
			wife = "Smokin hot wife #i#",
			kids = [
					{name="kid #i#", age=randRange(1,80), hair="strawberry", description="fun" },
					{name="kid #i+1#", age=randRange(1,80), hair="raven", description="joyful" }
			],
			bike = "Specialized",
			ts = now(),
			counter = i
		};
		sleep(5);//to give our ts some space
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


	function showResult( searchResult, label ){
		writeOutput("<h2>#label#</h2>");
		writeDump( var=searchResult.asArray(), label=label, expand="false" );
		writeOutput( "<br>Total #label# in this result, accounting for skip and limit: " & searchResult.size() );
		writeOutput( "<br>Total #label#, ignoring skip and limit: " & searchResult.totalCount() );
		writeOutput( "<br>Query: " & searchResult.getQuery().toString() );
		writeOutput( "<br>Sort: " & searchResult.getSort().toString() );
	}

</cfscript>