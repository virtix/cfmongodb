

<cfparam name="url.debug" default="false">

<cfset dir = getDirectoryFromPath(getCurrentTemplatePath()) />
<cfset DTS = createObject("component","mxunit.runner.DirectoryTestSuite")>

<cfinvoke component="#DTS#"
	method="run"
	directory="#dir#"
	componentpath="cfmongodb.test"
	recurse="true"
	excludes=""
	returnvariable="Results">

<cfif NOT StructIsEmpty(DTS.getCatastrophicErrors())>
	<cfdump var="#DTS.getCatastrophicErrors()#" expand="false" label="#StructCount(DTS.getCatastrophicErrors())# Catastrophic Errors">
</cfif>

<cfsetting showdebugoutput="true">
<cfoutput>#results.getResultsOutput("html")#</cfoutput>

<cfif isBoolean(url.debug) AND url.debug>
	<div class="bodypad">
		<cfdump var="#results.getResults()#" label="Debug">
	</div>
</cfif>