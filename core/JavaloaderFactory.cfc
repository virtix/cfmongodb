<cfcomponent accessors="true" output="false">

	<cfproperty name="javaloader">

	<cffunction name="init" output="false" access="public" returntype="any" hint="">
		<cfargument name="javaloader" type="any" required="false" default="" hint="If you don't provide a fully initialized javaloader instance, we'll attempt to provide one for you"/>

		<cfif isSimpleValue(arguments.javaloader)>
			<cfset var jarPaths = directoryList( expandPath("/cfmongodb/lib"), false, "path", "*.jar" )>
			<cfset variables.javaloader = createObject('component','cfmongodb.lib.javaloader.javaloader').init(jarPaths)>
		<cfelse>
			<cfset variables.javaloader = arguments.javaloader>
		</cfif>

		<cfreturn this>
    </cffunction>

	<cffunction name="getObject" output="false" access="public" returntype="any">
    	<cfargument name="path" type="string" required="true"/>
		<cfreturn javaloader.create(path)>
    </cffunction>

</cfcomponent>