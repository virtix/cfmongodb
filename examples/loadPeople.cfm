<cfset dbName = "mongorocks">
<cfset collection = "people">

<cfif not structKeyExists(variables, "mongo")>
	<cfinclude template="initMongo.cfm">
</cfif>

<cfscript>

counters = mongo.distinct( "COUNTER",collection );
arraySort( counters, "numeric", "desc"  );

if( NOT arrayIsEmpty(counters) ){
	nextNum = counters[1] + 1;
} else {
	nextNum = 1;
}

coolPeople = [];
for( i = nextNum; i LTE nextNum + 50; i++ ){
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
</cfscript>