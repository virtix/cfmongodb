<cfcomponent hint="generates html file cfc docs" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ColdDoc" output="false">
	<cfscript>
		variables.instance = {};

		return this;
	</cfscript>
</cffunction>

<cffunction name="generate" hint="generates the docs" access="public" returntype="void" output="true">
	<cfargument name="inputSource" hint="either, the string directory source, OR an array of structs containing inputDir and inputMapping key" type="any" required="yes">
	<cfargument name="outputDir" hint="the output directory" type="string" required="Yes">
	<cfargument name="inputMapping" hint="the base mapping for the folder" type="string" required="false" default="">
	<cfargument name="projectTitle" hint="the title of the project" type="string" required="No" default="Untitled">
	<cfscript>
		var basePath = getDirectoryFromPath(getMetaData(this).path);
		var args = 0;
		var qMetaData = 0;
		var source = 0;

		if(isSimpleValue(arguments.inputSource))
		{
			source = [{ inputDir=arguments.inputSource, inputMapping=arguments.inputMapping }];
		}
		else
		{
			source = arguments.inputSource; // buildMetaDataCollection( ) needs array of structs
		}

		
		qMetaData = buildMetaDataCollection( source );
		//dump(qMetaData);

		recursiveCopy(basePath & "resources/static", arguments.outputDir);

		//write the index template
		args = {path=arguments.outputDir & "/index.html", template="index.html", projectTitle=arguments.projectTitle};
		writeTemplate(argumentCollection=args);

		writeOverviewSummaryAndFrame(arguments.outputDir, arguments.projectTitle, qMetaData);

		writeAllClassesFrame(arguments.outputDir, qMetaData);

        
		writePackagePages(arguments.outputDir, arguments.projectTitle, qMetaData);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="writePackagePages" hint="writes the package summaries" access="private" returntype="void" output="false">
	<cfargument name="outputDir" hint="the output directory" type="string" required="Yes">
	<cfargument name="projectTitle" hint="the title of the project" type="string" required="yes">
	<cfargument name="qMetadata" hint="the meta data query" type="query" required="Yes">
	<cfscript>
		var currentDir = 0;
		var qPackage = 0;
	</cfscript>

	<cfoutput query="arguments.qMetaData" group="package">
		<cfscript>
			currentDir = arguments.outputDir & "/" & replace(package, ".", "/", "all");
			ensureDirectory(currentDir);
			qPackage = getMetaSubquery(arguments.qMetaData, "package = '#package#'", "name asc");

			writeTemplate(path=currentDir & "/package-summary.html",
						template="package-summary.html",
						projectTitle = arguments.projectTitle,
						package = package,
						qPackage = qPackage);

			writeTemplate(path=currentDir & "/package-frame.html",
						template="package-frame.html",
						projectTitle = arguments.projectTitle,
						package = package,
						qPackage = qPackage);


			buildClassPages(arguments.outputDir,
							arguments.projectTitle,
							qPackage,
							arguments.qMetadata
							);
		</cfscript>
	</cfoutput>
</cffunction>

<cffunction name="buildClassPages" hint="builds the class pages" access="private" returntype="void" output="false">
	<cfargument name="outputDir" hint="the output directory" type="string" required="Yes">
	<cfargument name="projectTitle" hint="the title of the project" type="string" required="yes">
	<cfargument name="qPackage" hint="the query for a specific package" type="query" required="Yes">
	<cfargument name="qMetadata" hint="the meta data query" type="query" required="Yes">
	<cfscript>
		var qSubClass = 0;
		var currentDir = 0;
	</cfscript>
	<cfloop query="arguments.qPackage">
		<cfscript>
			currentDir = arguments.outputDir & "/" & replace(package, ".", "/", "all");
			qSubClass = getMetaSubquery(arguments.qMetaData, "extends = '#package#.#name#'", "package asc, name asc");

			writeTemplate(path=currentDir & "/#name#.html",
						template="class.html",
						projectTitle = arguments.projectTitle,
						package = package,
						name = name,
						qSubClass = qSubClass,
						qMetadata = qMetaData,
						metadata = metadata
						);
		</cfscript>
	</cfloop>
</cffunction>

<cffunction name="writeOverviewSummaryAndFrame" hint="writes the overview-summary.html" access="private" returntype="void" output="false">
	<cfargument name="outputDir" hint="the output directory" type="string" required="Yes">
	<cfargument name="projectTitle" hint="the title of the project" type="string" required="yes">
	<cfargument name="qMetadata" hint="the meta data query" type="query" required="Yes">
	<cfscript>
		var qPackages = 0;
	</cfscript>
		<cfquery name="qPackages" dbtype="query" debug="false">
			SELECT DISTINCT
				package
			FROM
				arguments.qMetaData
			ORDER BY
				package
		</cfquery>

	<cfscript>
		writeTemplate(path=arguments.outputDir & "/overview-summary.html",
					template="overview-summary.html",
					projectTitle = arguments.projectTitle,
					qPackages = qPackages);


		//overview frame
		writeTemplate(path=arguments.outputDir & "/overview-frame.html",
					template="overview-frame.html",
					projectTitle=arguments.projectTitle,
					qPackages = qPackages);
	</cfscript>

