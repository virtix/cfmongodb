<cfcomponent output="true" extends="cfmongodb.components.MongoDocument">

	<cfproperty name="name" />
	<cfproperty name="email" />
	<cfproperty name="street" />
  	<cfproperty name="city" />
	<cfproperty name="state" />
	<cfproperty name="zip" />
	<cfproperty name="colors" type="array" />
  	<cfset super.init( collection_name='members' ) />

<!--- Representation invariant. To Do --->
 <cffunction name="validate" returntype="void" hint="Called before save(). Should throw exception on failure.">
  
 </cffunction>
 
 
</cfcomponent>