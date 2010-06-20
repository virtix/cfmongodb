<cfcomponent output="true" extends="cfmongodb.components.MongoDocument">

	<cfproperty name="name" default="bill" />
	<cfproperty name="address" />
  	<cfproperty name="city" />
  	<cfset super.init( collection_name='members' ) />


<!--- Representation invariant --->
 <cffunction name="validate" returntype="void" hint="Called before save(). Should throw exception on failure.">
   <cfif len( this.model.name) gt 100>
     <cfthrow type="ModelFuckedUpException" message="hey, punk." />
    </cfif> 
 </cffunction>
 
 
</cfcomponent>