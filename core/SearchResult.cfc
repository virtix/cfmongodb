<cfcomponent>
<cfscript>

	mongoCursor = "";
	query = "";
	mongoUtil = "";

	function init ( mongoCursor, mongoUtil ){
		structAppend( variables, arguments );
		query = mongoCursor.getQuery();
		return this;
	}

	/**
	* The fastest return type... returns the case-sensitive cursor which you'd iterate over with
	while(cursor.hasNext()) {cursor.next();}

	Note: you can use the cursor object to get full access to the full API at http://api.mongodb.org/java
	*/
	function asCursor(){
		return mongoCursor;
	}

	/**
	* Converts all cursor elements into a ColdFusion structure and returns them as an array of structs.
	*/
	function asArray(){
		res = [];
		while(mongoCursor.hasNext()){
			arrayAppend( res, mongoUtil.dbObjectToStruct( mongoCursor.next() ) );
		}
		return res;
	}

	/**
	* The number of elements in the result, after limit and skip are applied
	*/
	function size(){
		return mongoCursor.size();
	}

	/**
	* The total number of elements for the query, before limit and skip are applied
	*/
	function totalCount(){
		return mongoCursor.count();
	}

	/**
	* Mongo's native explain command. Useful for debugging and performance analysis
	*/
	function explain(){
		return mongoCursor.explain();
	}

	/**
	* The criteria used for the query. Use getQuery().toString() to get a copy/paste string for the Mongo shell
	*/
	function getQuery(){
		return query;
	}

</cfscript>
</cfcomponent>