</cffunction>



<cffunction name="writeAllClassesFrame" hint="writes the allclasses-frame.html" access="private" returntype="void" output="false">
	<cfargument name="outputDir" hint="the output directory" type="string" required="Yes">
	<cfargument name="qMetadata" hint="the meta data query" type="query" required="Yes">
	<cfscript>
		arguments.qMetadata = getMetaSubquery(query=arguments.qMetaData, orderby="name asc");

		writeTemplate(path=arguments.outputDir & "/allclasses-frame.html",
					template="allclasses-frame.html",
					qMetaData = arguments.qMetaData);
	</cfscript>

</cffunction>

<cffunction name="getMetaSubQuery" hint="returns a query on the meta query" access="private" returntype="query" output="false">
	<cfargument name="query" hint="the meta data query" type="query" required="Yes">
	<cfargument name="where" hint="the where string" type="string" required="false">
	<cfargument name="orderby" hint="the order by string" type="string" required="false">
	<cfset qSub = 0 />
	<cfquery name="qSub" dbtype="query" debug="false">
		SELECT *
		from
		arguments.query
		<cfif StructKeyExists(arguments, "where")>
			WHERE
			#PreserveSingleQuotes(arguments.where)#
		</cfif>
		<cfif StructKeyExists(arguments, "orderby")>
			ORDER BY
			#arguments.orderby#
		</cfif>
	</cfquery>
	<cfreturn qSub />
</cffunction>

<cffunction name="buildMetaDataCollection" hint="builds the searchable meta data collection" access="private" returntype="query" output="true">
	<cfargument name="inputSource" hint="an array of structs containing inputDir and inputMapping" type="array" required="yes"> <!--- of struct --->

	<cfscript>
		var qFile = 0;
		var qMetaData = QueryNew("package,name,extends,metadata");
		var cfcPath = 0;
		var packagePath = 0;
		var cfcName = 0;
		var meta = 0;
		var i = 0;
	</cfscript>

    <cfloop index="i" from="1" to="#ArrayLen(arguments.inputSource)#">

        <cfdirectory action="list" directory="#arguments.inputSource[i].inputDir#" recurse="true" name="qFiles" filter="*.cfc">
         
        <cfloop query="qFiles">
			<cfif qFiles.type == 'File'>
            <cfscript>
                currentPath = replace(directory, arguments.inputSource[i].inputDir, "");
                currentPath = reReplace(currentPath, "[/\\]", "");
                currentPath = reReplace(currentPath, "[/\\]", ".", "all");
				//dump(currentPath);
/*
                if(len(arguments.inputSource[i].inputMapping))
                {
                   packagePath = arguments.inputSource[i].inputMapping;
                   // packagePath = ListAppend(arguments.inputSource[i].inputMapping, currentPath, ".");
                }
                else
                {
                    //packagePath = arguments.inputSource[i].inputMapping;
                    packagePath = ListAppend(arguments.inputSource[i].inputMapping, currentPath, ".");
                }
*/

                if(len(currentPath)) //always going to evaluate to true?
                {
                    packagePath = ListAppend(arguments.inputSource[i].inputMapping, currentPath, ".");
                    dump(packagePath);
                }
                else
                {
                    packagePath = arguments.inputSource[i].inputMapping;
                }

                cfcName = ListGetAt(name, 1, ".");

				try
				{
	                if (Len(packagePath)) {
	                    meta = getComponentMetaData(packagePath & "." & cfcName);
	                }
	                else {
	                    meta = getComponentMetaData(cfcName);
	                }

					QueryAddRow(qMetaData);
	                QuerySetCell(qMetaData, "package", packagePath);
	                QuerySetCell(qMetaData, "name", cfcName);
	                QuerySetCell(qMetaData, "metadata", meta);

	                //so we cane easily query direct desendents
	                if(StructKeyExists(meta, "extends"))
	                {
	                    QuerySetCell(qMetaData, "extends", meta.extends.name);
	                }
	                else
	                {
	                    QuerySetCell(qMetaData, "name", "-");
	                }

				}
				catch(Any exc)
				{
					warnError(packagePath & "." & cfcName, exc);
				}

            </cfscript>
    </cfif> 
	   </cfloop>
     
	</cfloop>

	<cfreturn qMetaData />
</cffunction>

<cffunction name="warnError" hint="Warn the user that there was an error through cftrace" access="private" returntype="void" output="false">
	<cfargument name="cfcName" hint="the name of the cfc" type="string" required="Yes">
	<cfargument name="error" hint="the error struct" type="any" required="Yes">
	<cfset var dump = 0 />
	<!---<cfsavecontent variable="dump">
		<cfdump var="#arguments.error#" >
	</cfsavecontent>--->
	<cftrace category="ColdDoc" inline="true" type="Warning" text="Warning, the following script has errors: #arguments.cfcName#, Type:#toString(arguments.error)#, Message: #arguments.error.message# ">
</cffunction>

