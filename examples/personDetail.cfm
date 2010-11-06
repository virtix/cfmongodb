<cfinclude template="initMongo.cfm">

<cfset person = mongo.findById(url.id, "people")>
<h1>Person <cfoutput>#url.id#</cfoutput></h1>
<cfdump var="#person#">

<cfset mongo.close()>
