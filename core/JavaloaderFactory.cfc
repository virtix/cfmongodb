<cfcomponent>
	
	<cffunction name="init" output="false" access="public" returntype="any" hint="">
		<cfargument name="javaloader" type="any" required="true"/>
		<cfset variables.javaloader = arguments.javaloader>
		<cfreturn this>
    </cffunction>
	
	<cffunction name="getObject" output="false" access="public" returntype="any" hint="">
    	<cfargument name="path" type="string" required="true"/>
		<cfreturn javaloader.create(path)>
    </cffunction>
	
</cfcomponent>