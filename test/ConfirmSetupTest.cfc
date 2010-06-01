<cfcomponent extends="BaseTestCase">



	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset collectionName = getCollectionName()>
		<cfset fillBasicCollection()>
	</cffunction>

	<cffunction name="teardown">
		<cfset mongo.remove(StructNew(),dbName,collectionName)>
	</cffunction>

	<cffunction name="fillBasicCollection" output="false" access="package" returntype="any" hint="">
		<cfset var i = 1>
		<cfset var tmp = {}>
		<cfloop from="1" to="10" index="i">
			<cfset tmp = { number=i, string="this is string #i#", date=now(), boolean=true }>
			<cfset var result = mongo.update(tmp,dbName,collectionName)>
		</cfloop>
	</cffunction>


	<cffunction name="when_mongo_is_running_this_should_work" returntype="void" access="public">
		<cfset debug(getMetadata(mongo.getMongo()))>
		<!--- guard: ensure that getMongo() returns the real java object --->
		<cfset assertEquals("com.mongodb.Mongo", getMetadata(mongo.getMongo()).getCanonicalName() )>
		<cfset var names = mongo.getMongo().getDatabaseNames()>
		<cfset debug(names)>
		<cfset assertTrue(arrayLen(names) GT 0)>
	</cffunction>

	<cffunction name="getMongoDB_returns_valid_mongo_DB_object">
		<!--- this should not error! --->
		<cfset var db = mongo.getMongoDB("local")>
	</cffunction>

</cfcomponent>
