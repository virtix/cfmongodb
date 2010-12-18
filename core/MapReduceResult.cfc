component accessors="true"{

	property name="dbCommand";
	property name="commandResult";
	property name="searchResult";

	/**
	* Initializes and the result object.

	  Use getdbCommand() to see all the parameters passed to mapReduce

	  Use getCommandResult() to see a struct representation of the mapReduce result. This includes counts and timing information
	*/
	function init( dbCommand, commandResult, searchResult, mongoUtil ){
		variables.mongoUtil = arguments.mongoUtil;
		variables.searchResult = arguments.searchResult;
		variables.dbCommand = mongoUtil.toCF(arguments.dbCommand);
		variables.commandResult = mongoUtil.toCF(arguments.commandResult);
		return this;
	}

	/**
	* Returns the name of the resultant MapReduce collection
	*/
	function getMapReduceCollectionName(){
		return commandResult.result;
	}

	/**
	*  The fastest return type... returns the case-sensitive cursor which you'd iterate over with
	   while(cursor.hasNext()) {cursor.next();}

	   Note: you can use the cursor object to get full access to the full API at http://api.mongodb.org/java
	*/
	function asCursor(){
		return searchResult.asCursor();
	}

	/**
	* Converts all cursor elements into a ColdFusion structure and returns them as an array of structs.
	*/
	function asArray(){
		return searchResult.asArray();
	}

	/**
	* The number of elements in the current SearchResult, after limit and skip are applied.
	  Note that skip and limit would only be relevant when performing additional searches against the temporary
	  MapReduce collection and setting that SeachResult into the MapReduceResult via mapReduceResult.setSearchResult( searchResult );
	*/
	function size(){
		return searchResult.size();
	}

	/**
	* The total number of elements in the SearchResult.
	*/
	function totalCount(){
		return searchResult.totalCount();
	}

	/**
	* The criteria used for the query.
	  Note that a query other than '{}' would only be returned when performing additional searches against the temporary
	  MapReduce collection and setting that SeachResult into the MapReduceResult via mapReduceResult.setSearchResult( searchResult );

	  Use getQuery().toString() to get a copy/paste string for the Mongo shell
	*/
	function getQuery(){
		return searchResult.getQuery();
	}

	/**
	* The sort used for the query.
	  Note that a sort other than '{}' would only be returned when performing additional searches against the temporary
	  MapReduce collection and setting that SeachResult into the MapReduceResult via mapReduceResult.setSearchResult( searchResult );

	  Use getSort().toString() to get a copy/paste string for the Mongo shell
	*/
	function getSort(){
		return searchResult.getSort();
	}
}
