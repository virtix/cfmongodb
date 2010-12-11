<cfinclude template="../initMongo.cfm">

<cfscript>
	collectionName = "tasks";
	collection = mongo.getMongoDBCollection(collectionName);
	mongoUtil = mongo.getMongoUtil();
	keys = mongoUtil.toMongo( {STATUS=true} );
	initial = mongoUtil.toMongo( {TOTAL=0, VALS=[]} );
	writeDump(initial.toString());
	emptyCondition = mongoUtil.toMongo({});

	statusGroups = collection.group(
          	keys,
			emptyCondition,
		   	initial,
           	"function(obj,agg) {
				agg.TOTAL++;
				//agg.VALS.push(obj); //uncomment this to see all the objects that came through here; warning, this will add a lot of time to the writeDump
			}"
     );

	for( g in statusGroups ){
		writeOutput("<br>Group: #g.STATUS#; Total: #g.TOTAL# ");
	}

	writeDump(var=statusGroups,label="Status Groups");

	mongo.close();
</cfscript>

