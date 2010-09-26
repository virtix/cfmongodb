<cfcomponent>

	<cffunction name="init" output="false" access="public" returntype="any" hint="">
		<cfreturn this>
    </cffunction>
    
	<cffunction name="getObject" output="false" access="public" returntype="any" hint="">
    	<cfargument name="path" type="string" required="true"/>
		<cfreturn createObject("java", path)>
    </cffunction>
    
</cfcomponent>