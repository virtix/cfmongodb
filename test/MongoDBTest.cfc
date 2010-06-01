<cfcomponent extends="BaseTestCase">

	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">


	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">

	</cffunction>

	<cffunction name="db_returns_cfmongodb_db">
		<cfset var db = mongo.db(dbName)>
		<cfset debug(db)>
		<cfset assertIsExactTypeOf(db,"cfmongodb.components.Database")>
	</cffunction>

	<cffunction name="collection_returns_cfmongodb_collection" output="false" access="public" returntype="any" hint="">
		<cfset var coll = mongo.collection(dbName,basicCollectionName)>
		<!---<cfset debug(coll)>--->
		<cfset assertIsExactTypeOf(coll,"cfmongodb.components.Collection")>
	</cffunction>


</cfcomponent>
