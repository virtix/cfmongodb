
<cfinclude template="initMongo.cfm">

<!--- <cfinclude template="loadPeople.cfm"> --->

<cfparam name="url.limit" default="25">
<cfparam name="url.skip" default="0">
<cfparam name="url.sort" default="NAME">
<cfparam name="url.direction" default="1">

<cfset results = mongo.query("people")
						.$exists("COUNTER")
						.search(skip=url.skip, limit = url.limit, sort="#url.sort#=#url.direction#")>

<cfset people = results.asArray()>

<cfoutput>
<p align="center">Showing #url.skip+1# through #results.size()# of #results.totalCount()# People</p>


<cfsavecontent variable="navlinks">
	<cfif results.totalCount() GT results.size()>
		<p align="center" class="pagination">
		<span>
			<a href="peopleList.cfm?skip=#url.skip-url.limit#">Previous</a>
		</span>

		<span>
			<a href="peopleList.cfm?skip=#url.skip+url.limit#">Next</a>
		</span>
		</p>
	</cfif>
</cfsavecontent>

#navlinks#

<!--- see all this structKeyExists() stuff below... this is why you want to keep your documents structured the same... so you don't need this! --->
<table border="1" align="center">
	<thead>
		<tr>
			<th>N</th>
			<th>Name</th>
			<th>Spouse</th>
			<th>Kids</th>
		</tr>
	</thead>


	<tbody>
	<cfloop array="#people#" index="person">
		<tr>
			<td>  #IIF( structKeyExists(person, "counter") , DE("#person.counter#"), DE('&nbsp;') )#  </td>
			<td> <a href="personDetail.cfm?id=#person['_id'].toString()#">#person.name#</a> </td>
			<td>  #IIF( structKeyExists(person, "spouse") , DE("#person.spouse#"), DE('&nbsp;') )#  </td>
			<td>
				<cfif structKeyExists(person, "kids")>
					<cfloop array="#person.kids#" index="kid">
						#kid.name# |
					</cfloop>
				<cfelse>
				None
				</cfif>
			</td>
		</tr>
	</cfloop>
	</tbody>
</table>

#navlinks#

</cfoutput>
<cfset mongo.close()>

