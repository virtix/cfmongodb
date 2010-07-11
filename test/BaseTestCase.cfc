<cfcomponent output="false" extends="mxunit.framework.TestCase">

	<cfset dbName = "cfmongodb_tests">
	<cfset mongo = createObject("component","cfmongodb.core.Mongo").init()>

	<cffunction name="getCollectionName">
		<cfreturn lCase(listLast( getMetadata(this).Name ,"."))>
	</cffunction>

</cfcomponent>