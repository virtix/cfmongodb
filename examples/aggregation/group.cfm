<!---run load.cfm to get the data that this group() will use! Note that it is entirely fake/random data.
<cfinclude template="load.cfm">--->


<cfinclude template="../initMongo.cfm">


<cfscript>
	collectionName = "tasks";
	collection = mongo.getMongoDBCollection(collectionName);
	mongoUtil = mongo.getMongoUtil();
	keys = mongoUtil.toMongo( {STATUS=true, OWNER=true} );
	initial = mongoUtil.toMongo( {TOTAL=0, TOTALTIMETOCOMPLETE=0, TOTALPENDINGTIME=0, VALS=[]} );
	//writeDump(initial.toString());
	emptyCondition = mongoUtil.toMongo({});

	statusGroups = collection.group(
		keys,
		emptyCondition,
		initial,
		"function(obj,agg) {
			agg.TOTAL++;

			if( obj.COMPLETETS ){
				agg.TOTALTIMETOCOMPLETE += ( obj.COMPLETETS.getTime() - obj.ADDEDTS.getTime() );
			}

			if( obj.STARTTS ){
				//it's been started... calculate from the STARTTS
				agg.TOTALPENDINGTIME += ( obj.STARTTS.getTime() - obj.ADDEDTS.getTime() );
			} else {
				//it's not yet started... calculate from now
				agg.TOTALPENDINGTIME += ( new Date().getTime() - obj.ADDEDTS.getTime() );
			}
			//agg.VALS.push(obj); //uncomment this to see all the objects that came through here; warning, this will add a lot of time to the writeDump
		}"
	);

	mongo.close();
</cfscript>

<cfoutput>
	<h1>Raw group() Demo</h1>
	<p>This shows how to use MongoDB's group() function directly, without going through cfmongodb. Note that it uses mongoUtil to ensure proper datatype conversion</p>
	<p>The data are randomly generated in load.cfm. </p>
	<cfloop array="#statusGroups#" index="group">
		<h2>Group #group.STATUS#, OWNER: #group.OWNER#</h2>
		 Total: #group.TOTAL#<br>
		 Total Pending Time: #(group.TOTALPENDINGTIME/1000)/group.TOTAL# seconds <br>
		 Total Time to Complete:

		 <cfif group.STATUS eq "C">
		 	#(group.TOTALTIMETOCOMPLETE/1000)/group.TOTAL# <br>
		 <cfelse>
		 	not yet complete
		 </cfif>
	</cfloop>
</cfoutput>

<cfdump var="#statusGroups#" label="Status Groups">

