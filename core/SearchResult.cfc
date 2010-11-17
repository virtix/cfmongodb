<cfcomponent>
<cfscript>

	mongoCursor = "";
	query = "";
	mongoUtil = "";

	documents = "";
	count = "";
	tCount = "";

	function init ( mongoCursor, sort, mongoUtil ){
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
		if( isSimpleValue(documents) ){
			documents = [];
			while(mongoCursor.hasNext()){
				var doc = mongoUtil.toCF( mongoCursor.next() );
				arrayAppend( documents, doc );
			}
		}
		return documents;
	}

	/**
	* The number of elements in the result, after limit and skip are applied
	*/
	function size(){
		if( count eq "" ){
			//designed to reduce calls to mongo... mongoCursor.size() will additionally query the database, and arrayLen() is faster
			if( isArray( documents ) ){
				count = arrayLen( documents );
			} else {
				count = mongoCursor.size();
			}
		}
		return count;
	}

	/**
	* The total number of elements for the query, before limit and skip are applied
	*/
	function totalCount(){
		if( variables.tCount eq "" ){
			variables.tCount = mongoCursor.count();
		}
		return variables.tCount;
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

	/**
	* The sort used for the query. use getSort().toString() to get a copy/paste string for the Mongo shell
	*/
	function getSort(){
		return sort;
	}

</cfscript>
</cfcomponent>