<cffunction name="safeFunctionMeta" hint="sets default values" access="private" returntype="any" output="false">
	<cfargument name="func" hint="the function meta" type="any" required="Yes">
	<cfargument name="metadata" hint="the original meta data" type="struct" required="Yes">
	<cfscript>
		var local = {};

		if(NOT StructKeyExists(arguments.func, "returntype"))
		{
			arguments.func.returntype = "any";
		}

		if(NOT StructKeyExists(arguments.func, "access"))
		{
			arguments.func.access = "public";
		}

		//move the cfproperty hints onto functions
		if(StructKeyExists(arguments.metadata, "properties"))
		{
			if(Lcase(arguments.func.name).startsWith("get") AND NOT StructKeyExists(arguments.func, "hint"))
			{
				local.name = replaceNoCase(arguments.func.name, "get", "");
				local.property = getPropertyMeta(local.name, arguments.metadata.properties);

				if(structKeyExists(local.property, "hint"))
				{
					arguments.func.hint = "get: " & local.property.hint;
				}

			}
			else if(LCase(arguments.func.name).startsWith("set") AND NOT StructKeyExists(arguments.func, "hint"))
			{
				local.name = replaceNoCase(arguments.func.name, "set", "");
				local.property = getPropertyMeta(local.name, arguments.metadata.properties);

				if(structKeyExists(local.property, "hint"))
				{
					arguments.func.hint = "set: " & local.property.hint;
				}
			}
		}

		return arguments.func;
	</cfscript>
</cffunction>

<cffunction name="getPropertyMeta" hint="returns the property meta by a given name" access="private" returntype="struct" output="false">
	<cfargument name="name" hint="the name of the property" type="string" required="Yes">
	<cfargument name="properties" hint="the property meta" type="array" required="Yes">
	<cfscript>
		var local = {};
    </cfscript>
	<cfloop array="#arguments.properties#" index="local.property">
		<cfif local.property.name eq arguments.name>
			<cfreturn local.property />
		</cfif>
	</cfloop>
	<cfreturn StructNew() />
</cffunction>

<cffunction name="safeParamMeta" hint="sets default values" access="private" returntype="any" output="false">
	<cfargument name="param" hint="the param meta" type="any" required="Yes">
	<cfscript>
		if(NOT StructKeyExists(arguments.param, "type"))
		{
			arguments.param.type = "any";
		}

		return arguments.param;
	</cfscript>
</cffunction>

<cffunction name="writeTemplate" hint="builds a template" access="private" returntype="void" output="false">
	<cfargument name="path" hint="where to write the template" type="string" required="Yes">
	<cfargument name="template" hint="the tempalte to write out" type="string" required="Yes">
	<cfscript>
		var html = 0;
		var local = {}; //for local variables
	</cfscript>
	<cfsavecontent variable="html">
		<cfinclude template="resources/templates/#arguments.template#">
	</cfsavecontent>
	<cfscript>
		fileWrite(arguments.path, html);
	</cfscript>
</cffunction>

<cffunction name="recursiveCopy" hint="does a recursive copy from one dir to another" access="private" returntype="void" output="false">
	<cfargument name="fromDir" hint="the input directory" type="string" required="Yes">
	<cfargument name="toDir" hint="the output directory" type="string" required="Yes">
	<cfscript>
		var files = 0;
		var currentDir = "";
		var safeDir = "";

		arguments.fromDir = replaceNoCase(arguments.fromDir, "\", "/", "all");
		arguments.toDir = replaceNoCase(arguments.toDir, "\", "/", "all");
	</cfscript>
	<cfdirectory action="list" directory="#arguments.fromDir#" recurse="true" name="qFiles">

	<cfoutput group="directory" query="qFiles">

		<cfset safeDir = replaceNoCase(directory, "\", "/", "all") />

		<!--- dodge svn directories --->
		<cfif NOT FindNoCase("/.", directory)>
			<cfscript>
				currentDir = arguments.toDir & replaceNoCase(safeDir & "/", arguments.fromDir, "");
				ensureDirectory(currentDir);
			</cfscript>
			<cfoutput>
				<cfscript>
					if(type neq "dir")
					{
						fileCopy(directory & "/" & name, currentDir & name);
					}
				</cfscript>
			</cfoutput>
		</cfif>
	</cfoutput>
</cffunction>

<cffunction name="ensureDirectory" hint="if a directory doesn't exist, create it" access="private" returntype="void" output="false">
	<cfargument name="path" hint="" type="string" required="Yes">
	<cfif NOT directoryExists(arguments.path)>
		<cfdirectory action="create" directory="#arguments.path#">
	</cfif>
</cffunction>


<cffunction name="_trace">
	<cfargument name="s">
	<cfset var g = "">
	<cfsetting showdebugoutput="true">
	<cfsavecontent variable="g">
		<cfdump var="#arguments.s#">
	</cfsavecontent>
	<cftrace text="#g#">
</cffunction>

<cffunction name="_dump">
	<cfargument name="s">
	<cfargument name="abort" default="true">
	<cfset var g = "">
		<cfdump var="#arguments.s#">
		<cfif arguments.abort>
		<cfabort>
		</cfif>
</cffunction>

</cfcomponent>