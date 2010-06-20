<cfcomponent output="false">

	<cfproperty name="name" type="String" />

	<cffunction name="getName" access="public" output="false" returntype="String">
		<cfreturn this.name />
	</cffunction>

	<cffunction name="setName" access="public" output="false" returntype="void">
		<cfargument name="name" type="String" required="true" />
		<cfset this.name = arguments.name />
		<cfreturn />
	</cffunction>
</cfcomponent>