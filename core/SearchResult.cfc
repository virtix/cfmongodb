<cfcomponent>
<cfscript>

	mongoCursor = "";
	query = "";
	mongoUtil = "";

	function init ( mongoCursor, query, mongoUtil ){
		structAppend( variables, arguments );
		return this;
	}

	/**
	* The fastest return type... returns the case-sensitive cursor which you'd iterate over with while(cursor.hasNext()) {cursor.next();}
	*/
	function asCursor(){
		return mongoCursor;
	}

	/**
	* Converts all cursor elements into a ColdFusion structure and returns them as an array
	*/
	function asArray(){
		res = [];
		while(mongoCursor.hasNext()){
			arrayAppend( res, mongoUtil.dbObjectToStruct( mongoCursor.next() ) );
		}
		return res;
	}

	function size(){
		return mongoCursor.size();
	}

	function totalCount(){
		return mongoCursor.count();
	}

	function explain(){
		return mongoCursor.explain();
	}

	function getQuery(){
		return query;
	}

</cfscript>
</cfcomponent>