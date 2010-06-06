<cfcomponent extends="BaseTestCase">

	<cffunction name="init_should_return_mongodb_object" returntype="void">
    	<cfset var mongo = createObject("cfmongodb.Mongo").init()>
		<cfset assertIsExactTypeOf(mongo,"cfmongodb.components.MongoDB")>
    </cffunction>

</cfcomponent>
