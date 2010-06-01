<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
	mongo = createObject('component','cfmongodb.Mongo').init();
 </cfscript>
</cfcomponent>