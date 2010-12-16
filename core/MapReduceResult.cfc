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

}
