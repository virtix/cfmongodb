<cfcomponent output="false">
	<cfset this.name = 'cfmongodb' />
	<cfset this.applicationTimeout = createTimeSpan(1, 0, 0, 0) />
	<cfset this.clientManagement = false />
	<cfset this.sessionManagement = false />
	
	<!--- Set the mappings --->
	<cfset variables.mappingBase = getDirectoryFromPath( getCurrentTemplatePath() ) />
	
	<cfset this.mappings['/cfmongodb'] = variables.mappingBase />
	<cfset this.mappings['/test'] = variables.mappingBase & 'test' />
</cfcomponent>