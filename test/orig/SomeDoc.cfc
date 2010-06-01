<cfcomponent output="false" implements="cfmongodb.components.IDocument">
<!---
  By implementing IDocument, this will also implement a convention
  over configuration approach.
--->

<cffunction name="setCollection">
</cffunction>

<cffunction name="save" returntype="String">
	<cfreturn 'my_id'>
</cffunction>


<cffunction name="update">
 <cfargument name="field">
<cfargument name="value">
</cffunction>



</cfcomponent>