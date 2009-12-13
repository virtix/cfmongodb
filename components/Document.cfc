<cfcomponent output="false" implements="IDocument" hint="Default implementation of IDocument and used by the Mongo class to generate a document.">

<cfset this.__props__ =  structNew() />
<cfset mongo = createObject('component', 'MongoDB') />


<cffunction name="init" hint="Constructor">
 	<cfargument name="collection_name" type="string" required="true" />
  	<cfset mongo.collection(collection_name) />
	<cfreturn this /> 
</cffunction>

<cffunction name="setCollection">
</cffunction>


<cffunction name="set" hint="Sets a  property for the Document" returntype="void">
  <cfargument name="property" type="String" />
  <cfargument name="value" type="Any" />
  <cfset structInsert(this.__props__, arguments.property, arguments.value) />
</cffunction>


<cffunction name="get" hint="Fetches the value of the given property. Returns null if not found." returntype="Any">
  <cfargument name="property" />
  <cfset var ret_val = javacast('null', '') />
  <cftry>
	<cfset ret_val = this.__props__[arguments.property] />
	<cfcatch type="Expression">
	 <!--- want to return null --->
	</cfcatch>
	</cftry>
  <cfreturn ret_val />
</cffunction>

<cffunction name="remove" returntype="void">
  <cfargument name="property" hint="Removes the given property if it exists." />
</cffunction>



<cffunction name="save" returntype="String">
	<cfreturn mongo.put(this.__props__) />
</cffunction>

<cffunction name="delete" returntype="void" hint="Deletes this Document from the Collection">
   <cfargument name="id" hint="ID to remove" />
  <!--- todo: try ... catch --->
   <cfset mongo.deleteById(arguments.id.toString()) />
</cffunction>

<cffunction name="update">
 <cfargument name="field">
 <cfargument name="value">
</cffunction>



</cfcomponent>