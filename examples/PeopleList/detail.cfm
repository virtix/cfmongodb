
<cfset person = application.mongo.findById(url.id, application.collection)>
<h1>Person <cfoutput>#url.id#</cfoutput></h1>
<cfdump var="#person#">
