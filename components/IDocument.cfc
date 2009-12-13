<cfinterface displayName="IDocument" hint="All MongoDB Documents should implement this interface. Basic ColdFusion structures can also be saved to the datastore. But from an OO design perspective, it's a good practice to implement this interface">

<cffunction name="setCollection" hint="Sets the collection to which this Document instance belongs. This should be called prior to any other operations. If not, the default Collection, if any, will be the container for this Document."></cffunction>

<cffunction name="set" hint="Sets a  property for the Document" returntype="void">
  <cfargument name="property" type="String" />
  <cfargument name="value" type="Any" />
</cffunction>

<cffunction name="get" hint="Fetches the value of the given property. Returns null if not found." returntype="Any">
  <cfargument name="property" />
</cffunction>

<cffunction name="remove" returntype="void">
  <cfargument name="property" hint="Removes the given property if it exists." />
</cffunction>

<cffunction name="save" hint="Commits this Document instance to the datastore and returns an ID" returntype="String"></cffunction>

<cffunction name="update" hint="Performs in-place updating - Instead of retrieving and updating every item within a document, this method is more efficient, allowing for 'Cherry Picking' of specific data elements to update. ">
 <cfargument name="field">
<cfargument name="value">
</cffunction>

</cfinterface>