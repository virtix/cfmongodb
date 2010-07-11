<cfcomponent extends="BaseTestCase">
	<cffunction name="newDBObjectFromStruct_should_return_initialized_DBObject_when_input_is_empty" returntype="void" access="public">
		<cfset var dbo = mongo.newDBObjectFromStruct({})>
		<cfset var str = dbo.toString()>
		<cfset debug(dbo)>
		<cfset debug(getMetadata(dbo))>
		<cfset debug(str)>
		<cfset assertTrue(structIsEmpty(dbo))>
		<cfset assertEquals("{ }",str)>
	</cffunction>

	<cffunction name="newDBObjectFromStruct_should_return_populated_DBObject_when_input_struct_has_data" returntype="void" access="public">
		<cfset var input = {NAME="cfmongodb"}>
		<cfset var dbo = mongo.newDBObjectFromStruct(input)>
		<cfset assertTrue(structKeyExists(dbo,"NAME"))>
	</cffunction>

	<cffunction name="newDBObject_should_return_single_key_Object" output="false" access="public" returntype="any" hint="">
		<cfset var dbo = mongo.newDBObject("NAME","cfmongodb")>
		<cfset assertEquals("NAME",structKeyList(dbo))>
		<cfset assertEquals("cfmongodb",dbo["NAME"],"")>
	</cffunction>

	<cffunction name="getObjectIDFromID_should_return_java_ObjectID" output="false" access="public" returntype="any" hint="">
		<cfset var objectID = mongo.getObjectIDFromID("4c0278fefc60eebfd097f017")>
		<cfset assertEquals("com.mongodb.ObjectID", getMetadata(objectID).getCanonicalName() )>
	</cffunction>

	<cffunction name="dbObjectToStruct_returns_struct_with_all_nested_data" output="false" access="public" returntype="any" hint="">
		<cfset var nested = mongo.newDBObject("nested",true)>
		<cfset var topLevel = mongo.newDBObject("toplevel",nested)>
		<cfset var struct = mongo.dbObjectToStruct(topLevel)>
		<cfset debug(struct)>
		<cfset assertEquals("toplevel",structKeyList(struct))>
		<cfset assertEquals("nested",structKeyList(struct.toplevel))>
	</cffunction>

	<cffunction name="newIDCriteriaObject_returns_correctly_populated_DBObject" output="false" access="public" returntype="any" hint="">
		<cfset var id = "4c0278fefc60eebfd097f017">
		<cfset var idObject = mongo.newIDCriteriaObject(id)>
		<cfset assertEquals("_id",structKeyList(idObject))>
		<cfset assertEquals(id,idObject["_id"])>
	</cffunction>

</cfcomponent>
