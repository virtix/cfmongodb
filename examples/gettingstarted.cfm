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
			SPOUSE = "Heather",
			KIDS = [
				{NAME="Alexis", AGE=7, HAIR="blonde", DESCRIPTION="crazy" },
				{NAME="Sidney", AGE=2, HAIR="dirty blonde", DESCRIPTION="ornery" }
			],
			BIKE = "Felt",
			LOVESSQL = true,
			LOVESMONGO = true,
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
			NAME = "Cool Person #i#",
			SPOUSE = "Cool Spouse #i#",
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

	//find the 3rd and 4th Specialized bike riders, sorted by "ts" descending
	specialized = mongo.query( collection ).$eq("BIKE", "Specialized").search( skip=2, limit=2, sort="TS=-1" );
	showResult( specialized, "Specialized riders, skipping to 3, limiting to 2, sorting by ts desc (skip is 0-based!)" );

	//find riders with counter between 1 and 3, sorted by "ts" descending
	specialized = mongo.query( collection )
						.$eq("BIKE", "Specialized")
						.between("COUNTER", 1, 3)
						.search( sort="TS=-1" );
	showResult( specialized, "Specialized riders, COUNTER between 1 and 3" );

	//find riders with counter between 1 and 3 Exclusive, sorted by "ts" descending
	specialized = mongo.query( collection )
						.$eq("BIKE", "Specialized")
						.betweenExclusive("COUNTER", 1, 3)
						.search( sort="TS=-1" );
	showResult( specialized, "Specialized riders, COUNTER between 1 and 3 Exclusive" );

	//find people with kids aged between 2 and 30
	kidSearch = mongo.query( collection ).between("KIDS.AGE", 2, 30).search(keys="NAME,COUNTER,KIDS", sort="COUNTER=-1");
	showResult( kidSearch, "People with kids aged between 2 and 30" );


	//find a document by ObjectID... note that it returns the document, NOT a SearchResult object; here, we'll "spoof" what your app would do if the id were in the URL scope
	url.personId = specialized.asArray()[1]["_id"].toString();

	byID = mongo.findById( url.personId, collection );
	writeOutput("<h2>Find by ID</h2>");
	writeDump(var=byID, label="Find by ID: #url.personID#", expand="false");

	//here's how to update. You'll generally do two kinds of updating:
	// 1) updating a single pre-fetched document... this is the most common. It's a find/modify/resave
	// 2) updating one or more documents based on criteria. You almost always need to use a $set in this situation!!!

	//updating a single pre-fetched document
	person = mongo.query( collection ).search(limit="1").asArray()[1];
	person.FAVORITECIGAR = "H. Upmann Cubano";
	person.MODTS = now();
	arrayAppend( person.KIDS, {NAME = "Pauly", AGE = 0} );
	mongo.update( person, collection );

	writeOutput("<h2>Updated Person</h2>");
	writeDump( var=person, label="updated person", expand="false");

	//updating a single document. by default it'll wrap the "doc" arg in "$set" as a convenience
	person = {NAME = "Ima PHP dev", AGE=12};
	mongo.save( person, collection );

	mongo.update( doc={NAME = "Ima CF Dev", HAPPY = true}, query= {NAME = "Ima PHP dev"}, collectionName = collection );
	afterUpdate = mongo.findById( person["_id"], collection );

	writeOutput("<h2>Updated person by criteria</h2>");
	writeDump(var = person, label="Original", expand=false);
	writeDump(var = afterUpdate, label = "After update", expand=false);

	//updating a single document based on criteria and overwriting instead of updating
	person = {NAME = "Ima PHP dev", AGE=12};
	mongo.save( person, collection );

	mongo.update( doc={NAME = "Ima CF Dev", HAPPY = true}, query= {NAME = "Ima PHP dev"}, overwriteExisting = true, collectionName = collection );
	afterUpdate = mongo.findById( person["_id"], collection );

	writeOutput("<h2>Updated person by criteria. Notice it OVERWROTE the entire document</h2>");
	writeDump(var = person, label="Original", expand=false);
	writeDump(var = afterUpdate, label = "After update without using $set", expand=false);


	//updating multiple documents
	mongo.saveAll(
		[{NAME = "EmoHipster", AGE=16},
		{NAME = "EmoHipster", AGE=15},
		{NAME = "EmoHipster", AGE=18}],
		collection
	);

	mongo.update( doc = {NAME = "Oldster", AGE=76, REALIZED="tempus fugit"}, query = {NAME = "EmoHipster"}, multi=true, collectionName = collection );

	oldsters = mongo.query( collection ).$eq("NAME","Oldster").search().asArray();

	writeOutput("<h2>Updating multiple documents</h2>");
	writeDump( var=oldsters, label="Even EmoHipsters get old some day", expand="false");

	//perform an $inc update
	cast = [{NAME = "Wesley", LIFELEFT=50, TORTUREMACHINE=true},
		{NAME = "Spaniard", LIFELEFT=42, TORTUREMACHINE=false},
		{NAME = "Giant", LIFELEFT=6, TORTUREMACHINE=false},
		{NAME = "Poor Forest Walker", LIFELEFT=60, TORTUREMACHINE=true}];
	
	mongo.saveAll( cast, collection	);

	suckLifeOut = {"$inc" = {LIFELEFT = -1}}; 
	victims = {TORTUREMACHINE = true};
	mongo.update( doc = suckLifeOut, query = victims, multi = true, collectionName = collection );
	
	rugenVictims = mongo.query( collection ).$eq("TORTUREMACHINE", true).search().asArray();
	
	writeOutput("<h2>Atomically incrementing with $inc</h2>");
	writeDump( var = cast, label="Before the movie started", expand=false);
	writeDump( var = rugenVictims, label="Instead of sucking water, I'm sucking life", expand=false);

	//findAndModify: Great for Queuing!
	//insert docs into a work queue; find the first 'pending' one and modify it to 'running'
	mongo.remove( {}, "tasks" );
	jobs = [
		{STATUS = 'P', N = 1, DATA = 'Let it be'},
		{STATUS = 'P', N = 2, DATA = 'Hey Jude!'},
		{STATUS = 'P', N = 3, DATA = 'Ebony and Ivory'},
		{STATUS = 'P', N = 4, DATA = 'Bang your head'}
	];
	mongo.saveAll( jobs, "tasks" );

	query = {STATUS = 'P'};
	update = {STATUS = 'R', started = now(), owner = cgi.server_name};

	nowScheduled = mongo.findAndModify( query = query, update = update,
										sort = "N", collectionName = "tasks" );

	writeOutput("<h2>findAndModify()</h2>");
	writeDump(var=nowScheduled, label="findAndModify", expand="false");

	writeOutput("<h2>Indexes</h2>");
	//here's how to add indexes onto collections for faster querying
	mongo.ensureIndex( ["NAME"], collection );
	mongo.ensureIndex( ["BIKE"], collection );
	mongo.ensureIndex( ["KIDS.AGE"], collection );
	writeDump(var=mongo.getIndexes(collection), label="Indexes", expand="false");



	//show how you get timestamp creation on all documents, for free, when using the default ObjectID
	mongoUtil = mongo.getMongoUtil();
	all = mongo.query( collection ).search().asArray();
	first = all[1];
	last = all[ arrayLen(all) ];
	writeOutput("<h2>Timestamps from Doc</h2>");
	writeOutput("Timestamp on first doc: #first['_id'].getTime()# = #mongoUtil.getDateFromDoc(first)#   <br>");
	writeOutput("Timestamp on last doc: #last['_id'].getTime()# = #mongoUtil.getDateFromDoc(last)#   <br>");

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
