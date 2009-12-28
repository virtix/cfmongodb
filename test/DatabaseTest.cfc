<cfcomponent extends="mxunit.framework.TestCase">
<cfscript>
 function testThis(){
   db = createObject('component','cfmongodb.components.Database');
   debug(db.getDB('some_db').toString());
 }

</cfscript>
</cfcomponent>