<cfinclude template="../initMongo.cfm">


<cfscript>
	u = mongo.getMongoUtil();

	map = "
		function(){
			emit(this.STATUS, 1);
		}
	";

	reduce = "
		function(key, emits){
			var total = 0;
			for( var i in emits ){
				total += emits[i];
			}
			return total;
		}
	";

	//does nothing... here simply to show how you would pass a finalize function using dbCommand, which you couldn't do with the basic Java mapReduce signature
	finalize = "function( key, value ){}";

	//#1: try it using a command instead of the driver's mapReduce function
	//have to use the "ordered" stuff here because if we do straight struct creation, CF will order them
	//indeterminantly. MongoDB, for whatever reason, uses the first key as the command name (as opposed to "command" = "mapreduce", which would be infinitely more sensible)
	dbCommand = u.createOrderedDBObject( [ {"mapreduce"="tasks"}, {"map"=map}, {"reduce"=reduce}, {"finalize"=finalize} ] );
	result = mongo.getMongoDB().command( dbCommand );
	writeDump(result);
	//now use a normal cfmongodb query to search the tmp collection created by mapreduce
	searchResult = mongo.query(result["result"]).search();
	writeDump(searchResult.asArray());


	//#2: now use the java driver's minimal signature
	jResult = mongo.getMongoDBCollection("tasks").mapReduce(map, reduce, javacast("null",""),javacast("null",""));
	writeDump(jResult);

	//use a little trick... fill up a SearchResult object with this M/R's cursor
	mrSearchResult = createObject("cfmongodb.core.SearchResult").init(jResult.results(),{},u);
	writeDump(mrSearchResult.asArray());

	//#3: now use the java driver's smaller but more flexible signature, which takes a Command, letting you pass in all the stuff that you could pass from the shell
	jResult2 = mongo.getMongoDBCollection("tasks").mapReduce( dbCommand );
	writedump(jResult2);
	mrSearchResult = createObject("cfmongodb.core.SearchResult").init(jResult2.results(),{},u);
	writeDump(mrSearchResult.asArray());
</cfscript>

<cfset mongo.close()>
